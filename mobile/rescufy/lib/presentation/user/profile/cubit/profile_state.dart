// lib/presentation/user/profile/cubit/profile_state.dart
import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  // Basic Info
  final String fullName;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final String currentLanguage;

  // Medical Stats
  final String bloodType;
  final int heightCm;
  final int weightKg;
  final String pregnancyStatus;
  final String medicalNotes;

  // Medical Details
  final List<Map<String, String>> medications;
  final List<Map<String, String>> allergies;
  final List<Map<String, String>> chronicDiseases;
  final List<Map<String, String>> pastSurgeries;
  final List<Map<String, String>> emergencyContacts;

  // Edit/Update state
  final bool isUpdating;
  final String? updateError;
  final String? updateSuccess;

  const ProfileState({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.profileImageUrl,
    this.currentLanguage = 'English',
    this.bloodType = '',
    this.heightCm = 0,
    this.weightKg = 0,
    this.pregnancyStatus = '',
    this.medicalNotes = '',
    this.medications = const [],
    this.allergies = const [],
    this.chronicDiseases = const [],
    this.pastSurgeries = const [],
    this.emergencyContacts = const [],
    this.isUpdating = false,
    this.updateError,
    this.updateSuccess,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    phone,
    profileImageUrl,
    currentLanguage,
    bloodType,
    heightCm,
    weightKg,
    pregnancyStatus,
    medicalNotes,
    medications,
    allergies,
    chronicDiseases,
    pastSurgeries,
    emergencyContacts,
    isUpdating,
    updateError,
    updateSuccess,
  ];

  ProfileState copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? profileImageUrl,
    String? currentLanguage,
    String? bloodType,
    int? heightCm,
    int? weightKg,
    String? pregnancyStatus,
    String? medicalNotes,
    List<Map<String, String>>? medications,
    List<Map<String, String>>? allergies,
    List<Map<String, String>>? chronicDiseases,
    List<Map<String, String>>? pastSurgeries,
    List<Map<String, String>>? emergencyContacts,
    bool? isUpdating,
    String? updateError,
    String? updateSuccess,
    bool clearUpdateError = false,
    bool clearUpdateSuccess = false,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      bloodType: bloodType ?? this.bloodType,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      pregnancyStatus: pregnancyStatus ?? this.pregnancyStatus,
      medicalNotes: medicalNotes ?? this.medicalNotes,
      medications: medications ?? this.medications,
      allergies: allergies ?? this.allergies,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      pastSurgeries: pastSurgeries ?? this.pastSurgeries,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      isUpdating: isUpdating ?? this.isUpdating,
      updateError: clearUpdateError ? null : (updateError ?? this.updateError),
      updateSuccess: clearUpdateSuccess
          ? null
          : (updateSuccess ?? this.updateSuccess),
    );
  }
}
