import 'package:equatable/equatable.dart';

abstract class EmergencyRequestState extends Equatable {
  const EmergencyRequestState();

  @override
  List<Object?> get props => [];
}

class EmergencyRequestInitial extends EmergencyRequestState {
  const EmergencyRequestInitial();
}

class EmergencyRequestLoading extends EmergencyRequestState {
  const EmergencyRequestLoading();
}

class EmergencyRequestSuccess extends EmergencyRequestState {
  final String ambulanceId;
  final String eta;

  const EmergencyRequestSuccess({required this.ambulanceId, required this.eta});

  @override
  List<Object?> get props => [ambulanceId, eta];
}

class EmergencyRequestError extends EmergencyRequestState {
  final String message;

  const EmergencyRequestError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Location-specific states
class LocationDetecting extends EmergencyRequestState {
  const LocationDetecting();
}

class LocationDetected extends EmergencyRequestState {
  final double latitude;
  final double longitude;
  final String address;

  const LocationDetected({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, address];
}

class LocationError extends EmergencyRequestState {
  final String message;

  const LocationError({required this.message});

  @override
  List<Object?> get props => [message];
}
