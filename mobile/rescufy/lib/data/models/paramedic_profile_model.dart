import 'package:rescufy/domain/entities/paramedic_profile.dart';

class ParamedicProfileModel extends ParamedicProfile {
  const ParamedicProfileModel({
    required super.id,
    required super.isActive,
    super.name,
    super.vehicleInfo,
    super.driverPhone,
    super.ambulanceStatus,
    super.simLatitude,
    super.simLongitude,
    super.driverId,
    super.driverName,
    super.paramedicId,
    super.paramedicName,
    super.startingPrice,
    super.ambulanceNumber,
    super.ambulancePointId,
  });

  factory ParamedicProfileModel.fromJson(Map<String, dynamic> json) {
    return ParamedicProfileModel(
      id: _asInt(json['id']) ?? 0,
      name: _asString(json['name']),
      vehicleInfo: _asString(json['vehicleInfo']),
      driverPhone: _asString(json['driverPhone']),
      ambulanceStatus: _asString(json['ambulanceStatus']),
      simLatitude: _asDouble(json['simLatitude']),
      simLongitude: _asDouble(json['simLongitude']),
      driverId: _asString(json['driverId']),
      driverName: _asString(json['driverName']),
      paramedicId: _asString(json['paramedicId']),
      paramedicName: _asString(json['paramedicName']),
      startingPrice: _asDouble(json['startingPrice']),
      ambulanceNumber: _asString(json['ambulanceNumber']),
      ambulancePointId: _asInt(json['ambulancePointId']),
      isActive: _asBool(json['isActive']) ?? false,
    );
  }

  static String? _asString(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  static int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '');
  }

  static double? _asDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '');
  }

  static bool? _asBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    final text = value?.toString().trim().toLowerCase();
    if (text == 'true') {
      return true;
    }
    if (text == 'false') {
      return false;
    }
    return null;
  }
}
