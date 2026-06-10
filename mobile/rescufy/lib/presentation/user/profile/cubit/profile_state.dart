import 'package:equatable/equatable.dart';
import 'package:rescufy/domain/entities/profile.dart';

class ProfileState extends Equatable {
  static const _unset = Object();

  final String fullName;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final String currentLanguage;
  final String bloodType;
  final int heightCm;
  final int weightKg;
  final bool pregnancyStatus;
  final String medicalNotes;
  final List<Map<String, String>> medications;
  final List<Map<String, String>> allergies;
  final List<Map<String, String>> chronicDiseases;
  final List<Map<String, String>> pastSurgeries;
  final List<Map<String, String>> emergencyContacts;
  final bool isLoading;
  final bool isRefreshing;
  final bool isUpdating;
  final bool hasLoadedProfile;
  final String? loadError;
  final String? updateError;
  final String? updateSuccess;
  final bool isUploadingImage;
  final bool isDeletingImage;
  final String? uploadImageSuccessUrl;
  final String? uploadImageError;
  final bool deleteImageSuccess;
  final String? deleteImageError;

  const ProfileState({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.profileImageUrl,
    this.currentLanguage = 'English',
    this.bloodType = '',
    this.heightCm = 0,
    this.weightKg = 0,
    this.pregnancyStatus = false,
    this.medicalNotes = '',
    this.medications = const [],
    this.allergies = const [],
    this.chronicDiseases = const [],
    this.pastSurgeries = const [],
    this.emergencyContacts = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.isUpdating = false,
    this.hasLoadedProfile = false,
    this.loadError,
    this.updateError,
    this.updateSuccess,
    this.isUploadingImage = false,
    this.isDeletingImage = false,
    this.uploadImageSuccessUrl,
    this.uploadImageError,
    this.deleteImageSuccess = false,
    this.deleteImageError,
  });

  bool get hasProfileData =>
      (profileImageUrl?.trim().isNotEmpty ?? false) ||
      bloodType.trim().isNotEmpty ||
      weightKg > 0 ||
      heightCm > 0 ||
      medications.isNotEmpty ||
      allergies.isNotEmpty ||
      chronicDiseases.isNotEmpty ||
      pastSurgeries.isNotEmpty ||
      emergencyContacts.isNotEmpty ||
      medicalNotes.trim().isNotEmpty ||
      hasLoadedProfile;

  Profile toProfile() {
    return Profile(
      bloodType: bloodType,
      weightKg: weightKg,
      heightCm: heightCm,
      pregnancyStatus: pregnancyStatus,
      medicalNotes: medicalNotes,
      profileImageUrl: profileImageUrl,
    );
  }

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
    isLoading,
    isRefreshing,
    isUpdating,
    hasLoadedProfile,
    loadError,
    updateError,
    updateSuccess,
    isUploadingImage,
    isDeletingImage,
    uploadImageSuccessUrl,
    uploadImageError,
    deleteImageSuccess,
    deleteImageError,
  ];

  ProfileState copyWith({
    String? fullName,
    String? email,
    String? phone,
    Object? profileImageUrl = _unset,
    String? currentLanguage,
    String? bloodType,
    int? heightCm,
    int? weightKg,
    bool? pregnancyStatus,
    String? medicalNotes,
    List<Map<String, String>>? medications,
    List<Map<String, String>>? allergies,
    List<Map<String, String>>? chronicDiseases,
    List<Map<String, String>>? pastSurgeries,
    List<Map<String, String>>? emergencyContacts,
    bool? isLoading,
    bool? isRefreshing,
    bool? isUpdating,
    bool? hasLoadedProfile,
    String? loadError,
    String? updateError,
    String? updateSuccess,
    bool? isUploadingImage,
    bool? isDeletingImage,
    String? uploadImageSuccessUrl,
    String? uploadImageError,
    bool? deleteImageSuccess,
    String? deleteImageError,
    bool clearLoadError = false,
    bool clearUpdateError = false,
    bool clearUpdateSuccess = false,
    bool clearUploadImageSuccess = false,
    bool clearUploadImageError = false,
    bool clearDeleteImageSuccess = false,
    bool clearDeleteImageError = false,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl == _unset
          ? this.profileImageUrl
          : profileImageUrl as String?,
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
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isUpdating: isUpdating ?? this.isUpdating,
      hasLoadedProfile: hasLoadedProfile ?? this.hasLoadedProfile,
      loadError: clearLoadError ? null : (loadError ?? this.loadError),
      updateError: clearUpdateError ? null : (updateError ?? this.updateError),
      updateSuccess: clearUpdateSuccess
          ? null
          : (updateSuccess ?? this.updateSuccess),
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      isDeletingImage: isDeletingImage ?? this.isDeletingImage,
      uploadImageSuccessUrl: clearUploadImageSuccess
          ? null
          : (uploadImageSuccessUrl ?? this.uploadImageSuccessUrl),
      uploadImageError: clearUploadImageError
          ? null
          : (uploadImageError ?? this.uploadImageError),
      deleteImageSuccess: clearDeleteImageSuccess
          ? false
          : (deleteImageSuccess ?? this.deleteImageSuccess),
      deleteImageError: clearDeleteImageError
          ? null
          : (deleteImageError ?? this.deleteImageError),
    );
  }
}
