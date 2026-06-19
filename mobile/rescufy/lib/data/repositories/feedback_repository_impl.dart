import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/repositories/feedback_repository.dart';
import 'package:rescufy/data/datasources/remote/feedback_remote_datasource.dart';
import 'package:rescufy/data/models/feedback/driver_feedback_model.dart';
import 'package:rescufy/data/models/feedback/hospital_feedback_model.dart';
import 'package:rescufy/data/models/feedback/paramedic_feedback_model.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDataSource _remoteDataSource;

  FeedbackRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> submitDriverFeedback({
    required String driverId,
    required int requestId,
    required int rate,
    String? comment,
  }) async {
    try {
      await _remoteDataSource.submitDriverFeedback(
        DriverFeedbackModel(
          driverId: driverId,
          requestId: requestId,
          rate: rate,
          comment: comment,
        ),
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.response?.data['message'] ?? 'Server error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> submitParamedicFeedback({
    required String paramedicId,
    required int requestId,
    required int rate,
    String? comment,
  }) async {
    try {
      await _remoteDataSource.submitParamedicFeedback(
        ParamedicFeedbackModel(
          paramedicId: paramedicId,
          requestId: requestId,
          rate: rate,
          comment: comment,
        ),
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.response?.data['message'] ?? 'Server error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> submitHospitalFeedback({
    required int hospitalId,
    required int requestId,
    required int rate,
    String? comment,
  }) async {
    try {
      await _remoteDataSource.submitHospitalFeedback(
        HospitalFeedbackModel(
          hospitalId: hospitalId,
          requestId: requestId,
          rate: rate,
          comment: comment,
        ),
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.response?.data['message'] ?? 'Server error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
