import 'package:rescufy/core/network/dio_client.dart';
import 'package:rescufy/core/network/endpoints/api_endpoints.dart';
import 'package:rescufy/data/models/request_history_model.dart';

abstract class RequestHistoryRemoteDataSource {
  Future<List<RequestHistoryModel>> getRequestHistory({
    int page = 1,
    int limit = 10,
    String? requestStatus,
    String? sort,
    DateTime? startDate,
    DateTime? endDate,
  });
}

class RequestHistoryRemoteDataSourceImpl
    implements RequestHistoryRemoteDataSource {
  RequestHistoryRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<RequestHistoryModel>> getRequestHistory({
    int page = 1,
    int limit = 10,
    String? requestStatus,
    String? sort,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.requestHistory,
      queryParameters: {
        'Page': page,
        'Limit': limit,
        if (requestStatus != null && requestStatus.isNotEmpty)
          'RequestStatus': requestStatus,
        if (sort != null && sort.isNotEmpty) 'Sort': sort,
        if (startDate != null) 'StartDate': startDate.toUtc().toIso8601String(),
        if (endDate != null) 'EndDate': endDate.toUtc().toIso8601String(),
      },
    );

    final data = response.data;
    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(RequestHistoryModel.fromJson)
        .toList(growable: false);
  }
}
