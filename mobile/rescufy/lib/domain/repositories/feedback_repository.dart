import 'package:dartz/dartz.dart';
import 'package:rescufy/domain/core/failures.dart';

abstract class FeedbackRepository {
  Future<Either<Failure, void>> submitDriverFeedback({
    required String driverId,
    required int requestId,
    required int rate,
    String? comment,
  });
  Future<Either<Failure, void>> submitParamedicFeedback({
    required String paramedicId,
    required int requestId,
    required int rate,
    String? comment,
  });
  Future<Either<Failure, void>> submitHospitalFeedback({
    required int hospitalId,
    required int requestId,
    required int rate,
    String? comment,
  });
}
