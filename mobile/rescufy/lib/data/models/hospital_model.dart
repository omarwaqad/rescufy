import 'package:rescufy/domain/entities/hospital.dart';

class HospitalModel extends Hospital {
  const HospitalModel({
    required super.id,
    required super.name,
    required super.address,
    required super.contactPhone,
    required super.latitude,
    required super.longitude,
    required super.availableBeds,
    required super.bedCapacity,
    required super.availableIcu,
    required super.icuCapacity,
    required super.status,
    required super.isAvailable,
    required super.startingPrice,
    super.distanceKm,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: _readInt(json['id']),
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      contactPhone: json['contactPhone']?.toString() ?? '',
      latitude: _readDouble(json['latitude']),
      longitude: _readDouble(json['longitude']),
      availableBeds: _readInt(json['availableBeds']),
      bedCapacity: _readInt(json['bedCapacity']),
      availableIcu: _readInt(json['availableICU']),
      icuCapacity: _readInt(json['icuCapacity']),
      status: json['status']?.toString() ?? '',
      isAvailable: _readBool(json['isAvailable']),
      startingPrice: _readDouble(json['startingPrice']),
    );
  }

  static int _readInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _readDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _readBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    final normalized = value?.toString().trim().toLowerCase();
    return normalized == 'true' || normalized == '1' || normalized == 'yes';
  }
}
