import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/data/models/notification_model.dart';
import 'package:rescufy/domain/repositories/notification_repository.dart';
import 'package:rescufy/presentation/shared/notifications/cubit/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this._repository)
      : super(const NotificationState.initial());

  final NotificationRepository _repository;

  Future<void> loadNotifications({bool refresh = false}) async {
    if (state.status == NotificationStatus.loading && !refresh) return;

    if (refresh) {
      emit(state.copyWith(isRefreshing: true, clearError: true));
    } else {
      emit(state.copyWith(
        status: NotificationStatus.loading,
        clearError: true,
      ));
    }

    final result = await _repository.getNotifications();

    result.fold(
      (failure) => emit(state.copyWith(
        status: state.items.isEmpty
            ? NotificationStatus.error
            : NotificationStatus.success,
        isRefreshing: false,
        errorMessage: failure.message,
      )),
      (items) => emit(state.copyWith(
        status: items.isEmpty
            ? NotificationStatus.empty
            : NotificationStatus.success,
        items: items,
        isRefreshing: false,
        clearError: true,
      )),
    );
  }

  Future<void> refresh() => loadNotifications(refresh: true);

  Future<void> loadUnreadCount() async {
    final result = await _repository.getUnreadCount();
    result.fold(
      (failure) => emit(state.copyWith(unreadCount: 0)),
      (count) => emit(state.copyWith(unreadCount: count)),
    );
  }

  Future<void> markAsRead(int id) async {
    final result = await _repository.markAsRead(id);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final updatedItems = state.items.map((n) {
          if (n.id == id) {
            return NotificationModel(
              id: n.id,
              title: n.title,
              message: n.message,
              isRead: true,
              createdAt: n.createdAt,
              type: n.type,
            );
          }
          return n;
        }).toList();
        final unreadCount = updatedItems.where((n) => !n.isRead).length;
        emit(state.copyWith(
          items: updatedItems,
          unreadCount: unreadCount,
          clearError: true,
        ));
      },
    );
  }

  Future<void> markAllAsRead() async {
    emit(state.copyWith(isMarkingRead: true));
    final result = await _repository.markAllAsRead();
    result.fold(
      (failure) => emit(state.copyWith(
        isMarkingRead: false,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedItems = state.items
            .map((n) => NotificationModel(
                  id: n.id,
                  title: n.title,
                  message: n.message,
                  isRead: true,
                  createdAt: n.createdAt,
                  type: n.type,
                ))
            .toList();
        emit(state.copyWith(
          items: updatedItems,
          unreadCount: 0,
          isMarkingRead: false,
          clearError: true,
        ));
      },
    );
  }

  Future<void> deleteNotification(int id) async {
    emit(state.copyWith(isDeleting: true));
    final result = await _repository.deleteNotification(id);
    result.fold(
      (failure) => emit(state.copyWith(
        isDeleting: false,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedItems = state.items.where((n) => n.id != id).toList();
        final unreadCount = updatedItems.where((n) => !n.isRead).length;
        final newStatus = updatedItems.isEmpty
            ? NotificationStatus.empty
            : NotificationStatus.success;
        emit(state.copyWith(
          items: updatedItems,
          unreadCount: unreadCount,
          status: newStatus,
          isDeleting: false,
          clearError: true,
        ));
      },
    );
  }
}
