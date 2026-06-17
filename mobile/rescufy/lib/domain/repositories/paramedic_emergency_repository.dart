import 'package:dartz/dartz.dart';
import '../core/failures.dart';
import '../entities/emergency_request.dart';
import '../entities/incoming_request.dart';

abstract class ParamedicEmergencyRepository {
  Future<Either<Failure, Stream<List<EmergencyRequest>>>> getIncomingRequests();
  Future<Either<Failure, IncomingRequest>> getIncomingRequestById(
    int requestId,
  );
  Future<Either<Failure, EmergencyRequest>> acceptRequest(int requestId);
  Future<Either<Failure, void>> rejectRequest(int requestId);
  Future<Either<Failure, EmergencyRequest>> updateCaseStatus(
    int requestId,
    EmergencyStatus status,
  );
  Future<Either<Failure, List<EmergencyRequest>>> getCaseHistory();
}
