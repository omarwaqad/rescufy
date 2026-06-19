import 'package:rescufy/domain/entities/notification.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.isRead,
    required super.createdAt,
    super.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: _readInt(json, const ['id', 'Id', 'ID']),
      title: _readString(json, const ['title', 'Title', 'subject', 'Subject']),
      message: _readString(
        json,
        const ['message', 'Message', 'body', 'Body', 'content', 'Content'],
      ),
      isRead: _readBool(
        json,
        const ['isRead', 'IsRead', 'is_read', 'read', 'Read'],
      ),
      createdAt: _readDateTime(
        json,
        const ['createdAt', 'CreatedAt', 'created_at', 'date', 'Date'],
      ),
      type: _readStringNullable(
        json,
        const ['type', 'Type', 'notificationType', 'NotificationType'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'isRead': isRead,
    'createdAt': createdAt.toIso8601String(),
    'type': type,
  };

  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    bool? isRead,
    DateTime? createdAt,
    String? type,
    bool clearType = false,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      type: clearType ? null : type ?? this.type,
    );
  }

  static int _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) {
        if (value is int) return value;
        if (value is String) return int.tryParse(value) ?? 0;
      }
    }
    return 0;
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) {
        return value.toString();
      }
    }
    return '';
  }

  static String? _readStringNullable(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) {
        return value.toString();
      }
    }
    return null;
  }

  static bool _readBool(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) {
        if (value is bool) return value;
        if (value is String) {
          return value.toLowerCase() == 'true';
        }
        if (value is num) return value != 0;
      }
    }
    return false;
  }

  static DateTime _readDateTime(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) {
        if (value is DateTime) return value;
        final parsed = DateTime.tryParse(value.toString());
        if (parsed != null) return parsed;
      }
    }
    return DateTime.now();
  }
}
