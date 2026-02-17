import '../../domain/entities/emergency_request.dart';

class ParamedicEmergencyRequestModel extends EmergencyRequest {
  const ParamedicEmergencyRequestModel({
    required super.id,
    required super.userId,
    super.paramedicId,
    required super.type,
    required super.severity,
    required super.status,
    required super.description,
    required super.latitude,
    required super.longitude,
    super.distance,
    required super.caseId,
    required super.createdAt,
    super.acceptedAt,
    super.completedAt,
    super.aiSummary,
    super.responseTime,
  });

  factory ParamedicEmergencyRequestModel.fromJson(Map<String, dynamic> json) {
    return ParamedicEmergencyRequestModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      paramedicId: json['paramedicId'] as String?,
      type: _typeFromString(json['type'] as String),
      severity: _severityFromString(json['severity'] as String),
      status: _statusFromString(json['status'] as String),
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distance: json['distance'] != null
          ? (json['distance'] as num).toDouble()
          : null,
      caseId: json['caseId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      aiSummary: json['aiSummary'] as String?,
      responseTime: json['responseTime'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'paramedicId': paramedicId,
      'type': _typeToString(type),
      'severity': _severityToString(severity),
      'status': _statusToString(status),
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'caseId': caseId,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'aiSummary': aiSummary,
      'responseTime': responseTime,
    };
  }

  static EmergencyType _typeFromString(String type) {
    switch (type.toLowerCase()) {
      case 'cardiac_arrest':
        return EmergencyType.cardiacArrest;
      case 'severe_bleeding':
        return EmergencyType.severeBleeding;
      case 'fractured_limb':
        return EmergencyType.fracturedLimb;
      case 'stroke_symptoms':
        return EmergencyType.strokeSymptoms;
      case 'respiratory_distress':
        return EmergencyType.respiratoryDistress;
      default:
        return EmergencyType.other;
    }
  }

  static String _typeToString(EmergencyType type) {
    switch (type) {
      case EmergencyType.cardiacArrest:
        return 'cardiac_arrest';
      case EmergencyType.severeBleeding:
        return 'severe_bleeding';
      case EmergencyType.fracturedLimb:
        return 'fractured_limb';
      case EmergencyType.strokeSymptoms:
        return 'stroke_symptoms';
      case EmergencyType.respiratoryDistress:
        return 'respiratory_distress';
      case EmergencyType.other:
        return 'other';
    }
  }

  static EmergencySeverity _severityFromString(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return EmergencySeverity.critical;
      case 'high':
        return EmergencySeverity.high;
      case 'medium':
        return EmergencySeverity.medium;
      default:
        return EmergencySeverity.low;
    }
  }

  static String _severityToString(EmergencySeverity severity) {
    switch (severity) {
      case EmergencySeverity.critical:
        return 'critical';
      case EmergencySeverity.high:
        return 'high';
      case EmergencySeverity.medium:
        return 'medium';
      case EmergencySeverity.low:
        return 'low';
    }
  }

  static EmergencyStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return EmergencyStatus.pending;
      case 'accepted':
        return EmergencyStatus.accepted;
      case 'on_route':
        return EmergencyStatus.onRoute;
      case 'arrived':
        return EmergencyStatus.arrived;
      case 'completed':
        return EmergencyStatus.completed;
      case 'rejected':
        return EmergencyStatus.rejected;
      case 'cancelled':
        return EmergencyStatus.cancelled;
      default:
        return EmergencyStatus.pending;
    }
  }

  static String _statusToString(EmergencyStatus status) {
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
