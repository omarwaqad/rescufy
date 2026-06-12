import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rescufy/core/network/network_exceptions.dart';
import 'package:rescufy/data/datasources/remote/request_history_remote_datasource.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/request_history.dart';
import 'package:rescufy/domain/repositories/request_history_repository.dart';

class RequestHistoryRepositoryImpl implements RequestHistoryRepository {
  RequestHistoryRepositoryImpl(this._remoteDataSource);

  final RequestHistoryRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<RequestHistory>>> getRequestHistory({
    int page = 1,
    int limit = 10,
    String? requestStatus,
    String? sort,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final history = await _remoteDataSource.getRequestHistory(
        page: page,
        limit: limit,
        requestStatus: requestStatus,
        sort: sort,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(history);
    } on DioException catch (error) {
      return Left(NetworkExceptions.handleDioException(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
