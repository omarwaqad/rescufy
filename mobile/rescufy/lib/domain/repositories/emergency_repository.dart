import 'package:dartz/dartz.dart';
import 'package:rescufy/domain/core/failures.dart';

abstract class EmergencyRepository {
  Future<Either<Failure, Map<String, dynamic>>> createEmergencyRequest({
    required String description,
    required bool isSelfCase,
    required double latitude,
    required double longitude,
    required String address,
    String? peopleCount,
  });
}
