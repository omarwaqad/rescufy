import 'package:equatable/equatable.dart';

class Hospital extends Equatable {
  const Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.contactPhone,
    required this.latitude,
    required this.longitude,
    required this.availableBeds,
    required this.bedCapacity,
    required this.availableIcu,
    required this.icuCapacity,
    required this.status,
    required this.isAvailable,
    required this.startingPrice,
    this.distanceKm,
  });

  final int id;
  final String name;
  final String address;
  final String contactPhone;
  final double latitude;
  final double longitude;
  final int availableBeds;
  final int bedCapacity;
  final int availableIcu;
  final int icuCapacity;
  final String status;
  final bool isAvailable;
  final double startingPrice;
  final double? distanceKm;

  Hospital copyWith({double? distanceKm}) {
    return Hospital(
      id: id,
      name: name,
      address: address,
      contactPhone: contactPhone,
      latitude: latitude,
      longitude: longitude,
      availableBeds: availableBeds,
      bedCapacity: bedCapacity,
      availableIcu: availableIcu,
      icuCapacity: icuCapacity,
      status: status,
      isAvailable: isAvailable,
      startingPrice: startingPrice,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  String get directionsUrl =>
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';

  String get phoneUrl => 'tel:$contactPhone';

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    contactPhone,
    latitude,
    longitude,
    availableBeds,
    bedCapacity,
    availableIcu,
    icuCapacity,
    status,
    isAvailable,
    startingPrice,
    distanceKm,
  ];
}
