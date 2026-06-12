import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rescufy/data/datasources/remote/request_history_remote_datasource.dart';
import 'package:rescufy/data/models/request_history_model.dart';
import 'package:rescufy/data/repositories/request_history_repository_impl.dart';
import 'package:rescufy/domain/core/failures.dart';

class _SuccessRemoteDataSource implements RequestHistoryRemoteDataSource {
  @override
  Future<List<RequestHistoryModel>> getRequestHistory({
    int page = 1,
    int limit = 10,
    String? requestStatus,
    String? sort,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return [
      RequestHistoryModel.fromJson({
        'id': 1,
        'description': 'Emergency',
        'address': 'Street 1',
        'requestStatus': 'Pending',
        'createdAt': '2026-06-10T11:59:39.006Z',
        'patientName': 'User',
        'assignedAmbulancePlate': 'AMB-1',
      }),
    ];
  }
}

class _FailureRemoteDataSource implements RequestHistoryRemoteDataSource {
  @override
  Future<List<RequestHistoryModel>> getRequestHistory({
    int page = 1,
    int limit = 10,
    String? requestStatus,
    String? sort,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    throw DioException(
      requestOptions: RequestOptions(path: '/api/Request/history'),
      type: DioExceptionType.connectionTimeout,
    );
  }
}

void main() {
  group('RequestHistoryRepositoryImpl', () {
    test('returns mapped history on success', () async {
      final repository = RequestHistoryRepositoryImpl(
        _SuccessRemoteDataSource(),
      );

      final result = await repository.getRequestHistory();

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected success result'), (items) {
        expect(items, hasLength(1));
        expect(items.first.id, 1);
        expect(items.first.requestStatus, 'Pending');
      });
    });

    test('maps DioException to Failure', () async {
      final repository = RequestHistoryRepositoryImpl(
        _FailureRemoteDataSource(),
      );

      final result = await repository.getRequestHistory();

      expect(result, isA<Left<Failure, dynamic>>());
      result.fold(
        (failure) => expect(failure.message, 'Connection timeout'),
        (_) => fail('Expected failure result'),
      );
    });
  });
}
