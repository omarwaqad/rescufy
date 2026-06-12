import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/request_history.dart';
import 'package:rescufy/domain/repositories/request_history_repository.dart';
import 'package:rescufy/presentation/user/history/cubit/request_history_cubit.dart';
import 'package:rescufy/presentation/user/history/cubit/request_history_state.dart';

class _FakeRequestHistoryRepository implements RequestHistoryRepository {
  _FakeRequestHistoryRepository(this._responses);

  final List<Either<Failure, List<RequestHistory>>> _responses;
  int callCount = 0;

  @override
  Future<Either<Failure, List<RequestHistory>>> getRequestHistory({
    int page = 1,
    int limit = 10,
    String? requestStatus,
    String? sort,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response = _responses[callCount];
    callCount += 1;
    return response;
  }
}

RequestHistory _request(int id) {
  return RequestHistory(
    id: id,
    description: 'Emergency $id',
    address: 'Street $id',
    requestStatus: 'Pending',
    createdAt: DateTime.parse('2026-06-10T11:59:39.006Z'),
    patientName: 'User $id',
    assignedAmbulancePlate: 'AMB-$id',
  );
}

void main() {
  group('RequestHistoryCubit', () {
    test('loads initial request history successfully', () async {
      final repository = _FakeRequestHistoryRepository([
        Right([_request(1), _request(2)]),
      ]);
      final cubit = RequestHistoryCubit(repository);

      final emittedStates = <RequestHistoryState>[];
      final subscription = cubit.stream.listen(emittedStates.add);

      await cubit.loadRequestHistory();

      expect(
        emittedStates.any(
          (state) => state.status == RequestHistoryStatus.loading,
        ),
        isTrue,
      );
      expect(cubit.state.status, RequestHistoryStatus.success);
      expect(cubit.state.items, hasLength(2));
      expect(cubit.state.currentPage, 1);

      await subscription.cancel();
      await cubit.close();
    });

    test('refresh replaces items and load more appends', () async {
      final repository = _FakeRequestHistoryRepository([
        Right(List.generate(10, (index) => _request(index + 1))),
        Right([_request(11), _request(12)]),
        Right([_request(50)]),
      ]);
      final cubit = RequestHistoryCubit(repository);

      await cubit.loadRequestHistory();
      expect(cubit.state.items, hasLength(10));
      expect(cubit.state.hasMore, isTrue);

      await cubit.loadMore();
      expect(cubit.state.items, hasLength(12));
      expect(cubit.state.currentPage, 2);
      expect(cubit.state.hasMore, isFalse);

      await cubit.refresh();
      expect(cubit.state.items, hasLength(1));
      expect(cubit.state.currentPage, 1);
      expect(cubit.state.isRefreshing, isFalse);

      await cubit.close();
    });

    test('emits error on failed initial load', () async {
      final repository = _FakeRequestHistoryRepository([
        const Left(ServerFailure('Request failed')),
      ]);
      final cubit = RequestHistoryCubit(repository);

      await cubit.loadRequestHistory();

      expect(cubit.state.status, RequestHistoryStatus.error);
      expect(cubit.state.errorMessage, 'Request failed');

      await cubit.close();
    });
  });
}
