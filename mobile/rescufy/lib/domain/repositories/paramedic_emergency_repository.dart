import 'package:dartz/dartz.dart';
import '../core/failures.dart';
import '../entities/emergency_request.dart';

abstract class ParamedicEmergencyRepository {
  Future<Either<Failure, Stream<List<EmergencyRequest>>>> getIncomingRequests();
  Future<Either<Failure, EmergencyRequest>> acceptRequest(String requestId);
  Future<Either<Failure, void>> rejectRequest(String requestId);
  Future<Either<Failure, EmergencyRequest>> updateCaseStatus(
    String requestId,
    EmergencyStatus status,
  );
  Future<Either<Failure, List<EmergencyRequest>>> getCaseHistory();
}
