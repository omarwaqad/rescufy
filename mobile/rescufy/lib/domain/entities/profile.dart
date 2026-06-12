import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String bloodType;
  final int weightKg;
  final int heightCm;
  final bool pregnancyStatus;
  final String medicalNotes;
  final String? profileImageUrl;

  const Profile({
    required this.bloodType,
    required this.weightKg,
    required this.heightCm,
    required this.pregnancyStatus,
    required this.medicalNotes,
    this.profileImageUrl,
  });

  const Profile.empty()
    : bloodType = '',
      weightKg = 0,
      heightCm = 0,
      pregnancyStatus = false,
      medicalNotes = '',
      profileImageUrl = null;

  @override
  List<Object?> get props => [
    bloodType,
    weightKg,
    heightCm,
    pregnancyStatus,
    medicalNotes,
    profileImageUrl,
  ];
}
