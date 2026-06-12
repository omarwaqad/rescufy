import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/domain/repositories/request_history_repository.dart';
import 'package:rescufy/presentation/user/history/cubit/request_history_state.dart';

class RequestHistoryCubit extends Cubit<RequestHistoryState> {
  RequestHistoryCubit(this._repository)
    : super(const RequestHistoryState.initial());

  final RequestHistoryRepository _repository;

  Future<void> loadRequestHistory({bool refresh = false}) async {
    if (state.status == RequestHistoryStatus.loading && !refresh) {
      return;
    }
    if (refresh) {
      emit(
        state.copyWith(
          isRefreshing: true,
          currentPage: 1,
          hasMore: true,
          clearError: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: RequestHistoryStatus.loading,
          currentPage: 1,
          hasMore: true,
          clearError: true,
        ),
      );
    }

    final result = await _repository.getRequestHistory(
      page: 1,
      limit: state.pageSize,
      requestStatus: state.requestStatus,
      sort: state.sort,
      startDate: state.startDate,
      endDate: state.endDate,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: state.items.isEmpty
              ? RequestHistoryStatus.error
              : RequestHistoryStatus.success,
          isRefreshing: false,
          errorMessage: failure.message,
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: items.isEmpty
              ? RequestHistoryStatus.empty
              : RequestHistoryStatus.success,
          items: items,
          currentPage: 1,
          hasMore: items.length >= state.pageSize,
          isRefreshing: false,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> refresh() {
    return loadRequestHistory(refresh: true);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore ||
        state.isRefreshing ||
        state.status == RequestHistoryStatus.loading ||
        !state.hasMore ||
        state.items.isEmpty) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    final nextPage = state.currentPage + 1;
    final result = await _repository.getRequestHistory(
      page: nextPage,
      limit: state.pageSize,
      requestStatus: state.requestStatus,
      sort: state.sort,
      startDate: state.startDate,
      endDate: state.endDate,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingMore: false, errorMessage: failure.message),
      ),
      (items) => emit(
        state.copyWith(
          status: state.items.isEmpty && items.isEmpty
              ? RequestHistoryStatus.empty
              : RequestHistoryStatus.success,
          items: [...state.items, ...items],
          currentPage: nextPage,
          hasMore: items.length >= state.pageSize,
          isLoadingMore: false,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> applyFilters({
    String? requestStatus,
    String? sort,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(
      state.copyWith(
        requestStatus: requestStatus,
        clearRequestStatus: requestStatus == null,
        sort: sort,
        clearSort: sort == null,
        startDate: startDate,
        clearStartDate: startDate == null,
        endDate: endDate,
        clearEndDate: endDate == null,
        currentPage: 1,
        hasMore: true,
      ),
    );

    await loadRequestHistory();
  }
}
