import 'dart:async';
import 'dart:developer' as developer;

import 'package:signalr_netcore/signalr_client.dart';

import 'signalr_events.dart';
import 'signalr_hub_connection_factory.dart';
import 'signalr_models.dart';

class AmbulanceSignalRService {
  AmbulanceSignalRService({
    required SignalRHubConnectionFactory connectionFactory,
    required String hubUrl,
  }) : _connectionFactory = connectionFactory,
       _hubUrl = hubUrl;

  final SignalRHubConnectionFactory _connectionFactory;
  final String _hubUrl;

  HubConnection? _connection;
  SignalRConnectionState _state = SignalRConnectionState.disconnected;

  final _stateController = StreamController<SignalRConnectionState>.broadcast();
  final _locationUpdateController =
      StreamController<AmbulanceLocationUpdate>.broadcast();

  SignalRConnectionState get state => _state;
  Stream<SignalRConnectionState> get stateStream => _stateController.stream;
  Stream<AmbulanceLocationUpdate> get locationUpdates =>
      _locationUpdateController.stream;

  Future<void> connect() async {
    if (_state == SignalRConnectionState.connected ||
        _state == SignalRConnectionState.connecting) {
      return;
    }

    _emitState(SignalRConnectionState.connecting);
    try {
      _connection ??= await _connectionFactory.create(
        hubUrl: _hubUrl,
        loggerName: 'Rescufy.AmbulanceSignalR',
      );
      _registerConnectionHandlers(_connection!);
      _registerEventHandlers(_connection!);
      await _connection!.start();
      _emitState(SignalRConnectionState.connected);
    } catch (error, stackTrace) {
      _emitState(SignalRConnectionState.disconnected);
      developer.log(
        'Ambulance hub connection failed',
        name: 'Rescufy.AmbulanceSignalR',
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

  Future<void> joinRequestGroup(String requestId) async {
    await _invoke(AmbulanceHubMethods.joinRequestGroup, [requestId]);
  }

  Future<void> leaveRequestGroup(String requestId) async {
    await _invoke(AmbulanceHubMethods.leaveRequestGroup, [requestId]);
  }

  Future<void> updateLocation(AmbulanceLocationDto dto) async {
    await _invoke(AmbulanceHubMethods.updateLocation, [dto.toJson()]);
  }

  Future<void> acceptRequest(String requestId) async {
    await _invoke(AmbulanceHubMethods.acceptRequest, [requestId]);
  }

  void _registerConnectionHandlers(HubConnection connection) {
    connection.onreconnecting(({error}) {
      developer.log(
        'Ambulance hub reconnecting: $error',
        name: 'Rescufy.AmbulanceSignalR',
      );
      _emitState(SignalRConnectionState.reconnecting);
    });
    connection.onreconnected(({connectionId}) {
      developer.log(
        'Ambulance hub reconnected: $connectionId',
        name: 'Rescufy.AmbulanceSignalR',
      );
      _emitState(SignalRConnectionState.connected);
    });
    connection.onclose(({error}) {
      developer.log(
        'Ambulance hub closed: $error',
        name: 'Rescufy.AmbulanceSignalR',
      );
      _emitState(SignalRConnectionState.disconnected);
    });
  }

  void _registerEventHandlers(HubConnection connection) {
    connection.off(AmbulanceHubEvents.receiveLocationUpdate);
    connection.on(
      AmbulanceHubEvents.receiveLocationUpdate,
      _handleLocationUpdate,
    );
  }

  void _handleLocationUpdate(List<Object?>? args) {
    try {
      final payload = _payloadFromArgs(args);
      final requestId = _readString(payload, const [
        SignalRPayloadKeys.requestId,
        'RequestId',
      ]);
      final latitude = _readDouble(payload, const [
        SignalRPayloadKeys.latitude,
        SignalRPayloadKeys.lat,
        'Latitude',
        'Lat',
      ]);
      final longitude = _readDouble(payload, const [
        SignalRPayloadKeys.longitude,
        SignalRPayloadKeys.lng,
        'Longitude',
        'Lng',
      ]);

      if (requestId == null || latitude == null || longitude == null) {
        throw FormatException('Invalid location update payload: $payload');
      }

      _locationUpdateController.add(
        AmbulanceLocationUpdate(
          requestId: requestId,
          latitude: latitude,
          longitude: longitude,
          updatedAt: _readDate(payload, const [
            SignalRPayloadKeys.updatedAt,
            'UpdatedAt',
            'timestamp',
          ]),
          raw: payload,
        ),
      );
    } catch (error, stackTrace) {
      developer.log(
        'Failed to process ambulance location update',
        name: 'Rescufy.AmbulanceSignalR',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _invoke(String method, List<Object> args) async {
    await connect();
    final connection = _connection;
    if (connection == null ||
        connection.state != HubConnectionState.Connected) {
      throw StateError('Ambulance hub is not connected.');
    }

    try {
      await connection.invoke(method, args: args);
    } catch (error, stackTrace) {
      developer.log(
        'Ambulance hub invoke failed: $method',
        name: 'Rescufy.AmbulanceSignalR',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
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

  double? _readDouble(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is num) {
        return value.toDouble();
      }
      if (value != null) {
        final parsed = double.tryParse(value.toString());
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return null;
  }

  DateTime? _readDate(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key]?.toString();
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
    _locationUpdateController.close();
    _connection?.stop();
  }
}
