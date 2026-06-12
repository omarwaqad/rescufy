import 'package:dartz/dartz.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/hospital.dart';

abstract class HospitalRepository {
  Future<Either<Failure, List<Hospital>>> getNearbyHospitals({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  });
}
