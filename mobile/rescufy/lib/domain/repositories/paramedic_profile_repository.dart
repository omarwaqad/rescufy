import 'package:dartz/dartz.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/paramedic_profile.dart';

abstract class ParamedicProfileRepository {
  Future<Either<Failure, ParamedicProfile>> getProfile();
}
