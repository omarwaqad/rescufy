import 'package:hive/hive.dart';

part 'past_surgery_model.g.dart';

@HiveType(typeId: 5)
class PastSurgeryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String year;

  @HiveField(3)
  final String notes;

  const PastSurgeryModel({
    required this.id,
    required this.name,
    required this.year,
    required this.notes,
  });

  factory PastSurgeryModel.fromJson(Map<String, dynamic> json) {
    return PastSurgeryModel(
      id: _readString(json, const ['id', 'Id', 'surgeryId', 'SurgeryId']),
      name: _readString(json, const ['name', 'Name', 'surgeryName', 'SurgeryName']),
      year: _readString(json, const ['year', 'Year', 'surgeryYear', 'SurgeryYear']),
      notes: _readString(json, const ['notes', 'Notes', 'description', 'Description']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'year': year,
      'notes': notes,
    };
  }

  PastSurgeryModel copyWith({
    String? id,
    String? name,
    String? year,
    String? notes,
  }) {
    return PastSurgeryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      year: year ?? this.year,
      notes: notes ?? this.notes,
    );
  }

  String get cacheKey => id.isNotEmpty ? id : '$name|$year|$notes';

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
