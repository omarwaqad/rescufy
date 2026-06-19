import 'package:equatable/equatable.dart';

class UserActiveRequest extends Equatable {
  const UserActiveRequest({
    required this.requestId,
    required this.status,
    this.hospitalName,
    this.eta,
  });

  final int requestId;
  final String status;
  final String? hospitalName;
  final int? eta;

  factory UserActiveRequest.fromJson(Map<String, dynamic> json) {
    return UserActiveRequest(
      requestId: _readInt(json['requestId'] ?? json['id']),
      status: _readString(json['status'] ?? json['requestStatus']),
      hospitalName: _readNullableString(json['hospitalName']),
      eta: _readNullableInt(json['eta']),
    );
  }

  static int _readInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _readString(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static String? _readNullableString(dynamic value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }

  static int? _readNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  bool get isActive {
    final s = status.toLowerCase();
    return const [
      'assigned',
      'accepted',
      'ontheway',
      'on_the_way',
      'arrived',
      'pickedup',
      'picked_up',
      'underexecuting',
      'under_executing',
    ].contains(s);
  }

  @override
  List<Object?> get props => [requestId, status, hospitalName, eta];
}
