import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/domain/entities/incoming_request.dart';
import 'package:rescufy/domain/entities/request_history.dart';
import 'package:rescufy/domain/repositories/paramedic_emergency_repository.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._repository) : super(const HistoryState.initial());

  final ParamedicEmergencyRepository _repository;

  Future<void> loadHistory() async {
    if (state.status == HistoryStatus.loading) return;
    emit(state.copyWith(status: HistoryStatus.loading, clearError: true));

    final result = await _repository.getParamedicRequests();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HistoryStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: items.isEmpty ? HistoryStatus.empty : HistoryStatus.success,
          items: items,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> refresh() => loadHistory();

  Future<void> openRequest(int requestId, HistoryAction action) async {
    emit(state.copyWith(isLoadingDetails: true, clearError: true));

    final result = await _repository.getIncomingRequestById(requestId);

    result.fold(
      (failure) {
        developer.log(
          'Failed to open request $requestId: ${failure.message}',
          name: 'Rescufy.HistoryCubit',
        );
        emit(
          state.copyWith(
            isLoadingDetails: false,
            errorMessage: failure.message,
          ),
        );
      },
      (request) {
        developer.log(
          'Opened request $requestId for ${action.name}',
          name: 'Rescufy.HistoryCubit',
        );
        emit(
          state.copyWith(
            isLoadingDetails: false,
            selectedRequest: request,
            pendingAction: action,
          ),
        );
      },
    );
  }

  void clearNavigation() {
    emit(state.copyWith(clearSelectedRequest: true, clearPendingAction: true));
  }
}
