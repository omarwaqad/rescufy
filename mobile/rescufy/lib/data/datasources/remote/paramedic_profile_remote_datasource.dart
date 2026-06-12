import 'package:rescufy/core/network/dio_client.dart';
import 'package:rescufy/core/network/endpoints/api_endpoints.dart';
import 'package:rescufy/data/models/paramedic_profile_model.dart';

abstract class ParamedicProfileRemoteDataSource {
  Future<ParamedicProfileModel> getProfile();
}

class ParamedicProfileRemoteDataSourceImpl
    implements ParamedicProfileRemoteDataSource {
  ParamedicProfileRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<ParamedicProfileModel> getProfile() async {
    final response = await _dioClient.get(ApiEndpoints.paramedicProfile);
    final data = response.data;

    if (data is Map<String, dynamic>) {
      return ParamedicProfileModel.fromJson(_extractProfileMap(data));
    }

    throw const FormatException('Invalid paramedic profile response');
  }

  Map<String, dynamic> _extractProfileMap(Map<String, dynamic> data) {
    for (final key in const ['data', 'profile', 'result']) {
      final nested = data[key];
      if (nested is Map<String, dynamic>) {
        return nested;
      }
    }

    return data;
  }
}
