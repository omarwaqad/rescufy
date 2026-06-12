import 'package:equatable/equatable.dart';

class ParamedicProfile extends Equatable {
  const ParamedicProfile({
    required this.id,
    required this.isActive,
    this.name,
    this.vehicleInfo,
    this.driverPhone,
    this.ambulanceStatus,
    this.simLatitude,
    this.simLongitude,
    this.driverId,
    this.driverName,
    this.paramedicId,
    this.paramedicName,
    this.startingPrice,
    this.ambulanceNumber,
    this.ambulancePointId,
  });

  final int id;
  final String? name;
  final String? vehicleInfo;
  final String? driverPhone;
  final String? ambulanceStatus;
  final double? simLatitude;
  final double? simLongitude;
  final String? driverId;
  final String? driverName;
  final String? paramedicId;
  final String? paramedicName;
  final double? startingPrice;
  final String? ambulanceNumber;
  final int? ambulancePointId;
  final bool isActive;

  String get displayName {
    final paramedic = paramedicName?.trim();
    if (paramedic != null && paramedic.isNotEmpty) {
      return paramedic;
    }

    final driver = driverName?.trim();
    if (driver != null && driver.isNotEmpty) {
      return driver;
    }

    final fallbackName = name?.trim();
    return fallbackName ?? '';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    vehicleInfo,
    driverPhone,
    ambulanceStatus,
    simLatitude,
    simLongitude,
    driverId,
    driverName,
    paramedicId,
    paramedicName,
    startingPrice,
    ambulanceNumber,
    ambulancePointId,
    isActive,
  ];
}
