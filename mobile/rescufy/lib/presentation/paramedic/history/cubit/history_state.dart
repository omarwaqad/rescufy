import 'package:equatable/equatable.dart';
import 'package:rescufy/domain/entities/incoming_request.dart';
import 'package:rescufy/domain/entities/request_history.dart';

enum HistoryStatus { initial, loading, success, empty, error }

enum HistoryAction { openIncomingRequest, openActiveCase }

class HistoryState extends Equatable {
  const HistoryState({
    required this.status,
    required this.items,
    this.errorMessage,
    this.isLoadingDetails = false,
    this.selectedRequest,
    this.pendingAction,
  });

  const HistoryState.initial()
      : this(status: HistoryStatus.initial, items: const []);

  final HistoryStatus status;
  final List<RequestHistory> items;
  final String? errorMessage;
  final bool isLoadingDetails;
  final IncomingRequest? selectedRequest;
  final HistoryAction? pendingAction;

  HistoryState copyWith({
    HistoryStatus? status,
    List<RequestHistory>? items,
    String? errorMessage,
    bool clearError = false,
    bool? isLoadingDetails,
    IncomingRequest? selectedRequest,
    bool clearSelectedRequest = false,
    HistoryAction? pendingAction,
    bool clearPendingAction = false,
  }) {
    return HistoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      selectedRequest: clearSelectedRequest
          ? null
          : selectedRequest ?? this.selectedRequest,
      pendingAction: clearPendingAction
          ? null
          : pendingAction ?? this.pendingAction,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        errorMessage,
        isLoadingDetails,
        selectedRequest,
        pendingAction,
      ];
}
