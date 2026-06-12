import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rescufy/core/network/network_exceptions.dart';
import 'package:rescufy/data/datasources/local/profile_local_datasource.dart';
import 'package:rescufy/data/datasources/remote/profile_remote_datasource.dart';
import 'package:rescufy/data/models/medical_profile/profile_model.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/profile.dart';
import 'package:rescufy/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, Profile>> getCachedProfile() async {
    try {
      final cachedProfile = _localDataSource.getProfile();
      if (cachedProfile == null) {
        return const Left(CacheFailure('No cached profile found'));
      }
      return Right(cachedProfile);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> getProfile() async {
    final cachedProfile = _localDataSource.getProfile();

    try {
      final remoteProfile = await _remoteDataSource.getProfile();
      final resolvedProfile = _preserveCachedImage(
        remoteProfile,
        cachedProfile,
      );
      await _localDataSource.saveProfile(resolvedProfile);
      return Right(resolvedProfile);
    } on DioException catch (e) {
      if (cachedProfile != null) {
        return Right(cachedProfile);
      }
      return Left(NetworkExceptions.handleDioException(e));
    } catch (e) {
      if (cachedProfile != null) {
        return Right(cachedProfile);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(Profile profile) async {
    try {
      final requestModel = ProfileModel.fromEntity(profile);
      final cachedProfile = _localDataSource.getProfile();
      final updatedProfile = await _remoteDataSource.updateProfile(
        requestModel,
      );
      final resolvedProfile = _preserveCachedImage(
        updatedProfile,
        cachedProfile,
      );
      await _localDataSource.saveProfile(resolvedProfile);
      return Right(resolvedProfile);
    } on DioException catch (e) {
      return Left(NetworkExceptions.handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(File file) async {
    try {
      final imageUrl = await _remoteDataSource.uploadProfileImage(file);
      await _localDataSource.saveProfileImageUrl(imageUrl);
      return Right(imageUrl);
    } on DioException catch (e) {
      return Left(_mapProfileImageFailure(e));
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProfileImage() async {
    try {
      await _remoteDataSource.deleteProfileImage();
      await _localDataSource.saveProfileImageUrl(null);
      return Right(unit);
    } on DioException catch (e) {
      return Left(_mapProfileImageFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _mapProfileImageFailure(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      final rawMessage =
          responseData['message'] ??
          responseData['error'] ??
          responseData['title'] ??
          responseData['detail'];
      final message = rawMessage?.toString().trim().toLowerCase() ?? '';

      if (message.contains('large') ||
          message.contains('size') ||
          message.contains('too big')) {
        return const ValidationFailure('Selected image is too large');
      }

      if (message.contains('invalid') ||
          message.contains('format') ||
          message.contains('type')) {
        return const ValidationFailure('Selected file is not a valid image');
      }

      if (rawMessage != null && rawMessage.toString().trim().isNotEmpty) {
        return ServerFailure(rawMessage.toString().trim());
      }
    }

    return NetworkExceptions.handleDioException(error);
  }

  ProfileModel _preserveCachedImage(
    ProfileModel profile,
    ProfileModel? cachedProfile,
  ) {
    if (profile.profileImageUrl?.trim().isNotEmpty ?? false) {
      return profile;
    }

    return profile.copyWith(
      profileImageUrlValue: cachedProfile?.profileImageUrl,
    );
  }
}
