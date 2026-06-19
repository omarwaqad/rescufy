import 'package:dio/dio.dart';
import 'package:rescufy/core/network/dio_client.dart';
import 'package:rescufy/core/network/endpoints/api_endpoints.dart';
import 'package:rescufy/data/models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAsRead(int id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(int id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _dioClient.get(ApiEndpoints.notifications);
    final data = response.data as List<dynamic>;
    return data
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _dioClient.get(ApiEndpoints.unreadNotificationsCount);
    final count = response.data;
    if (count is int) return count;
    if (count is String) return int.tryParse(count) ?? 0;
    return 0;
  }

  @override
  Future<void> markAsRead(int id) async {
    await _dioClient.post(ApiEndpoints.markNotificationAsRead(id));
  }

  @override
  Future<void> markAllAsRead() async {
    await _dioClient.post(ApiEndpoints.markAllNotificationsRead);
  }

  @override
  Future<void> deleteNotification(int id) async {
    await _dioClient.delete(ApiEndpoints.deleteNotification(id));
  }
}
