import 'package:dartz/dartz.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/user_active_request.dart';

abstract class EmergencyRepository {
  Future<Either<Failure, Map<String, dynamic>>> createEmergencyRequest({
    required String description,
    required bool isSelfCase,
    required double latitude,
    required double longitude,
    required String address,
    String? peopleCount,
  });
  Future<Either<Failure, UserActiveRequest>> getRequestById(int requestId);
}
