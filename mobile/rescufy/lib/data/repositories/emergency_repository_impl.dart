import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/user_active_request.dart';
import 'package:rescufy/domain/repositories/emergency_repository.dart';
import 'package:rescufy/data/datasources/remote/emergency_remote_datasource.dart';
import 'package:rescufy/data/models/medical_profile/emergency_request_model.dart';

class EmergencyRepositoryImpl implements EmergencyRepository {
  final EmergencyRemoteDataSource _remoteDataSource;

  EmergencyRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> createEmergencyRequest({
    required String description,
    required bool isSelfCase,
    required double latitude,
    required double longitude,
    required String address,
    String? peopleCount,
  }) async {
    try {
      final request = EmergencyRequestModel(
        description: description,
        isSelfCase: isSelfCase,
        latitude: latitude,
        longitude: longitude,
        address: address,
        peopleCount: peopleCount,
      );

      final response = await _remoteDataSource.createEmergencyRequest(request);
      return Right(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(
          ServerFailure(e.response?.data['message'] ?? 'Server error occurred'),
        );
      } else {
        return Left(ServerFailure(e.message ?? 'Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserActiveRequest>> getRequestById(int requestId) async {
    try {
      final request = await _remoteDataSource.getRequestById(requestId);
      return Right(request);
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(
          ServerFailure(e.response?.data['message'] ?? 'Server error occurred'),
        );
      } else {
        return Left(ServerFailure(e.message ?? 'Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
