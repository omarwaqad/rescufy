import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/emergency_request.dart';
import '../../models/paramedic_emergency_request_model.dart';

abstract class ParamedicEmergencyRemoteDataSource {
  Future<Stream<List<ParamedicEmergencyRequestModel>>> getIncomingRequests();
  Future<ParamedicEmergencyRequestModel> acceptRequest(String requestId);
  Future<void> rejectRequest(String requestId);
  Future<ParamedicEmergencyRequestModel> updateCaseStatus(
    String requestId,
    EmergencyStatus status,
  );
  Future<List<ParamedicEmergencyRequestModel>> getCaseHistory();
}

class EmergencyRemoteDataSourceImpl
    implements ParamedicEmergencyRemoteDataSource {
  final Dio dio;

  EmergencyRemoteDataSourceImpl({required this.dio});

  @override
  Future<Stream<List<ParamedicEmergencyRequestModel>>>
  getIncomingRequests() async {
    // Simple polling implementation
    // In production, use WebSocket or Server-Sent Events
    return Stream.periodic(const Duration(seconds: 5), (_) async {
      try {
        final response = await dio.get(ApiEndpoints.incomingRequests);

        if (response.statusCode == 200) {
          final List<dynamic> data = response.data['data'] ?? [];
          return data
              .map(
                (json) => ParamedicEmergencyRequestModel.fromJson(
                  json as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        return <ParamedicEmergencyRequestModel>[];
      } catch (e) {
        return <ParamedicEmergencyRequestModel>[];
      }
    }).asyncMap((future) => future);
  }

  @override
  Future<ParamedicEmergencyRequestModel> acceptRequest(String requestId) async {
    final response = await dio.post(ApiEndpoints.acceptRequest(requestId));

    return ParamedicEmergencyRequestModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    await dio.post(ApiEndpoints.rejectRequest(requestId));
  }

  @override
  Future<ParamedicEmergencyRequestModel> updateCaseStatus(
    String requestId,
    EmergencyStatus status,
  ) async {
    final response = await dio.patch(
      ApiEndpoints.updateCaseStatus(requestId),
      data: {'status': _statusToString(status)},
    );

    return ParamedicEmergencyRequestModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<List<ParamedicEmergencyRequestModel>> getCaseHistory() async {
    final response = await dio.get(ApiEndpoints.caseHistory);

    final List<dynamic> data = response.data['data'] ?? [];
    return data
        .map(
          (json) => ParamedicEmergencyRequestModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
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
