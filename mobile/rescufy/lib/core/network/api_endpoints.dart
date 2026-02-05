// lib/core/network/api_endpoints.dart
class ApiEndpoints {
  // Auth
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String logout = 'auth/logout';
  static const String forgotPassword = 'auth/forgot-password';

  // User
  static const String profile = 'user/profile';
  static const String updateProfile = 'user/update';

  // Emergency
  static const String createEmergency = 'emergency/create';
  static const String getEmergencies = 'emergency/list';
}
