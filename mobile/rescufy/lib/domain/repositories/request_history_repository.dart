import 'package:dartz/dartz.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/request_history.dart';

abstract class RequestHistoryRepository {
  Future<Either<Failure, List<RequestHistory>>> getRequestHistory({
    int page = 1,
    int limit = 10,
    String? requestStatus,
    String? sort,
    DateTime? startDate,
    DateTime? endDate,
  });
}
