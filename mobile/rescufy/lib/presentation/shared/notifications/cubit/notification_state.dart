import 'package:equatable/equatable.dart';
import 'package:rescufy/domain/entities/notification.dart';

enum NotificationStatus { initial, loading, success, empty, error }

class NotificationState extends Equatable {
  const NotificationState({
    required this.status,
    required this.items,
    this.unreadCount = 0,
    this.errorMessage,
    this.isRefreshing = false,
    this.isMarkingRead = false,
    this.isDeleting = false,
  });

  const NotificationState.initial()
      : this(status: NotificationStatus.initial, items: const []);

  final NotificationStatus status;
  final List<Notification> items;
  final int unreadCount;
  final String? errorMessage;
  final bool isRefreshing;
  final bool isMarkingRead;
  final bool isDeleting;

  NotificationState copyWith({
    NotificationStatus? status,
    List<Notification>? items,
    int? unreadCount,
    String? errorMessage,
    bool clearError = false,
    bool? isRefreshing,
    bool? isMarkingRead,
    bool? isDeleting,
  }) {
    return NotificationState(
      status: status ?? this.status,
      items: items ?? this.items,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isMarkingRead: isMarkingRead ?? this.isMarkingRead,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        unreadCount,
        errorMessage,
        isRefreshing,
        isMarkingRead,
        isDeleting,
      ];
}
