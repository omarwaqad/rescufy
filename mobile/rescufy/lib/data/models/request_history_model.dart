import 'package:rescufy/domain/entities/request_history.dart';

class RequestHistoryModel extends RequestHistory {
  const RequestHistoryModel({
    required super.id,
    required super.description,
    required super.address,
    required super.requestStatus,
    required super.createdAt,
    required super.patientName,
    super.assignedAmbulancePlate,
    super.driverName,
    super.hospitalName,
    super.driverId,
    super.paramedicId,
    super.hospitalId,
  });

  factory RequestHistoryModel.fromJson(Map<String, dynamic> json) {
    return RequestHistoryModel(
      id: _readInt(json['id']),
      description: _readString(json['description']),
      address: _readString(json['address']),
      requestStatus: _readString(json['requestStatus']),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      patientName: _readString(json['patientName']),
      assignedAmbulancePlate: _readNullableString(
        json['assignedAmbulancePlate'],
      ),
      driverName: _readNullableString(json['driverName']),
      hospitalName: _readNullableString(json['hospitalName']),
      driverId: _readNullableString(json['driverId']),
      paramedicId: _readNullableString(json['paramedicId']),
      hospitalId: _readNullableInt(json['hospitalId']),
    );
  }

  static int _readInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? _readNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static String _readString(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static String? _readNullableString(dynamic value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }
}
