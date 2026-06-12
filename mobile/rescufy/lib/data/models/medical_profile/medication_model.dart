import 'package:hive/hive.dart';

part 'medication_model.g.dart';

@HiveType(typeId: 1)
class MedicationModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String dosage;

  @HiveField(3)
  final String frequency;

  const MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: _readString(json, const ['id', 'Id', 'medicationId', 'MedicationId']),
      name: _readString(json, const ['name', 'Name', 'medicationName', 'MedicationName']),
      dosage: _readString(json, const ['dosage', 'Dosage']),
      frequency: _readString(json, const ['frequency', 'Frequency']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
    };
  }

  MedicationModel copyWith({
    String? id,
    String? name,
    String? dosage,
    String? frequency,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
    );
  }

  String get cacheKey => id.isNotEmpty ? id : '$name|$dosage|$frequency';

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
