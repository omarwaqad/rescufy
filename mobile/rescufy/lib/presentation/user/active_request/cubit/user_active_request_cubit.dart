import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/domain/entities/user_active_request.dart';
import 'package:rescufy/domain/repositories/emergency_repository.dart';
import 'user_active_request_state.dart';

class UserActiveRequestCubit extends Cubit<UserActiveRequestState> {
  UserActiveRequestCubit({
    required EmergencyRepository emergencyRepository,
  }) : _emergencyRepository = emergencyRepository,
       super(const UserActiveRequestState());

  final EmergencyRepository _emergencyRepository;

  Future<void> loadRequest(int requestId) async {
    emit(state.copyWith(status: UserActiveRequestStatus.loading, clearError: true));

    final result = await _emergencyRepository.getRequestById(requestId);

    result.fold(
      (failure) {
        developer.log(
          'Failed to load request $requestId: ${failure.message}',
          name: 'Rescufy.UserActiveRequestCubit',
        );
        emit(
          state.copyWith(
            status: UserActiveRequestStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (request) {
        developer.log(
          'Loaded request $requestId: status=${request.status}',
          name: 'Rescufy.UserActiveRequestCubit',
        );
        emit(
          state.copyWith(
            status: UserActiveRequestStatus.success,
            request: request,
          ),
        );
      },
    );
  }

  Future<void> refresh() async {
    final request = state.request;
    if (request == null) return;
    await loadRequest(request.requestId);
  }

  /// Placeholder for future SignalR integration.
  /// Call this when a status/ETA update event is received.
  void onStatusChanged(dynamic event) {
    // TODO: Parse SignalR event and update state without full refresh.
    // For now, trigger a refresh to keep backend as source of truth.
    developer.log(
      'SignalR status update received: $event — triggering refresh',
      name: 'Rescufy.UserActiveRequestCubit',
    );
    refresh();
  }
}
