import 'package:rescufy/core/network/dio_client.dart';
import 'package:rescufy/core/network/endpoints/api_endpoints.dart';
import 'package:rescufy/data/models/hospital_model.dart';

abstract class HospitalRemoteDataSource {
  Future<List<HospitalModel>> getNearbyHospitals({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  });
}

class HospitalRemoteDataSourceImpl implements HospitalRemoteDataSource {
  HospitalRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<HospitalModel>> getNearbyHospitals({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.hospitalNearby,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radiusKm': radiusKm,
      },
    );

    final data = response.data;
    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(HospitalModel.fromJson)
        .toList(growable: false);
  }
}
