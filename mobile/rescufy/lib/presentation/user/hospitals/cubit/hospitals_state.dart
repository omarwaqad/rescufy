import 'package:equatable/equatable.dart';
import 'package:rescufy/domain/entities/hospital.dart';

class HospitalsState extends Equatable {
  const HospitalsState({
    required this.status,
    required this.hospitals,
    this.latitude,
    this.longitude,
    this.address,
    this.errorMessage,
    this.radiusKm = 10,
  });

  final HospitalsStatus status;
  final List<Hospital> hospitals;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? errorMessage;
  final double radiusKm;

  const HospitalsState.initial()
    : this(status: HospitalsStatus.initial, hospitals: const []);

  bool get hasLocation => latitude != null && longitude != null;

  HospitalsState copyWith({
    HospitalsStatus? status,
    List<Hospital>? hospitals,
    double? latitude,
    double? longitude,
    String? address,
    String? errorMessage,
    bool clearError = false,
    double? radiusKm,
  }) {
    return HospitalsState(
      status: status ?? this.status,
      hospitals: hospitals ?? this.hospitals,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      radiusKm: radiusKm ?? this.radiusKm,
    );
  }

  @override
  List<Object?> get props => [
    status,
    hospitals,
    latitude,
    longitude,
    address,
    errorMessage,
    radiusKm,
  ];
}

enum HospitalsStatus { initial, loading, success, empty, error }
