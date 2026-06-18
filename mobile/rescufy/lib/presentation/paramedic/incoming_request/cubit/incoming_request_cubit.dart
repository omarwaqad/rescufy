import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/services/signalr/ambulance_signalr_service.dart';
import 'package:rescufy/core/services/signalr/notification_signalr_service.dart';
import 'package:rescufy/domain/entities/incoming_request.dart';
import 'package:rescufy/domain/repositories/paramedic_emergency_repository.dart';
import 'incoming_request_state.dart';

class IncomingRequestCubit extends Cubit<IncomingRequestState> {
  IncomingRequestCubit({
    required IncomingRequest request,
    required AmbulanceSignalRService ambulanceSignalRService,
    required NotificationSignalRService notificationSignalRService,
    required ParamedicEmergencyRepository paramedicEmergencyRepository,
  }) : _ambulanceSignalR = ambulanceSignalRService,
       _notificationSignalR = notificationSignalRService,
       _paramedicEmergencyRepository = paramedicEmergencyRepository,
       super(IncomingRequestState.initial(request));

  final AmbulanceSignalRService _ambulanceSignalR;
  final NotificationSignalRService _notificationSignalR;
  final ParamedicEmergencyRepository _paramedicEmergencyRepository;
  StreamSubscription<int>? _cancelledSubscription;

  void initialize() {
    _cancelledSubscription ??= _notificationSignalR.requestCancelled.listen((
      requestId,
    ) {
      if (isClosed || requestId != state.request.requestId) return;
      emit(
        state.copyWith(
          status: IncomingRequestStatus.cancelled,
          errorMessage: 'This emergency request was cancelled.',
        ),
      );
    });
  }

  Future<void> acceptRequest() async {
    if (state.status == IncomingRequestStatus.accepting) return;
    emit(
      state.copyWith(status: IncomingRequestStatus.accepting, clearError: true),
    );

    // Step 1: POST /api/Request/{id}/accept
    developer.log(
      'API accept started: requestId=${state.request.requestId}',
      name: 'Rescufy.IncomingRequestCubit',
    );
    final acceptResult = await _paramedicEmergencyRepository.acceptRequest(
      state.request.requestId,
    );
    final apiAccepted = acceptResult.isRight();
    if (!apiAccepted) {
      final failure = acceptResult.fold((f) => f, (_) => null);
      developer.log(
        'API accept failed: ${failure?.message}',
        name: 'Rescufy.IncomingRequestCubit',
      );
      emit(
        state.copyWith(
          status: IncomingRequestStatus.error,
          errorMessage: 'Failed to accept the request: ${failure?.message}',
        ),
      );
      return;
    }
    developer.log(
      'API accept success',
      name: 'Rescufy.IncomingRequestCubit',
    );

    // Step 2: SignalR acceptRequest (only if API succeeded)
    try {
      developer.log(
        'SignalR accept started: requestId=${state.request.requestId}',
        name: 'Rescufy.IncomingRequestCubit',
      );
      await _ambulanceSignalR.connect();
      await _ambulanceSignalR.acceptRequest(state.request.requestId);
      developer.log(
        'SignalR accept success',
        name: 'Rescufy.IncomingRequestCubit',
      );
    } catch (e) {
      developer.log(
        'SignalR accept failed: $e',
        name: 'Rescufy.IncomingRequestCubit',
      );
      emit(
        state.copyWith(
          status: IncomingRequestStatus.error,
          errorMessage: 'Failed to accept the request via SignalR: $e',
        ),
      );
      return;
    }

    // Step 3: Refresh request details using GET /api/Request/{id}
    developer.log(
      'Request refresh started: requestId=${state.request.requestId}',
      name: 'Rescufy.IncomingRequestCubit',
    );
    final refreshResult = await _paramedicEmergencyRepository
        .getIncomingRequestById(state.request.requestId);

    final refreshedRequest = refreshResult.fold(
      (failure) {
        developer.log(
          'Request refresh failed: ${failure.message}',
          name: 'Rescufy.IncomingRequestCubit',
        );
        emit(
          state.copyWith(
            status: IncomingRequestStatus.error,
            errorMessage: 'Failed to refresh request details: ${failure.message}',
          ),
        );
        return null;
      },
      (request) {
        developer.log(
          'Request refresh success',
          name: 'Rescufy.IncomingRequestCubit',
        );
        return request;
      },
    );

    if (refreshedRequest == null) return;

    // Step 4: Update Cubit state with the refreshed request as the source of truth
    emit(
      state.copyWith(
        request: refreshedRequest,
        status: IncomingRequestStatus.accepted,
      ),
    );
  }

  Future<void> refuseRequest(String reason) async {
    if (state.status == IncomingRequestStatus.refusing) return;
    emit(
      state.copyWith(
        status: IncomingRequestStatus.refusing,
        refusalReason: reason,
        clearError: true,
      ),
    );
    emit(
      state.copyWith(
        status: IncomingRequestStatus.error,
        errorMessage: 'Reject is not supported by the ambulance hub contract.',
      ),
    );
  }

  @override
  Future<void> close() async {
    await _cancelledSubscription?.cancel();
    return super.close();
  }
}
