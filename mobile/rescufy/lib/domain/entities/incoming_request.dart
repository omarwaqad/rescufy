import 'package:equatable/equatable.dart';

class IncomingRequest extends Equatable {
  const IncomingRequest({
    required this.requestId,
    required this.caseId,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.emergencyType,
    required this.severity,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.hospitalName,
    required this.createdAt,
    this.aiSummary,
    this.allergies = const [],
    this.chronicDiseases = const [],
    this.currentMedications = const [],
    this.bloodType,
  });

  final int requestId;
  final String caseId;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final String emergencyType;
  final String severity;
  final String description;
  final String? aiSummary;
  final List<String> allergies;
  final List<String> chronicDiseases;
  final List<String> currentMedications;
  final String? bloodType;
  final double latitude;
  final double longitude;
  final String address;
  final String hospitalName;
  final DateTime createdAt;

  bool get hasCriticalMedicalData =>
      allergies.isNotEmpty || chronicDiseases.isNotEmpty;

  bool get isCritical =>
      severity.toLowerCase() == 'critical' || severity.toLowerCase() == 'high';

  String get googleMapsUrl =>
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';

  factory IncomingRequest.fromJson(Map<String, dynamic> json) {
    final patient = _readMap(json['patient'] ?? json['Patient']);
    final patientProfile = _readMap(patient['profile'] ?? patient['Profile']);
    final aiAnalysis = _readMap(json['aiAnalysis'] ?? json['AiAnalysis']);
    final assignment = _readFirstMap(
      json['assignments'] ?? json['Assignments'],
    );

    return IncomingRequest(
      requestId: _readInt(json, const ['requestId', 'RequestId', 'id', 'Id']),
      caseId: _readString(
        json,
        const ['caseId', 'CaseId'],
        fallback: _readString(json, const ['id', 'Id']),
      ),
      patientName: _readString(json, const [
        'patientName',
        'PatientName',
        'name',
      ], fallback: _readString(patient, const ['name', 'Name'], fallback: 'Unknown')),
      patientAge: _readInt(json, const ['patientAge', 'PatientAge', 'age']),
      patientGender: _readString(json, const [
        'patientGender',
        'PatientGender',
      ]),
      emergencyType: _readString(
        json,
        const ['emergencyType', 'EmergencyType', 'type'],
        fallback: _readString(
          aiAnalysis,
          const ['condition', 'Condition'],
          fallback: _readString(
            json,
            const ['requestStatus', 'RequestStatus'],
            fallback: 'Other',
          ),
        ),
      ),
      severity: _readString(
        json,
        const ['severity', 'Severity'],
        fallback: _readString(
          aiAnalysis,
          const ['severity', 'Severity'],
          fallback: _readString(
            aiAnalysis,
            const ['urgency', 'Urgency'],
            fallback: 'medium',
          ),
        ),
      ),
      description: _readString(json, const ['description', 'Description']),
      latitude: _readDouble(json, const ['latitude', 'Latitude', 'lat']),
      longitude: _readDouble(json, const ['longitude', 'Longitude', 'lng']),
      address: _readString(json, const ['address', 'Address']),
      hospitalName: _readString(json, const [
        'hospitalName',
        'HospitalName',
      ], fallback: _readString(assignment, const [
        'hospitalName',
        'HospitalName',
      ], fallback: 'Nearest Hospital')),
      createdAt:
          _readDate(json, const ['createdAt', 'CreatedAt']) ?? DateTime.now(),
      aiSummary:
          _readNullableString(json, const ['aiSummary', 'AiSummary']) ??
          _readNullableString(aiAnalysis, const ['summary', 'Summary']) ??
          _readNullableString(json, const ['comment', 'Comment']),
      bloodType:
          _readNullableString(json, const ['bloodType', 'BloodType']) ??
          _readNullableString(patientProfile, const ['bloodType', 'BloodType']),
      allergies: _readStringList(
        json['allergies'] ??
            json['Allergies'] ??
            patientProfile['allergies'] ??
            patientProfile['Allergies'],
      ),
      chronicDiseases: _readStringList(
        json['chronicDiseases'] ??
            json['ChronicDiseases'] ??
            patientProfile['chronicDiseases'] ??
            patientProfile['ChronicDiseases'],
      ),
      currentMedications: _readStringList(
        json['currentMedications'] ??
            json['CurrentMedications'] ??
            patientProfile['medications'] ??
            patientProfile['Medications'],
      ),
    );
  }

  static String _readString(
    Map<String, dynamic> json,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = json[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return fallback;
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

  static int _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value != null) return int.tryParse(value.toString()) ?? 0;
    }
    return 0;
  }

  static double _readDouble(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is num) return value.toDouble();
      if (value != null) return double.tryParse(value.toString()) ?? 0;
    }
    return 0;
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

  static List<String> _readStringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) {
            if (item is Map<String, dynamic>) {
              return _readString(item, const ['name', 'Name']);
            }
            if (item is Map) {
              return _readString(_castMap(item), const ['name', 'Name']);
            }
            return item?.toString().trim() ?? '';
          })
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const [];
  }

  static Map<String, dynamic> _readMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return _castMap(value);
    return const {};
  }

  static Map<String, dynamic> _readFirstMap(dynamic value) {
    if (value is List) {
      for (final item in value) {
        if (item is Map<String, dynamic>) return item;
        if (item is Map) return _castMap(item);
      }
    }
    return const {};
  }

  static Map<String, dynamic> _castMap(Map<dynamic, dynamic> map) {
    return map.map((key, value) => MapEntry(key.toString(), value));
  }

  @override
  List<Object?> get props => [
    requestId,
    caseId,
    patientName,
    patientAge,
    patientGender,
    emergencyType,
    severity,
    description,
    latitude,
    longitude,
    address,
    hospitalName,
    createdAt,
    aiSummary,
    allergies,
    chronicDiseases,
    currentMedications,
    bloodType,
  ];
}
