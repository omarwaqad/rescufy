// lib/data/repositories/auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(user);
    } on DioException catch (e) {
      return Left(NetworkExceptions.handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String first_name,
    required String last_name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String nationalId,
    required String gender,
    required String dateOfBirth,
  }) async {
    try {
      final user = await remoteDataSource.register(
        first_name: first_name,
        last_name: last_name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
        nationalId: nationalId,
        gender: gender,
        dateOfBirth: dateOfBirth,
      );
      return Right(user);
    } on DioException catch (e) {
      return Left(NetworkExceptions.handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // TODO: Implement logout
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
