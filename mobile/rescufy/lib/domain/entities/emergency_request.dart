import 'package:equatable/equatable.dart';

enum EmergencyType {
  cardiacArrest,
  severeBleeding,
  fracturedLimb,
  strokeSymptoms,
  respiratoryDistress,
  other,
}

enum EmergencySeverity { critical, high, medium, low }

enum EmergencyStatus {
  pending,
  accepted,
  onRoute,
  arrived,
  completed,
  rejected,
  cancelled,
}

class EmergencyRequest extends Equatable {
  final String id;
  final String userId;
  final String? paramedicId;
  final EmergencyType type;
  final EmergencySeverity severity;
  final EmergencyStatus status;
  final String description;
  final double latitude;
  final double longitude;
  final double? distance;
  final String caseId;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final String? aiSummary;
  final int? responseTime;

  const EmergencyRequest({
    required this.id,
    required this.userId,
    this.paramedicId,
    required this.type,
    required this.severity,
    required this.status,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.distance,
    required this.caseId,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
    this.aiSummary,
    this.responseTime,
  });

  String get formattedDistance => distance != null
      ? '${distance!.toStringAsFixed(1)} km away'
      : 'Distance unknown';

  String get severityLabel {
    switch (severity) {
      case EmergencySeverity.critical:
        return 'CRITICAL';
      case EmergencySeverity.high:
        return 'HIGH';
      case EmergencySeverity.medium:
        return 'MEDIUM';
      case EmergencySeverity.low:
        return 'LOW';
    }
  }

  String get typeLabel {
    switch (type) {
      case EmergencyType.cardiacArrest:
        return 'Cardiac Arrest';
      case EmergencyType.severeBleeding:
        return 'Severe Bleeding';
      case EmergencyType.fracturedLimb:
        return 'Fractured Limb';
      case EmergencyType.strokeSymptoms:
        return 'Stroke Symptoms';
      case EmergencyType.respiratoryDistress:
        return 'Respiratory Distress';
      case EmergencyType.other:
        return 'Other Emergency';
    }
  }

  String get googleMapsUrl =>
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';

  @override
  List<Object?> get props => [
    id,
    userId,
    paramedicId,
    type,
    severity,
    status,
    description,
    latitude,
    longitude,
    distance,
    caseId,
    createdAt,
    acceptedAt,
    completedAt,
    aiSummary,
    responseTime,
  ];
}
