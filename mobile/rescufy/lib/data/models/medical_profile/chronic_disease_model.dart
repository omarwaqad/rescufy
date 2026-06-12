import 'package:hive/hive.dart';

part 'chronic_disease_model.g.dart';

@HiveType(typeId: 3)
class ChronicDiseaseModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String severity;

  @HiveField(3)
  final String diagnosedYear;

  const ChronicDiseaseModel({
    required this.id,
    required this.name,
    required this.severity,
    required this.diagnosedYear,
  });

  factory ChronicDiseaseModel.fromJson(Map<String, dynamic> json) {
    return ChronicDiseaseModel(
      id: _readString(json, const ['id', 'Id', 'diseaseId', 'DiseaseId']),
      name: _readString(json, const ['name', 'Name', 'diseaseName', 'DiseaseName']),
      severity: _readString(json, const ['severity', 'Severity']),
      diagnosedYear: _readString(json, const [
        'diagnosedYear',
        'DiagnosedYear',
        'diagnosed_year',
        'Diagnosed_Year',
        'year',
        'Year',
      ]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'severity': severity,
      'diagnosedYear': diagnosedYear,
    };
  }

  ChronicDiseaseModel copyWith({
    String? id,
    String? name,
    String? severity,
    String? diagnosedYear,
  }) {
    return ChronicDiseaseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      severity: severity ?? this.severity,
      diagnosedYear: diagnosedYear ?? this.diagnosedYear,
    );
  }

  String get cacheKey => id.isNotEmpty ? id : '$name|$severity|$diagnosedYear';

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) {
        return value.toString().trim();
      }
    }
    return '';
  }
}
