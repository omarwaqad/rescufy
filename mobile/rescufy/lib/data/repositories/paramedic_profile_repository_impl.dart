import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rescufy/core/network/network_exceptions.dart';
import 'package:rescufy/data/datasources/remote/paramedic_profile_remote_datasource.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/paramedic_profile.dart';
import 'package:rescufy/domain/repositories/paramedic_profile_repository.dart';

class ParamedicProfileRepositoryImpl implements ParamedicProfileRepository {
  ParamedicProfileRepositoryImpl(this._remoteDataSource);

  final ParamedicProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, ParamedicProfile>> getProfile() async {
    try {
      final profile = await _remoteDataSource.getProfile();
      return Right(profile);
    } on DioException catch (error) {
      return Left(NetworkExceptions.handleDioException(error));
    } on FormatException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
