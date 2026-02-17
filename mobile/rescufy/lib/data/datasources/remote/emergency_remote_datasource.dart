import 'package:rescufy/core/network/dio_client.dart';
import 'package:rescufy/core/network/api_endpoints.dart';
import 'package:rescufy/data/models/emergency_request_model.dart';

abstract class EmergencyRemoteDataSource {
  Future<Map<String, dynamic>> createEmergencyRequest(
    EmergencyRequestModel request,
  );
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
}
