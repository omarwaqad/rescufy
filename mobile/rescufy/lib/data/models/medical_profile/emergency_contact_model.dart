import 'package:hive/hive.dart';

part 'emergency_contact_model.g.dart';

@HiveType(typeId: 4)
class EmergencyContactModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String relation;

  const EmergencyContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.relation,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      id: _readString(json, const ['id', 'Id', 'contactId', 'ContactId']),
      name: _readString(json, const ['name', 'Name', 'fullName', 'FullName']),
      phone: _readString(json, const ['phone', 'Phone', 'phoneNumber', 'PhoneNumber']),
      relation: _readString(json, const ['relation', 'Relation', 'relationship', 'Relationship']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'relation': relation,
    };
  }

  EmergencyContactModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? relation,
  }) {
    return EmergencyContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relation: relation ?? this.relation,
    );
  }

  String get cacheKey => id.isNotEmpty ? id : '$name|$phone|$relation';

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
