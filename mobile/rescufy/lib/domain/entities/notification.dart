import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.type,
  });

  final int id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final String? type;

  @override
  List<Object?> get props => [id, title, message, isRead, createdAt, type];
}
