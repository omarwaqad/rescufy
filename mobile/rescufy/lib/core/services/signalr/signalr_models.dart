enum SignalRConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
}

enum SignalRNotificationType {
  receiveNotification,
  requestCreated,
  statusChanged,
  ambulanceReassigned,
  requestCancelled,
  reportAdded,
  newRequest,
  requestUpdated,
  receiveEmergencyRequest,
  unknown,
}

class SignalRNotification {
  const SignalRNotification({
    required this.type,
    required this.eventName,
    required this.data,
    this.requestId,
    this.title,
    this.message,
    this.status,
    this.receivedAt,
  });

  final SignalRNotificationType type;
  final String eventName;
  final Map<String, dynamic> data;
  final String? requestId;
  final String? title;
  final String? message;
  final String? status;
  final DateTime? receivedAt;

  bool get isEmergencyRequest =>
      type == SignalRNotificationType.receiveEmergencyRequest ||
      type == SignalRNotificationType.newRequest;
}

class AmbulanceLocationUpdate {
  const AmbulanceLocationUpdate({
    required this.requestId,
    required this.latitude,
    required this.longitude,
    this.updatedAt,
    this.raw = const {},
  });

  final String requestId;
  final double latitude;
  final double longitude;
  final DateTime? updatedAt;
  final Map<String, dynamic> raw;
}

class AmbulanceLocationDto {
  const AmbulanceLocationDto({
    required this.requestId,
    required this.latitude,
    required this.longitude,
  });

  final String requestId;
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => {
    'requestId': requestId,
    'latitude': latitude,
    'longitude': longitude,
  };
}

class RequestStatusUpdate {
  const RequestStatusUpdate({
    required this.requestId,
    required this.status,
    this.message,
    this.updatedAt,
    this.raw = const {},
  });

  final String requestId;
  final String status;
  final String? message;
  final DateTime? updatedAt;
  final Map<String, dynamic> raw;
}
