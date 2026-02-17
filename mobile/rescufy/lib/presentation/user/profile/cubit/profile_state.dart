// lib/presentation/features/profile/cubit/profile_state.dart
import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  // Basic Info
  final String fullName;
  final String email;
  final String phone;
  final String? profileImageUrl;

  // Medical Stats
  final String bloodType;
  final int heightCm;
  final int weightKg;
  final String pregnancyStatus;
  final String medicalNotes;

  // Medical Details (Lists of Maps for flexibility)
  final List<Map<String, String>> medications;
  final List<Map<String, String>> allergies;
  final List<Map<String, String>> chronicDiseases;
  final List<Map<String, String>> pastSurgeries;
  final List<Map<String, String>> emergencyContacts;

  const ProfileState({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.profileImageUrl,
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
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    phone,
    profileImageUrl,
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
  ];
}
