import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/core/failures.dart';
import '../../domain/entities/emergency_request.dart';
import '../../domain/repositories/paramedic_emergency_repository.dart';
import '../datasources/remote/paramedic_emergency_remote_datasource.dart';
import '../../core/network/network_exceptions.dart';

class ParamedicEmergencyRepositoryImpl implements ParamedicEmergencyRepository {
  final ParamedicEmergencyRemoteDataSource remoteDataSource;

  ParamedicEmergencyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Stream<List<EmergencyRequest>>>>
  getIncomingRequests() async {
    try {
      final stream = await remoteDataSource.getIncomingRequests();
      return Right(stream);
    } on DioException catch (e) {
      return Left(NetworkExceptions.handleDioException(e));
    } catch (e) {
      return Left(
        ServerFailure('Failed to get incoming requests: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, EmergencyRequest>> acceptRequest(
    String requestId,
  ) async {
    try {
      final request = await remoteDataSource.acceptRequest(requestId);
      return Right(request);
    } on DioException catch (e) {
      return Left(NetworkExceptions.handleDioException(e));
    } catch (e) {
      return Left(ServerFailure('Failed to accept request: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> rejectRequest(String requestId) async {
    try {
      await remoteDataSource.rejectRequest(requestId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkExceptions.handleDioException(e));
    } catch (e) {
      return Left(ServerFailure('Failed to reject request: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, EmergencyRequest>> updateCaseStatus(
    String requestId,
    EmergencyStatus status,
  ) async {
    try {
      final request = await remoteDataSource.updateCaseStatus(
        requestId,
        status,
      );
      return Right(request);
    } on DioException catch (e) {
      return Left(NetworkExceptions.handleDioException(e));
    } catch (e) {
      return Left(
        ServerFailure('Failed to update case status: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<EmergencyRequest>>> getCaseHistory() async {
    try {
      final cases = await remoteDataSource.getCaseHistory();
      return Right(cases);
    } on DioException catch (e) {
      return Left(NetworkExceptions.handleDioException(e));
    } catch (e) {
      return Left(ServerFailure('Failed to get case history: ${e.toString()}'));
    }
  }
}
