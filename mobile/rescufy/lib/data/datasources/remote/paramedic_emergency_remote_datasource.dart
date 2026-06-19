import 'package:rescufy/core/network/dio_client.dart';
import '../../../core/network/endpoints/api_endpoints.dart';
import '../../../domain/entities/emergency_request.dart';
import '../../../domain/entities/incoming_request.dart';
import '../../models/medical_profile/paramedic_emergency_request_model.dart';
import '../../models/request_history_model.dart';

abstract class ParamedicEmergencyRemoteDataSource {
  Future<Stream<List<ParamedicEmergencyRequestModel>>> getIncomingRequests();
  Future<IncomingRequest> getIncomingRequestById(int requestId);
  Future<ParamedicEmergencyRequestModel> acceptRequest(int requestId);
  Future<void> rejectRequest(int requestId);
  Future<ParamedicEmergencyRequestModel> updateCaseStatus(
    int requestId,
    EmergencyStatus status,
  );
  Future<void> updateRequestDriverStatus(int requestId, String status);
  Future<List<ParamedicEmergencyRequestModel>> getCaseHistory();
  Future<List<RequestHistoryModel>> getParamedicRequests();
}

class EmergencyRemoteDataSourceImpl
    implements ParamedicEmergencyRemoteDataSource {
  final DioClient _dioClient;

  EmergencyRemoteDataSourceImpl(this._dioClient);

  @override
  Future<Stream<List<ParamedicEmergencyRequestModel>>>
  getIncomingRequests() async {
    // Simple polling implementation
    // In production, use WebSocket or Server-Sent Events
    return Stream.periodic(const Duration(seconds: 5), (_) async {
      try {
        final response = await _dioClient.get(ApiEndpoints.incomingRequests);

        if (response.statusCode == 200) {
          final data = _extractList(response.data);
          return data.map(ParamedicEmergencyRequestModel.fromJson).toList();
        }
        return <ParamedicEmergencyRequestModel>[];
      } catch (e) {
        return <ParamedicEmergencyRequestModel>[];
      }
    }).asyncMap((future) => future);
  }

  @override
  Future<IncomingRequest> getIncomingRequestById(int requestId) async {
    final response = await _dioClient.get(ApiEndpoints.requestById(requestId));
    final data = _extractResponseMap(response.data);

    return IncomingRequest.fromJson(data);
  }

  @override
  Future<ParamedicEmergencyRequestModel> acceptRequest(int requestId) async {
    final response = await _dioClient.post(ApiEndpoints.acceptRequest(requestId));

    return ParamedicEmergencyRequestModel.fromJson(
      _extractMap(response.data['data'] ?? response.data),
    );
  }

  @override
  Future<void> rejectRequest(int requestId) async {
    await _dioClient.post(ApiEndpoints.rejectRequest(requestId));
  }

  @override
  Future<ParamedicEmergencyRequestModel> updateCaseStatus(
    int requestId,
    EmergencyStatus status,
  ) async {
    final response = await _dioClient.dio.patch(
      ApiEndpoints.updateCaseStatus(requestId),
      data: {'status': _statusToString(status)},
    );

    return ParamedicEmergencyRequestModel.fromJson(
      _extractMap(response.data['data'] ?? response.data),
    );
  }

  @override
  Future<void> updateRequestDriverStatus(
    int requestId,
    String status,
  ) async {
    await _dioClient.put(
      ApiEndpoints.updateRequestDriverStatus(requestId),
      data: {'status': status, 'comment': ''},
    );
  }

  @override
  Future<List<ParamedicEmergencyRequestModel>> getCaseHistory() async {
    final response = await _dioClient.get(ApiEndpoints.caseHistory);

    final data = _extractList(response.data);
    return data.map(ParamedicEmergencyRequestModel.fromJson).toList();
  }

  @override
  Future<List<RequestHistoryModel>> getParamedicRequests() async {
    final response = await _dioClient.get(ApiEndpoints.paramedicRequests);

    final data = response.data;
    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(RequestHistoryModel.fromJson)
        .toList(growable: false);
  }

  List<Map<String, dynamic>> _extractList(dynamic data) {
    if (data is List) {
      return data.whereType<Map>().map(_castMap).toList();
    }
    if (data is Map<String, dynamic>) {
      for (final key in const ['data', 'items', 'result', 'results']) {
        final nested = data[key];
        if (nested is List) {
          return nested.whereType<Map>().map(_castMap).toList();
        }
      }
    }
    return const [];
  }

  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return _castMap(data);
    return const {};
  }

  Map<String, dynamic> _extractResponseMap(dynamic data) {
    final root = _extractMap(data);
    return _extractMap(root['data'] ?? root);
  }

  Map<String, dynamic> _castMap(Map<dynamic, dynamic> map) {
    return map.map((key, value) => MapEntry(key.toString(), value));
  }

  String _statusToString(EmergencyStatus status) {
    switch (status) {
      case EmergencyStatus.pending:
        return 'pending';
      case EmergencyStatus.accepted:
        return 'accepted';
      case EmergencyStatus.onRoute:
        return 'on_route';
      case EmergencyStatus.arrived:
        return 'arrived';
      case EmergencyStatus.completed:
        return 'completed';
      case EmergencyStatus.rejected:
        return 'rejected';
      case EmergencyStatus.cancelled:
        return 'cancelled';
    }
  }
}
