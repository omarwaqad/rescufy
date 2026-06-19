import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rescufy/core/network/network_exceptions.dart';
import 'package:rescufy/data/datasources/remote/notification_remote_datasource.dart';
import 'package:rescufy/data/models/notification_model.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/notification.dart';
import 'package:rescufy/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._remoteDataSource);

  final NotificationRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<Notification>>> getNotifications() async {
    try {
      final notifications = await _remoteDataSource.getNotifications();
      return Right(notifications);
    } on DioException catch (error) {
      return Left(NetworkExceptions.handleDioException(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await _remoteDataSource.getUnreadCount();
      return Right(count);
    } on DioException catch (error) {
      return Left(NetworkExceptions.handleDioException(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(int id) async {
    try {
      await _remoteDataSource.markAsRead(id);
      return const Right(null);
    } on DioException catch (error) {
      return Left(NetworkExceptions.handleDioException(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _remoteDataSource.markAllAsRead();
      return const Right(null);
    } on DioException catch (error) {
      return Left(NetworkExceptions.handleDioException(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(int id) async {
    try {
      await _remoteDataSource.deleteNotification(id);
      return const Right(null);
    } on DioException catch (error) {
      return Left(NetworkExceptions.handleDioException(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
