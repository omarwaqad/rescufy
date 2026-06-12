import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rescufy/core/network/dio_client.dart';
import 'package:rescufy/core/network/endpoints/profile_endpoints.dart';
import 'package:rescufy/data/models/medical_profile/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(ProfileModel profile);
  Future<String> uploadProfileImage(File file);
  Future<void> deleteProfileImage();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<ProfileModel> getProfile() async {
    final response = await _dioClient.get(ProfileEndpoints.getProfile);
    return ProfileModel.fromJson(_extractProfileMap(response.data));
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final response = await _dioClient.put(
      ProfileEndpoints.updateProfile,
      data: profile.toUpdateJson(),
    );
    return ProfileModel.fromJson(_extractProfileMap(response.data, profile));
  }

  @override
  Future<String> uploadProfileImage(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.isNotEmpty
            ? file.uri.pathSegments.last
            : 'profile_image',
      ),
    });

    final response = await _dioClient.post(
      ProfileEndpoints.postImageProfile,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return _extractImageUrl(response.data);
  }

  @override
  Future<void> deleteProfileImage() async {
    await _dioClient.delete(ProfileEndpoints.deleteImageProfile);
  }

  Map<String, dynamic> _extractProfileMap(
    dynamic data, [
    ProfileModel? fallback,
  ]) {
    if (data is Map<String, dynamic>) {
      final directKeys = [
        'bloodType',
        'BloodType',
        'weightKg',
        'WeightKg',
        'heightCm',
        'HeightCm',
        'pregnancyStatus',
        'PregnancyStatus',
        'medicalNotes',
        'MedicalNotes',
      ];

      if (directKeys.any(data.containsKey)) {
        return data;
      }

      for (final key in const ['data', 'profile', 'result']) {
        final nested = data[key];
        if (nested is Map<String, dynamic>) {
          return nested;
        }
      }
    }

    return fallback != null ? fallback.toUpdateJson() : <String, dynamic>{};
  }

  String _extractImageUrl(dynamic data) {
    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }

    if (data is Map<String, dynamic>) {
      for (final key in const [
        'imageUrl',
        'profileImageUrl',
        'profileImage',
        'url',
      ]) {
        final value = data[key]?.toString().trim();
        if (value != null && value.isNotEmpty) {
          return value;
        }
      }

      for (final key in const ['data', 'result']) {
        final nested = data[key];
        if (nested is Map<String, dynamic>) {
          final nestedUrl = _extractImageUrl(nested);
          if (nestedUrl.isNotEmpty) {
            return nestedUrl;
          }
        }
        if (nested is String && nested.trim().isNotEmpty) {
          return nested.trim();
        }
      }
    }

    throw const FormatException('Profile image URL was not found in response');
  }
}
