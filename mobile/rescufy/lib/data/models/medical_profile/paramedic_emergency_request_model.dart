import '../../../domain/entities/emergency_request.dart';

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
      id: _readString(json, const ['id', 'Id', 'requestId', 'RequestId']),
      userId: _readString(json, const ['userId', 'UserId']),
      paramedicId: _readNullableString(json, const [
        'paramedicId',
        'ParamedicId',
      ]),
      type: _typeFromString(_readString(json, const ['type', 'Type'])),
      severity: _severityFromString(
        _readString(json, const ['severity', 'Severity']),
      ),
      status: _statusFromString(_readString(json, const ['status', 'Status'])),
      description: _readString(json, const ['description', 'Description']),
      latitude: _readDouble(json, const ['latitude', 'Latitude', 'lat']),
      longitude: _readDouble(json, const ['longitude', 'Longitude', 'lng']),
      distance: _readNullableDouble(json, const ['distance', 'Distance']),
      caseId: _readString(json, const ['caseId', 'CaseId']),
      createdAt:
          _readDate(json, const ['createdAt', 'CreatedAt']) ?? DateTime.now(),
      acceptedAt: _readDate(json, const ['acceptedAt', 'AcceptedAt']),
      completedAt: _readDate(json, const ['completedAt', 'CompletedAt']),
      aiSummary: _readNullableString(json, const ['aiSummary', 'AiSummary']),
      responseTime: _readNullableInt(json, const [
        'responseTime',
        'ResponseTime',
      ]),
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

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return '';
  }

  static String? _readNullableString(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  static double _readDouble(Map<String, dynamic> json, List<String> keys) =>
      _readNullableDouble(json, keys) ?? 0;

  static double? _readNullableDouble(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value is num) return value.toDouble();
      if (value != null) {
        final parsed = double.tryParse(value.toString());
        if (parsed != null) return parsed;
      }
    }
    return null;
  }

  static int? _readNullableInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value != null) {
        final parsed = int.tryParse(value.toString());
        if (parsed != null) return parsed;
      }
    }
    return null;
  }

  static DateTime? _readDate(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key]?.toString().trim();
      if (value == null || value.isEmpty) continue;
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }
    return null;
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
