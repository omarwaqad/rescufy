// lib/presentation/paramedic/dashboard/cubit/dashboard_cubit.dart
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/services/signalr/notification_signalr_service.dart';
import 'package:rescufy/core/services/signalr/signalr_models.dart';
import 'package:rescufy/domain/repositories/paramedic_emergency_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required NotificationSignalRService notificationSignalRService,
    required ParamedicEmergencyRepository paramedicEmergencyRepository,
  }) : _notificationSignalR = notificationSignalRService,
       _paramedicEmergencyRepository = paramedicEmergencyRepository,
       super(DashboardState.initial());

  final NotificationSignalRService _notificationSignalR;
  final ParamedicEmergencyRepository _paramedicEmergencyRepository;
  StreamSubscription<SignalRConnectionState>? _connSub;
  StreamSubscription<Map<String, dynamic>>? _incomingRequestSub;
  StreamSubscription<int>? _requestCancelledSub;

  Future<void> initialize() async {
    _listenConnectionState();
    _listenIncomingRequests();
    _listenRequestCancelled();
    await _connect();
  }

  @override
  Future<void> close() async {
    await _connSub?.cancel();
    await _incomingRequestSub?.cancel();
    await _requestCancelledSub?.cancel();
    await super.close();
  }

  void toggleAvailability() => emit(state.copyWith(isOnline: !state.isOnline));

  void clearIncomingRequest() => emit(state.copyWith(clearRequest: true));

  // ── Private ───────────────────────────────────────────────────────────────

  Future<void> _connect() async {
    try {
      await _notificationSignalR.connect();
    } catch (e) {
      if (!isClosed) emit(state.copyWith(error: 'Connection failed: $e'));
    }
  }

  void _listenConnectionState() {
    _connSub = _notificationSignalR.stateStream.listen((s) {
      if (isClosed) return;
      emit(state.copyWith(signalRStatus: _mapState(s)));
    });
  }

  void _listenIncomingRequests() {
    _incomingRequestSub = _notificationSignalR.emergencyRequests.listen((
      payload,
    ) async {
      if (isClosed) return;
      final requestId = _readRequestId(payload);
      if (requestId == null) {
        developer.log(
          'ReceiveEmergencyRequest missing request id',
          name: 'Rescufy.DashboardCubit',
        );
        emit(state.copyWith(error: 'Incoming request is missing an id'));
        return;
      }

      final result = await _paramedicEmergencyRepository
          .getIncomingRequestById(requestId);

      if (isClosed) return;
      result.fold(
        (failure) {
          developer.log(
            'Failed to load incoming request $requestId',
            name: 'Rescufy.DashboardCubit',
            error: failure.message,
          );
          emit(state.copyWith(error: failure.message));
        },
        (request) =>
            emit(state.copyWith(incomingRequest: request, clearError: true)),
      );
    });
  }

  int? _readRequestId(Map<String, dynamic> payload) {
    // First, try common top-level keys
    for (final key in const [
      'requestId',
      'RequestId',
      'requestID',
      'RequestID',
      'id',
      'Id',
      'ID',
      'value',
      'Value',
      'request_id',
      'Request_Id',
      'request_Id',
      'Request_id',
    ]) {
      final value = payload[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value != null) {
        final parsed = int.tryParse(value.toString().trim());
        if (parsed != null) return parsed;
      }
    }

    // Second, try nested data/payload objects
    for (final nestedKey in const ['data', 'Data', 'payload', 'Payload']) {
      final nested = payload[nestedKey];
      if (nested is Map<String, dynamic>) {
        for (final key in const [
          'requestId',
          'RequestId',
          'id',
          'Id',
          'value',
        ]) {
          final value = nested[key];
          if (value is int) return value;
          if (value is num) return value.toInt();
          if (value != null) {
            final parsed = int.tryParse(value.toString().trim());
            if (parsed != null) return parsed;
          }
        }
      }
    }

    // Third, scan all values recursively for any integer > 0
    int? _scanValues(dynamic value) {
      if (value is int && value > 0) return value;
      if (value is num && value.toInt() > 0) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value.trim());
        if (parsed != null && parsed > 0) return parsed;
      }
      if (value is Map<String, dynamic>) {
        for (final v in value.values) {
          final found = _scanValues(v);
          if (found != null) return found;
        }
      }
      if (value is List) {
        for (final v in value) {
          final found = _scanValues(v);
          if (found != null) return found;
        }
      }
      return null;
    }

    final scanned = _scanValues(payload);
    if (scanned != null) {
      developer.log(
        'Found requestId via deep scan: $scanned. Payload: $payload',
        name: 'Rescufy.DashboardCubit',
      );
      return scanned;
    }

    // Debug log the full payload so we can see what the backend actually sends
    developer.log(
      'ReceiveEmergencyRequest payload did not contain a parsable requestId. Payload: $payload',
      name: 'Rescufy.DashboardCubit',
    );
    return null;
  }

  void _listenRequestCancelled() {
    _requestCancelledSub = _notificationSignalR.requestCancelled.listen((_) {
      if (isClosed) return;
      emit(state.copyWith(clearRequest: true));
    });
  }

  DashboardSignalRStatus _mapState(SignalRConnectionState s) => switch (s) {
    SignalRConnectionState.connected => DashboardSignalRStatus.connected,
    SignalRConnectionState.connecting => DashboardSignalRStatus.connecting,
    SignalRConnectionState.reconnecting => DashboardSignalRStatus.reconnecting,
    SignalRConnectionState.disconnected => DashboardSignalRStatus.disconnected,
  };
}
