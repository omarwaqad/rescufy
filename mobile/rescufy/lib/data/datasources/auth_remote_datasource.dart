// lib/data/datasources/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> register({
    required String first_name,
    required String last_name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String nationalId,
    required String gender,
    required String dateOfBirth,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      return UserModel.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<UserModel> register({
    required String first_name,
    required String last_name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String nationalId,
    required String gender,
    required String dateOfBirth,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.register,
        data: {
          'first_name': first_name,
          'last_name': last_name,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
          'phone_number': phoneNumber,
          'national_id': nationalId,
          'gender': gender,
          'date_of_birth': dateOfBirth,
        },
      );

      return UserModel.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dioClient.post(ApiEndpoints.logout);
    } on DioException {
      rethrow;
    }
  }
}
