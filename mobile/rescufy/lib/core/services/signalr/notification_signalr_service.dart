import 'dart:async';
import 'dart:developer' as developer;

import 'package:signalr_netcore/signalr_client.dart';

import 'signalr_events.dart';
import 'signalr_hub_connection_factory.dart';
import 'signalr_models.dart';

class NotificationSignalRService {
  NotificationSignalRService({
    required SignalRHubConnectionFactory connectionFactory,
    required String hubUrl,
  }) : _connectionFactory = connectionFactory,
       _hubUrl = hubUrl;

  final SignalRHubConnectionFactory _connectionFactory;
  final String _hubUrl;

  HubConnection? _connection;
  SignalRConnectionState _state = SignalRConnectionState.disconnected;

  final _stateController = StreamController<SignalRConnectionState>.broadcast();
  final _notificationController =
      StreamController<SignalRNotification>.broadcast();
  final _emergencyRequestController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _requestCancelledController = StreamController<String>.broadcast();
  final _statusChangedController =
      StreamController<RequestStatusUpdate>.broadcast();

  SignalRConnectionState get state => _state;
  Stream<SignalRConnectionState> get stateStream => _stateController.stream;
  Stream<SignalRNotification> get notifications =>
      _notificationController.stream;
  Stream<Map<String, dynamic>> get emergencyRequests =>
      _emergencyRequestController.stream;
  Stream<String> get requestCancelled => _requestCancelledController.stream;
  Stream<RequestStatusUpdate> get statusChanged =>
      _statusChangedController.stream;

  Future<void> connect() async {
    if (_state == SignalRConnectionState.connected ||
        _state == SignalRConnectionState.connecting) {
      return;
    }

    _emitState(SignalRConnectionState.connecting);
    try {
      _connection ??= await _connectionFactory.create(
        hubUrl: _hubUrl,
        loggerName: 'Rescufy.NotificationSignalR',
      );
      _registerConnectionHandlers(_connection!);
      _registerEventHandlers(_connection!);
      await _connection!.start();
      _emitState(SignalRConnectionState.connected);
    } catch (error, stackTrace) {
      _emitState(SignalRConnectionState.disconnected);
      developer.log(
        'Notification hub connection failed',
        name: 'Rescufy.NotificationSignalR',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> disconnect() async {
    try {
      await _connection?.stop();
    } finally {
      _connection = null;
      _emitState(SignalRConnectionState.disconnected);
    }
  }

  void _registerConnectionHandlers(HubConnection connection) {
    connection.onreconnecting(({error}) {
      developer.log(
        'Notification hub reconnecting: $error',
        name: 'Rescufy.NotificationSignalR',
      );
      _emitState(SignalRConnectionState.reconnecting);
    });
    connection.onreconnected(({connectionId}) {
      developer.log(
        'Notification hub reconnected: $connectionId',
        name: 'Rescufy.NotificationSignalR',
      );
      _emitState(SignalRConnectionState.connected);
    });
    connection.onclose(({error}) {
      developer.log(
        'Notification hub closed: $error',
        name: 'Rescufy.NotificationSignalR',
      );
      _emitState(SignalRConnectionState.disconnected);
    });
  }

  void _registerEventHandlers(HubConnection connection) {
    for (final eventName in NotificationHubEvents.all) {
      connection.off(eventName);
      connection.on(eventName, (args) => _handleEvent(eventName, args));
    }
  }

  void _handleEvent(String eventName, List<Object?>? args) {
    try {
      final payload = _payloadFromArgs(args);
      final notification = _notificationFromPayload(eventName, payload);
      _notificationController.add(notification);

      if (notification.isEmergencyRequest) {
        _emergencyRequestController.add(payload);
      }

      if (notification.type == SignalRNotificationType.requestCancelled &&
          notification.requestId != null) {
        _requestCancelledController.add(notification.requestId!);
      }

      if (notification.type == SignalRNotificationType.statusChanged &&
          notification.requestId != null &&
          notification.status != null) {
        _statusChangedController.add(
          RequestStatusUpdate(
            requestId: notification.requestId!,
            status: notification.status!,
            message: notification.message,
            updatedAt: notification.receivedAt,
            raw: notification.data,
          ),
        );
      }
    } catch (error, stackTrace) {
      developer.log(
        'Failed to process notification event "$eventName"',
        name: 'Rescufy.NotificationSignalR',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  SignalRNotification _notificationFromPayload(
    String eventName,
    Map<String, dynamic> payload,
  ) {
    final type = _typeFromEvent(eventName);
    return SignalRNotification(
      type: type,
      eventName: eventName,
      data: payload,
      requestId: _readString(payload, const [
        SignalRPayloadKeys.requestId,
        'RequestId',
        'id',
        'Id',
        'value',
      ]),
      title: _readString(payload, const [
        SignalRPayloadKeys.title,
        'Title',
        'subject',
      ]),
      message: _readString(payload, const [
        SignalRPayloadKeys.message,
        SignalRPayloadKeys.body,
        'Message',
        'Body',
        'description',
      ]),
      status: _readString(payload, const [SignalRPayloadKeys.status, 'Status']),
      receivedAt:
          _readDate(payload, const [
            SignalRPayloadKeys.updatedAt,
            'UpdatedAt',
          ]) ??
          DateTime.now(),
    );
  }

  SignalRNotificationType _typeFromEvent(String eventName) {
    switch (eventName) {
      case NotificationHubEvents.receiveNotification:
        return SignalRNotificationType.receiveNotification;
      case NotificationHubEvents.requestCreated:
        return SignalRNotificationType.requestCreated;
      case NotificationHubEvents.statusChanged:
        return SignalRNotificationType.statusChanged;
      case NotificationHubEvents.ambulanceReassigned:
        return SignalRNotificationType.ambulanceReassigned;
      case NotificationHubEvents.requestCancelled:
        return SignalRNotificationType.requestCancelled;
      case NotificationHubEvents.reportAdded:
        return SignalRNotificationType.reportAdded;
      case NotificationHubEvents.newRequest:
        return SignalRNotificationType.newRequest;
      case NotificationHubEvents.requestUpdated:
        return SignalRNotificationType.requestUpdated;
      case NotificationHubEvents.receiveEmergencyRequest:
        return SignalRNotificationType.receiveEmergencyRequest;
      default:
        return SignalRNotificationType.unknown;
    }
  }

  Map<String, dynamic> _payloadFromArgs(List<Object?>? args) {
    if (args == null || args.isEmpty || args.first == null) {
      return <String, dynamic>{};
    }

    final payload = args.first;
    if (payload is Map<String, dynamic>) {
      return payload;
    }
    if (payload is Map) {
      return payload.map((key, value) => MapEntry(key.toString(), value));
    }
    return {'value': payload.toString()};
  }

  String? _readString(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key]?.toString().trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  DateTime? _readDate(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key]?.toString().trim();
      if (value == null || value.isEmpty) continue;
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    return null;
  }

  void _emitState(SignalRConnectionState state) {
    _state = state;
    if (!_stateController.isClosed) {
      _stateController.add(state);
    }
  }

  void dispose() {
    _stateController.close();
    _notificationController.close();
    _emergencyRequestController.close();
    _requestCancelledController.close();
    _statusChangedController.close();
    _connection?.stop();
  }
}
