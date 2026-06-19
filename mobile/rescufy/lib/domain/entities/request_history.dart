import 'package:equatable/equatable.dart';

class RequestHistory extends Equatable {
  const RequestHistory({
    required this.id,
    required this.description,
    required this.address,
    required this.requestStatus,
    required this.createdAt,
    required this.patientName,
    this.assignedAmbulancePlate,
    this.driverName,
    this.hospitalName,
    this.driverId,
    this.paramedicId,
    this.hospitalId,
  });

  final int id;
  final String description;
  final String address;
  final String requestStatus;
  final DateTime createdAt;
  final String patientName;
  final String? assignedAmbulancePlate;
  final String? driverName;
  final String? hospitalName;
  final String? driverId;
  final String? paramedicId;
  final int? hospitalId;

  @override
  List<Object?> get props => [
    id,
    description,
    address,
    requestStatus,
    createdAt,
    patientName,
    assignedAmbulancePlate,
    driverName,
    hospitalName,
    driverId,
    paramedicId,
    hospitalId,
  ];
}
