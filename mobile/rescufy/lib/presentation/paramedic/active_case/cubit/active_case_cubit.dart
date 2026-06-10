import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/services/location_service.dart';
import 'package:rescufy/core/services/signalr/ambulance_signalr_service.dart';
import 'package:rescufy/core/services/signalr/notification_signalr_service.dart';
import 'package:rescufy/core/services/signalr/signalr_models.dart';
import 'package:rescufy/domain/entities/case_status.dart';
import 'package:rescufy/domain/entities/incoming_request.dart';
import 'active_case_state.dart';

class ActiveCaseCubit extends Cubit<ActiveCaseState> {
  ActiveCaseCubit({
    required IncomingRequest request,
    required NotificationSignalRService notificationSignalRService,
    required AmbulanceSignalRService ambulanceSignalRService,
    required LocationService locationService,
  }) : _notificationSignalR = notificationSignalRService,
       _ambulanceSignalR = ambulanceSignalRService,
       _locationService = locationService,
       super(ActiveCaseState.initial(request));

  final NotificationSignalRService _notificationSignalR;
  final AmbulanceSignalRService _ambulanceSignalR;
  final LocationService _locationService;
  Timer? _locationTimer;
  StreamSubscription<RequestStatusUpdate>? _statusUpdateSubscription;
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
    await _statusUpdateSubscription?.cancel();
    await _locationUpdateSubscription?.cancel();
    if (state.loadStatus == ActiveCaseLoadStatus.ready) {
      try {
        await _ambulanceSignalR.leaveRequestGroup(state.request.requestId);
      } catch (_) {}
    }
    await super.close();
  }

  Future<void> updateStatus(CaseStatus _) async {
    emit(
      state.copyWith(
        isUpdatingStatus: false,
        errorMessage:
            'Status updates are read from the notification hub; the ambulance hub does not expose a mobile status update method.',
      ),
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
    _statusUpdateSubscription ??= _notificationSignalR.statusChanged.listen((
      update,
    ) {
      if (isClosed || update.requestId != state.request.requestId) {
        return;
      }

      emit(
        state.copyWith(
          caseStatus: update.status.toCaseStatus(),
          isUpdatingStatus: false,
          liveStatusMessage: update.message ?? state.liveStatusMessage,
          lastUpdatedAt: update.updatedAt ?? DateTime.now(),
        ),
      );
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
