import 'package:hive/hive.dart';

part 'allergy_model.g.dart';

@HiveType(typeId: 2)
class AllergyModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String severity;

  @HiveField(3)
  final String notes;

  const AllergyModel({
    required this.id,
    required this.name,
    required this.severity,
    required this.notes,
  });

  factory AllergyModel.fromJson(Map<String, dynamic> json) {
    return AllergyModel(
      id: _readString(json, const ['id', 'Id', 'allergyId', 'AllergyId']),
      name: _readString(json, const ['name', 'Name', 'allergen', 'Allergen']),
      severity: _readString(json, const ['severity', 'Severity']),
      notes: _readString(json, const ['notes', 'Notes', 'description', 'Description']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'severity': severity,
      'notes': notes,
    };
  }

  AllergyModel copyWith({
    String? id,
    String? name,
    String? severity,
    String? notes,
  }) {
    return AllergyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      severity: severity ?? this.severity,
      notes: notes ?? this.notes,
    );
  }

  String get cacheKey => id.isNotEmpty ? id : '$name|$severity|$notes';

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
