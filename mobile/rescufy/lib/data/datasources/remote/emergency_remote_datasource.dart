import 'package:rescufy/core/network/dio_client.dart';
import 'package:rescufy/core/network/endpoints/api_endpoints.dart';
import 'package:rescufy/data/models/medical_profile/emergency_request_model.dart';
import 'package:rescufy/domain/entities/user_active_request.dart';

abstract class EmergencyRemoteDataSource {
  Future<Map<String, dynamic>> createEmergencyRequest(
    EmergencyRequestModel request,
  );
  Future<UserActiveRequest> getRequestById(int requestId);
}

class EmergencyRemoteDataSourceImpl implements EmergencyRemoteDataSource {
  final DioClient _dioClient;

  EmergencyRemoteDataSourceImpl(this._dioClient);

  @override
  Future<Map<String, dynamic>> createEmergencyRequest(
    EmergencyRequestModel request,
  ) async {
    final response = await _dioClient.post(
      ApiEndpoints.createEmergencyRequest,
      data: request.toJson(),
    );
    return response.data;
  }

  @override
  Future<UserActiveRequest> getRequestById(int requestId) async {
    final response = await _dioClient.get(
      ApiEndpoints.requestById(requestId),
    );
    final data = _extractMap(response.data);
    return UserActiveRequest.fromJson(data);
  }

  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return const {};
  }
}
