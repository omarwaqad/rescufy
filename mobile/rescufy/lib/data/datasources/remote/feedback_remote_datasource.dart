import 'package:rescufy/core/network/dio_client.dart';
import 'package:rescufy/core/network/endpoints/api_endpoints.dart';
import 'package:rescufy/data/models/feedback/driver_feedback_model.dart';
import 'package:rescufy/data/models/feedback/hospital_feedback_model.dart';
import 'package:rescufy/data/models/feedback/paramedic_feedback_model.dart';

abstract class FeedbackRemoteDataSource {
  Future<void> submitDriverFeedback(DriverFeedbackModel feedback);
  Future<void> submitParamedicFeedback(ParamedicFeedbackModel feedback);
  Future<void> submitHospitalFeedback(HospitalFeedbackModel feedback);
}

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final DioClient _dioClient;

  FeedbackRemoteDataSourceImpl(this._dioClient);

  @override
  Future<void> submitDriverFeedback(DriverFeedbackModel feedback) async {
    await _dioClient.post(
      ApiEndpoints.driverFeedback,
      data: feedback.toJson(),
    );
  }

  @override
  Future<void> submitParamedicFeedback(ParamedicFeedbackModel feedback) async {
    await _dioClient.post(
      ApiEndpoints.paramedicFeedback,
      data: feedback.toJson(),
    );
  }

  @override
  Future<void> submitHospitalFeedback(HospitalFeedbackModel feedback) async {
    await _dioClient.post(
      ApiEndpoints.hospitalFeedback,
      data: feedback.toJson(),
    );
  }
}
