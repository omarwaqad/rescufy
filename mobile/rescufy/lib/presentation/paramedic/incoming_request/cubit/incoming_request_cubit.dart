import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/services/signalr/ambulance_signalr_service.dart';
import 'package:rescufy/core/services/signalr/notification_signalr_service.dart';
import 'package:rescufy/domain/entities/incoming_request.dart';
import 'incoming_request_state.dart';

class IncomingRequestCubit extends Cubit<IncomingRequestState> {
  IncomingRequestCubit({
    required IncomingRequest request,
    required AmbulanceSignalRService ambulanceSignalRService,
    required NotificationSignalRService notificationSignalRService,
  }) : _ambulanceSignalR = ambulanceSignalRService,
       _notificationSignalR = notificationSignalRService,
       super(IncomingRequestState.initial(request));

  final AmbulanceSignalRService _ambulanceSignalR;
  final NotificationSignalRService _notificationSignalR;
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

    try {
      await _ambulanceSignalR.connect();
      await _ambulanceSignalR.acceptRequest(state.request.requestId);
      emit(state.copyWith(status: IncomingRequestStatus.accepted));
    } catch (e) {
      emit(
        state.copyWith(
          status: IncomingRequestStatus.error,
          errorMessage: 'Failed to accept the request: $e',
        ),
      );
    }
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
