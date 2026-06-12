import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rescufy/core/network/network_exceptions.dart';
import 'package:rescufy/data/datasources/remote/hospital_remote_datasource.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/hospital.dart';
import 'package:rescufy/domain/repositories/hospital_repository.dart';

class HospitalRepositoryImpl implements HospitalRepository {
  HospitalRepositoryImpl(this._remoteDataSource);

  final HospitalRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<Hospital>>> getNearbyHospitals({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  }) async {
    try {
      final hospitals = await _remoteDataSource.getNearbyHospitals(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      );
      return Right(hospitals);
    } on DioException catch (error) {
      return Left(NetworkExceptions.handleDioException(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
