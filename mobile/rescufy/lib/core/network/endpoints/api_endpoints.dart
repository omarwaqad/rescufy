// lib/core/network/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = 'https://final1111.runasp.net';
  static const String signalRBaseUrl = 'https://final1111.runasp.net';

  // Auth
  static const String login = '$baseUrl/api/Auth/login';
  static const String register = '$baseUrl/api/Auth/register';
  static const String logout = '$baseUrl/api/Auth/logout';
  static const String verifyEmail =
      '$baseUrl/api/Auth/verify-registration-otp?';

  // Password Reset
  static const String forgotPassword = '$baseUrl/api/Auth/forget-password';
  static const String verifyResetPasswordOtp =
      '$baseUrl/api/Auth/verify-reset-password-otp';
  static const String resetPassword = '$baseUrl/api/Auth/reset-password';

  // Request
  static const String createEmergencyRequest = '$baseUrl/api/Request';
  // static const String getEmergencies = '$baseUrl/api/Request/{id}';
  static const String requestHistory = '$baseUrl/api/Request/history';
  static String requestById(int requestId) => '$baseUrl/api/Request/$requestId';

  // Paramedic
  static const String paramedicProfile = '$baseUrl/api/Paramedic/profile';
  static const String incomingRequests =
      '$baseUrl/api/paramedic/incoming-requests';
  static const String caseHistory = '$baseUrl/api/paramedic/case-history';

  static String acceptRequest(int requestId) =>
      '$baseUrl/api/paramedic/requests/$requestId/accept';

  static String rejectRequest(int requestId) =>
      '$baseUrl/api/paramedic/requests/$requestId/reject';

  static String updateCaseStatus(int requestId) =>
      '$baseUrl/api/paramedic/requests/$requestId/status';
  static const String paramedicHistory = '/paramedic/history';
  //static const String paramedicProfile = '/paramedic/profile';

  // Hospital
  static const String hospitalNearby = '$baseUrl/api/Hospital/nearby';

  // ── SignalR ─────────────────────────────────────────────────────────────────
  static const String notificationHubUrl = '$signalRBaseUrl/hubs/notifications';
  static const String ambulanceHubUrl = '$signalRBaseUrl/hubs/ambulance';
}
