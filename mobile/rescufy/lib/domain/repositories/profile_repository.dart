import 'package:dartz/dartz.dart';
import 'dart:io';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getCachedProfile();
  Future<Either<Failure, Profile>> getProfile();
  Future<Either<Failure, Profile>> updateProfile(Profile profile);
  Future<Either<Failure, String>> uploadProfileImage(File file);
  Future<Either<Failure, Unit>> deleteProfileImage();
}
