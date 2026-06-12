import 'package:equatable/equatable.dart';
import 'package:rescufy/domain/entities/request_history.dart';

enum RequestHistoryStatus { initial, loading, success, empty, error }

class RequestHistoryState extends Equatable {
  const RequestHistoryState({
    required this.status,
    required this.items,
    this.errorMessage,
    this.currentPage = 1,
    this.pageSize = 10,
    this.hasMore = true,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.requestStatus,
    this.sort,
    this.startDate,
    this.endDate,
  });

  const RequestHistoryState.initial()
    : this(status: RequestHistoryStatus.initial, items: const []);

  final RequestHistoryStatus status;
  final List<RequestHistory> items;
  final String? errorMessage;
  final int currentPage;
  final int pageSize;
  final bool hasMore;
  final bool isRefreshing;
  final bool isLoadingMore;
  final String? requestStatus;
  final String? sort;
  final DateTime? startDate;
  final DateTime? endDate;

  RequestHistoryState copyWith({
    RequestHistoryStatus? status,
    List<RequestHistory>? items,
    String? errorMessage,
    bool clearError = false,
    int? currentPage,
    int? pageSize,
    bool? hasMore,
    bool? isRefreshing,
    bool? isLoadingMore,
    String? requestStatus,
    bool clearRequestStatus = false,
    String? sort,
    bool clearSort = false,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
  }) {
    return RequestHistoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      requestStatus: clearRequestStatus
          ? null
          : requestStatus ?? this.requestStatus,
      sort: clearSort ? null : sort ?? this.sort,
      startDate: clearStartDate ? null : startDate ?? this.startDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    errorMessage,
    currentPage,
    pageSize,
    hasMore,
    isRefreshing,
    isLoadingMore,
    requestStatus,
    sort,
    startDate,
    endDate,
  ];
}
