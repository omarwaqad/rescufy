import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/hospital.dart';
import 'package:rescufy/domain/repositories/hospital_repository.dart';

class GetNearbyHospitalsUseCase {
  const GetNearbyHospitalsUseCase(this._repository);

  final HospitalRepository _repository;

  Future<Either<Failure, List<Hospital>>> call({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  }) async {
    final result = await _repository.getNearbyHospitals(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );

    return result.map(
      (hospitals) =>
          hospitals
              .map(
                (hospital) => hospital.copyWith(
                  distanceKm:
                      Geolocator.distanceBetween(
                        latitude,
                        longitude,
                        hospital.latitude,
                        hospital.longitude,
                      ) /
                      1000,
                ),
              )
              .toList()
            ..sort(
              (first, second) => (first.distanceKm ?? double.infinity)
                  .compareTo(second.distanceKm ?? double.infinity),
            ),
    );
  }
}
