import 'package:hive/hive.dart';
import 'package:rescufy/domain/entities/profile.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class ProfileModel extends Profile {
  @HiveField(0)
  final String bloodTypeValue;

  @HiveField(1)
  final int weightKgValue;

  @HiveField(2)
  final int heightCmValue;

  @HiveField(3)
  final bool pregnancyStatusValue;

  @HiveField(4)
  final String medicalNotesValue;

  @HiveField(5)
  final String? profileImageUrlValue;

  const ProfileModel({
    required this.bloodTypeValue,
    required this.weightKgValue,
    required this.heightCmValue,
    required this.pregnancyStatusValue,
    required this.medicalNotesValue,
    this.profileImageUrlValue,
  }) : super(
         bloodType: bloodTypeValue,
         weightKg: weightKgValue,
         heightCm: heightCmValue,
         pregnancyStatus: pregnancyStatusValue,
         medicalNotes: medicalNotesValue,
         profileImageUrl: profileImageUrlValue,
       );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      bloodTypeValue: _readString(json, const ['bloodType', 'BloodType']),
      weightKgValue: _readInt(json, const ['weightKg', 'WeightKg', 'weight']),
      heightCmValue: _readInt(json, const ['heightCm', 'HeightCm', 'height']),
      pregnancyStatusValue: _readBool(json, const [
        'pregnancyStatus',
        'PregnancyStatus',
      ]),
      medicalNotesValue: _readString(json, const [
        'medicalNotes',
        'MedicalNotes',
      ]),
      profileImageUrlValue: _readNullableString(json, const [
        'profileImageUrl',
        'ProfileImageUrl',
        'profileImage',
        'ProfileImage',
        'imageUrl',
        'ImageUrl',
        'url',
        'Url',
      ]),
    );
  }

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      bloodTypeValue: profile.bloodType,
      weightKgValue: profile.weightKg,
      heightCmValue: profile.heightCm,
      pregnancyStatusValue: profile.pregnancyStatus,
      medicalNotesValue: profile.medicalNotes,
      profileImageUrlValue: profile.profileImageUrl,
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'bloodType': bloodType,
      'weightKg': weightKg,
      'heightCm': heightCm,
      'pregnancyStatus': pregnancyStatus,
      'medicalNotes': medicalNotes,
      'profileImageUrl': profileImageUrl,
    };
  }

  ProfileModel copyWith({
    String? bloodTypeValue,
    int? weightKgValue,
    int? heightCmValue,
    bool? pregnancyStatusValue,
    String? medicalNotesValue,
    Object? profileImageUrlValue = _sentinel,
  }) {
    return ProfileModel(
      bloodTypeValue: bloodTypeValue ?? this.bloodTypeValue,
      weightKgValue: weightKgValue ?? this.weightKgValue,
      heightCmValue: heightCmValue ?? this.heightCmValue,
      pregnancyStatusValue: pregnancyStatusValue ?? this.pregnancyStatusValue,
      medicalNotesValue: medicalNotesValue ?? this.medicalNotesValue,
      profileImageUrlValue: profileImageUrlValue == _sentinel
          ? this.profileImageUrlValue
          : profileImageUrlValue as String?,
    );
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key]?.toString().trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return '';
  }

  static String? _readNullableString(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key]?.toString().trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  static int _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) {
        return value;
      }
      if (value != null) {
        return int.tryParse(value.toString()) ?? 0;
      }
    }
    return 0;
  }

  static bool _readBool(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is bool) {
        return value;
      }
      if (value is num) {
        return value != 0;
      }
      if (value is String) {
        final normalized = value.trim().toLowerCase();
        if (normalized == 'true' ||
            normalized == 'yes' ||
            normalized == 'pregnant') {
          return true;
        }
        if (normalized == 'false' ||
            normalized == 'no' ||
            normalized == 'not pregnant') {
          return false;
        }
      }
    }
    return false;
  }

  static const Object _sentinel = Object();
}
