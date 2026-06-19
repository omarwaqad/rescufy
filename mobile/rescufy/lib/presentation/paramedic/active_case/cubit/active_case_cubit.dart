import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/services/location_service.dart';
import 'package:rescufy/core/services/signalr/ambulance_signalr_service.dart';
import 'package:rescufy/core/services/signalr/notification_signalr_service.dart';
import 'package:rescufy/core/services/signalr/signalr_models.dart';
import 'package:rescufy/domain/entities/case_status.dart';
import 'package:rescufy/domain/entities/incoming_request.dart';
import 'package:rescufy/domain/repositories/paramedic_emergency_repository.dart';
import 'active_case_state.dart';

class ActiveCaseCubit extends Cubit<ActiveCaseState> {
  ActiveCaseCubit({
    required IncomingRequest request,
    required NotificationSignalRService notificationSignalRService,
    required AmbulanceSignalRService ambulanceSignalRService,
    required LocationService locationService,
    required ParamedicEmergencyRepository paramedicEmergencyRepository,
  }) : _notificationSignalR = notificationSignalRService,
       _ambulanceSignalR = ambulanceSignalRService,
       _locationService = locationService,
       _paramedicEmergencyRepository = paramedicEmergencyRepository,
       super(ActiveCaseState.initial(request));

  final NotificationSignalRService _notificationSignalR;
  final AmbulanceSignalRService _ambulanceSignalR;
  final LocationService _locationService;
  final ParamedicEmergencyRepository _paramedicEmergencyRepository;
  Timer? _locationTimer;
  StreamSubscription<SignalRNotification>? _notificationSubscription;
  StreamSubscription<AmbulanceLocationUpdate>? _locationUpdateSubscription;

  static const _intervalSeconds = 3;

  Future<void> initialize() async {
    _listenToCaseUpdates();
    await _joinCaseGroup();
    if (!isClosed && state.loadStatus == ActiveCaseLoadStatus.ready) {
      _startLocationTracking();
    }
  }

  @override
  Future<void> close() async {
    _locationTimer?.cancel();
    await _notificationSubscription?.cancel();
    await _locationUpdateSubscription?.cancel();
    if (state.loadStatus == ActiveCaseLoadStatus.ready) {
      try {
        await _ambulanceSignalR.leaveRequestGroup(state.request.requestId);
      } catch (_) {}
    }
    await super.close();
  }

  Future<void> updateStatus() async {
    if (state.isUpdatingStatus || state.loadStatus == ActiveCaseLoadStatus.cancelled) {
      return;
    }

    final nextStatus = state.caseStatus.nextDriverStatus;
    if (nextStatus == null) return;

    emit(state.copyWith(isUpdatingStatus: true, clearError: true));

    developer.log(
      'Driver status update: ${state.caseStatus.serverValue} -> ${nextStatus.serverValue}',
      name: 'Rescufy.ActiveCaseCubit',
    );

    final updateResult = await _paramedicEmergencyRepository
        .updateRequestDriverStatus(
      state.request.requestId,
      nextStatus.serverValue,
    );

    if (isClosed) return;

    final updateFailed = updateResult.isLeft();
    if (updateFailed) {
      final failure = updateResult.fold((f) => f, (_) => null);
      developer.log(
        'Driver status update failed: ${failure?.message}',
        name: 'Rescufy.ActiveCaseCubit',
      );
      emit(
        state.copyWith(
          isUpdatingStatus: false,
          errorMessage: failure?.message,
        ),
      );
      return;
    }

    developer.log(
      'Driver status update success, refreshing request',
      name: 'Rescufy.ActiveCaseCubit',
    );

    await _refreshRequest();
  }

  Future<void> _refreshRequest() async {
    if (isClosed) return;

    final result = await _paramedicEmergencyRepository.getIncomingRequestById(
      state.request.requestId,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        developer.log(
          'Request refresh failed: ${failure.message}',
          name: 'Rescufy.ActiveCaseCubit',
        );
      },
      (request) {
        developer.log(
          'Request refresh success: status=${request.status}',
          name: 'Rescufy.ActiveCaseCubit',
        );
        final newStatus = request.status?.toCaseStatus();
        emit(
          state.copyWith(
            request: request,
            caseStatus: newStatus ?? state.caseStatus,
            lastUpdatedAt: DateTime.now(),
          ),
        );
      },
    );
  }

  Future<void> _joinCaseGroup() async {
    try {
      await _notificationSignalR.connect();
      await _ambulanceSignalR.connect();
      await _ambulanceSignalR.joinRequestGroup(state.request.requestId);
      emit(
        state.copyWith(
          loadStatus: ActiveCaseLoadStatus.ready,
          liveStatusMessage: 'Connected to the live case channel.',
          lastUpdatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loadStatus: ActiveCaseLoadStatus.error,
          errorMessage: 'Failed to join case group: $e',
        ),
      );
    }
  }

  void _listenToCaseUpdates() {
    _notificationSubscription ??= _notificationSignalR.notifications.listen((
      notification,
    ) {
      if (isClosed || notification.requestId != state.request.requestId) {
        return;
      }

      if (notification.type == SignalRNotificationType.requestCancelled) {
        _handleCancellation();
        return;
      }

      _refreshRequest();
    });

    _locationUpdateSubscription ??= _ambulanceSignalR.locationUpdates.listen((
      update,
    ) {
      if (isClosed || update.requestId != state.request.requestId) {
        return;
      }

      emit(
        state.copyWith(
          paramedicLat: update.latitude,
          paramedicLng: update.longitude,
          lastUpdatedAt: update.updatedAt ?? DateTime.now(),
        ),
      );
    });
  }

  Future<void> _handleCancellation() async {
    developer.log(
      'Case cancelled: requestId=${state.request.requestId}',
      name: 'Rescufy.ActiveCaseCubit',
    );
    _locationTimer?.cancel();
    try {
      await _ambulanceSignalR.leaveRequestGroup(state.request.requestId);
    } catch (_) {}
    if (!isClosed) {
      emit(
        state.copyWith(
          loadStatus: ActiveCaseLoadStatus.cancelled,
          isTrackingLocation: false,
          isUpdatingStatus: false,
        ),
      );
    }
  }

  void _startLocationTracking() {
    emit(state.copyWith(isTrackingLocation: true));
    _broadcastLocation(); // immediate first tick
    _locationTimer = Timer.periodic(
      const Duration(seconds: _intervalSeconds),
      (_) => _broadcastLocation(),
    );
  }

  Future<void> _broadcastLocation() async {
    final position = await _locationService.getCurrentPosition();
    if (position == null || isClosed) return;

    try {
      // Only the paramedic's location — never the patient's.
      await _ambulanceSignalR.updateLocation(
        AmbulanceLocationDto(
          requestId: state.request.requestId,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } catch (_) {
      return;
    }

    if (!isClosed) {
      emit(
        state.copyWith(
          paramedicLat: position.latitude,
          paramedicLng: position.longitude,
        ),
      );
    }
  }
}
