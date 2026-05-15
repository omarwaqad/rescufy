import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rescufy/core/cubit/locale/locale_cubit.dart';
import 'package:rescufy/core/navigation/app_routes.dart';
import 'package:rescufy/data/models/medical_profile/allergy_model.dart';
import 'package:rescufy/data/models/medical_profile/chronic_disease_model.dart';
import 'package:rescufy/data/models/medical_profile/emergency_contact_model.dart';
import 'package:rescufy/data/models/medical_profile/medication_model.dart';
import 'package:rescufy/data/models/medical_profile/past_surgery_model.dart';
import 'package:rescufy/data/repositories/medical_repository.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/profile.dart';
import 'package:rescufy/domain/repositories/profile_repository.dart';
import 'package:rescufy/presentation/auth/cubit/auth/auth_cubit.dart';
import 'package:rescufy/presentation/auth/cubit/auth/auth_state.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._localeCubit,
    this._authCubit,
    this._profileRepository,
    this._medicalRepository,
    this._imagePicker,
  ) : super(const ProfileState()) {
    _localeSubscription = _localeCubit.stream.listen((_) => _updateLanguage());
    _seedUserState();
  }

  final LocaleCubit _localeCubit;
  final AuthCubit _authCubit;
  final ProfileRepository _profileRepository;
  final MedicalRepository _medicalRepository;
  final ImagePicker _imagePicker;
  late final StreamSubscription _localeSubscription;

  BuildContext? _context;

  void initialize(BuildContext context) {
    _context = context;
    _seedUserState();
    unawaited(_restoreCachedProfile());
    unawaited(loadProfile());
  }

  Future<void> _restoreCachedProfile() async {
    final cachedProfileResult = await _profileRepository.getCachedProfile();
    cachedProfileResult.fold((_) {}, (cachedProfile) {
      emit(
        _applyProfile(
          cachedProfile,
          hasLoadedProfile: _hasProfileData(cachedProfile),
          clearLoadError: true,
        ),
      );
    });
  }

  Future<void> loadProfile() async {
    if (state.isLoading || state.isRefreshing) {
      return;
    }

    _seedUserState();
    emit(
      state.copyWith(
        isLoading: true,
        isRefreshing: false,
        clearLoadError: true,
        clearUpdateError: true,
      ),
    );

    final results = await Future.wait<dynamic>([
      _profileRepository.getProfile(),
      _medicalRepository.getMedications(),
      _medicalRepository.getAllergies(),
      _medicalRepository.getChronicDiseases(),
      _medicalRepository.getPastSurgeries(),
      _medicalRepository.getEmergencyContacts(),
    ]);

    Profile profile = state.toProfile();
    var hasLoadedProfile = state.hasLoadedProfile;
    var medications = state.medications;
    var allergies = state.allergies;
    var chronicDiseases = state.chronicDiseases;
    var pastSurgeries = state.pastSurgeries;
    var emergencyContacts = state.emergencyContacts;
    String? loadError;

    final profileResult = results[0] as Either<Failure, Profile>;
    final medicationsResult =
        results[1] as Either<Failure, List<MedicationModel>>;
    final allergiesResult = results[2] as Either<Failure, List<AllergyModel>>;
    final chronicDiseasesResult =
        results[3] as Either<Failure, List<ChronicDiseaseModel>>;
    final pastSurgeriesResult =
        results[4] as Either<Failure, List<PastSurgeryModel>>;
    final emergencyContactsResult =
        results[5] as Either<Failure, List<EmergencyContactModel>>;

    profileResult.fold((failure) => loadError ??= failure.message, (
      loadedProfile,
    ) {
      profile = loadedProfile;
      hasLoadedProfile = true;
    });
    medicationsResult.fold(
      (failure) => loadError ??= failure.message,
      (items) => medications = items.map(_medicationToMap).toList(),
    );
    allergiesResult.fold(
      (failure) => loadError ??= failure.message,
      (items) => allergies = items.map(_allergyToMap).toList(),
    );
    chronicDiseasesResult.fold(
      (failure) => loadError ??= failure.message,
      (items) => chronicDiseases = items.map(_chronicDiseaseToMap).toList(),
    );
    pastSurgeriesResult.fold(
      (failure) => loadError ??= failure.message,
      (items) => pastSurgeries = items.map(_pastSurgeryToMap).toList(),
    );
    emergencyContactsResult.fold(
      (failure) => loadError ??= failure.message,
      (items) => emergencyContacts = items.map(_emergencyContactToMap).toList(),
    );

    emit(
      _applyProfile(
        profile,
        medications: medications,
        allergies: allergies,
        chronicDiseases: chronicDiseases,
        pastSurgeries: pastSurgeries,
        emergencyContacts: emergencyContacts,
        isLoading: false,
        isRefreshing: false,
        hasLoadedProfile: hasLoadedProfile,
        loadError: loadError,
        clearUpdateError: true,
      ),
    );
  }

  Future<void> updateProfile({
    required String bloodType,
    required int weightKg,
    required int heightCm,
    required bool pregnancyStatus,
    required String medicalNotes,
  }) async {
    if (state.isUpdating) {
      return;
    }

    emit(
      state.copyWith(
        isUpdating: true,
        clearUpdateError: true,
        clearUpdateSuccess: true,
      ),
    );

    final result = await _profileRepository.updateProfile(
      Profile(
        bloodType: bloodType.trim(),
        weightKg: weightKg,
        heightCm: heightCm,
        pregnancyStatus: pregnancyStatus,
        medicalNotes: medicalNotes.trim(),
        profileImageUrl: state.profileImageUrl,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isUpdating: false,
            updateError: failure.message,
            clearUpdateSuccess: true,
          ),
        );
      },
      (profile) {
        emit(
          _applyProfile(
            profile,
            isUpdating: false,
            hasLoadedProfile: true,
            updateSuccess: 'Profile updated successfully',
            clearUpdateError: true,
          ),
        );
        _clearFeedback();
      },
    );
  }

  Future<void> pickProfileImageFromGallery() async {
    if (state.isUploadingImage || state.isDeletingImage) {
      return;
    }

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) {
        return;
      }

      await uploadProfileImage(File(pickedFile.path));
    } catch (_) {
      emit(
        state.copyWith(
          uploadImageError: 'Unable to pick image from gallery',
          updateError: 'Unable to pick image from gallery',
          clearUploadImageSuccess: true,
          clearDeleteImageError: true,
          clearDeleteImageSuccess: true,
          clearUpdateSuccess: true,
        ),
      );
      _clearFeedback();
    }
  }

  Future<void> uploadProfileImage(File file) async {
    if (state.isUploadingImage || state.isDeletingImage) {
      return;
    }

    final validationMessage = await _validateProfileImage(file);
    if (validationMessage != null) {
      emit(
        state.copyWith(
          uploadImageError: validationMessage,
          updateError: validationMessage,
          clearUploadImageSuccess: true,
          clearDeleteImageError: true,
          clearDeleteImageSuccess: true,
          clearUpdateSuccess: true,
        ),
      );
      _clearFeedback();
      return;
    }

    emit(
      state.copyWith(
        isUploadingImage: true,
        clearUploadImageError: true,
        clearUploadImageSuccess: true,
        clearDeleteImageError: true,
        clearDeleteImageSuccess: true,
        clearUpdateError: true,
        clearUpdateSuccess: true,
      ),
    );

    final result = await _profileRepository.uploadProfileImage(file);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isUploadingImage: false,
            uploadImageError: failure.message,
            updateError: failure.message,
            clearUploadImageSuccess: true,
            clearUpdateSuccess: true,
          ),
        );
        _clearFeedback();
      },
      (imageUrl) {
        emit(
          state.copyWith(
            profileImageUrl: imageUrl,
            isUploadingImage: false,
            uploadImageSuccessUrl: imageUrl,
            updateSuccess: 'Profile image updated successfully',
            clearUploadImageError: true,
            clearUpdateError: true,
          ),
        );
        _clearFeedback();
      },
    );
  }

  Future<void> deleteProfileImage() async {
    if (state.isDeletingImage || state.isUploadingImage) {
      return;
    }

    emit(
      state.copyWith(
        isDeletingImage: true,
        clearDeleteImageError: true,
        clearDeleteImageSuccess: true,
        clearUploadImageError: true,
        clearUploadImageSuccess: true,
        clearUpdateError: true,
        clearUpdateSuccess: true,
      ),
    );

    final result = await _profileRepository.deleteProfileImage();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isDeletingImage: false,
            deleteImageError: failure.message,
            updateError: failure.message,
            clearDeleteImageSuccess: true,
            clearUpdateSuccess: true,
          ),
        );
        _clearFeedback();
      },
      (_) {
        emit(
          state.copyWith(
            profileImageUrl: null,
            isDeletingImage: false,
            deleteImageSuccess: true,
            updateSuccess: 'Profile image removed successfully',
            clearDeleteImageError: true,
            clearUpdateError: true,
          ),
        );
        _clearFeedback();
      },
    );
  }

  Future<void> addMedication(Map<String, String> medication) async {
    await _performMedicalMutation<MedicationModel>(
      operation: () =>
          _medicalRepository.addMedication(_medicationFromMap(medication)),
      onSuccess: (item) {
        final updated = List<Map<String, String>>.from(state.medications)
          ..add(_medicationToMap(item));
        return state.copyWith(
          medications: updated,
          updateSuccess: 'Medication added',
        );
      },
    );
  }

  Future<void> updateMedication(
    int index,
    Map<String, String> medication,
  ) async {
    final id = state.medications[index]['id'] ?? '';
    if (id.isEmpty) {
      _emitMissingItemIdError('medication');
      return;
    }

    await _performMedicalMutation<MedicationModel>(
      operation: () => _medicalRepository.updateMedication(
        _medicationFromMap({...medication, 'id': id}),
      ),
      onSuccess: (item) {
        final updated = List<Map<String, String>>.from(state.medications);
        updated[index] = _medicationToMap(item);
        return state.copyWith(
          medications: updated,
          updateSuccess: 'Medication updated',
        );
      },
    );
  }

  Future<void> deleteMedication(int index) async {
    final id = state.medications[index]['id'] ?? '';
    if (id.isEmpty) {
      _emitMissingItemIdError('medication');
      return;
    }

    await _performDeleteMutation(
      operation: () => _medicalRepository.deleteMedication(id),
      onSuccess: () {
        final updated = List<Map<String, String>>.from(state.medications)
          ..removeAt(index);
        return state.copyWith(
          medications: updated,
          updateSuccess: 'Medication removed',
        );
      },
    );
  }

  Future<void> addAllergy(Map<String, String> allergy) async {
    await _performMedicalMutation<AllergyModel>(
      operation: () => _medicalRepository.addAllergy(_allergyFromMap(allergy)),
      onSuccess: (item) {
        final updated = List<Map<String, String>>.from(state.allergies)
          ..add(_allergyToMap(item));
        return state.copyWith(
          allergies: updated,
          updateSuccess: 'Allergy added',
        );
      },
    );
  }

  Future<void> updateAllergy(int index, Map<String, String> allergy) async {
    final id = state.allergies[index]['id'] ?? '';
    if (id.isEmpty) {
      _emitMissingItemIdError('allergy');
      return;
    }

    await _performMedicalMutation<AllergyModel>(
      operation: () => _medicalRepository.updateAllergy(
        _allergyFromMap({...allergy, 'id': id}),
      ),
      onSuccess: (item) {
        final updated = List<Map<String, String>>.from(state.allergies);
        updated[index] = _allergyToMap(item);
        return state.copyWith(
          allergies: updated,
          updateSuccess: 'Allergy updated',
        );
      },
    );
  }

  Future<void> deleteAllergy(int index) async {
    final id = state.allergies[index]['id'] ?? '';
    if (id.isEmpty) {
      _emitMissingItemIdError('allergy');
      return;
    }

    await _performDeleteMutation(
      operation: () => _medicalRepository.deleteAllergy(id),
      onSuccess: () {
        final updated = List<Map<String, String>>.from(state.allergies)
          ..removeAt(index);
        return state.copyWith(
          allergies: updated,
          updateSuccess: 'Allergy removed',
        );
      },
    );
  }

  Future<void> addDisease(Map<String, String> disease) async {
    await _performMedicalMutation<ChronicDiseaseModel>(
      operation: () =>
          _medicalRepository.addChronicDisease(_chronicDiseaseFromMap(disease)),
      onSuccess: (item) {
        final updated = List<Map<String, String>>.from(state.chronicDiseases)
          ..add(_chronicDiseaseToMap(item));
        return state.copyWith(
          chronicDiseases: updated,
          updateSuccess: 'Disease added',
        );
      },
    );
  }

  Future<void> updateDisease(int index, Map<String, String> disease) async {
    final id = state.chronicDiseases[index]['id'] ?? '';
    if (id.isEmpty) {
      _emitMissingItemIdError('disease');
      return;
    }

    await _performMedicalMutation<ChronicDiseaseModel>(
      operation: () => _medicalRepository.updateChronicDisease(
        _chronicDiseaseFromMap({...disease, 'id': id}),
      ),
      onSuccess: (item) {
        final updated = List<Map<String, String>>.from(state.chronicDiseases);
        updated[index] = _chronicDiseaseToMap(item);
        return state.copyWith(
          chronicDiseases: updated,
          updateSuccess: 'Disease updated',
        );
      },
    );
  }

  Future<void> deleteDisease(int index) async {
    final id = state.chronicDiseases[index]['id'] ?? '';
    if (id.isEmpty) {
      _emitMissingItemIdError('disease');
      return;
    }

    await _performDeleteMutation(
      operation: () => _medicalRepository.deleteChronicDisease(id),
      onSuccess: () {
        final updated = List<Map<String, String>>.from(state.chronicDiseases)
          ..removeAt(index);
        return state.copyWith(
          chronicDiseases: updated,
          updateSuccess: 'Disease removed',
        );
      },
    );
  }

  Future<void> addSurgery(Map<String, String> surgery) async {
    await _performMedicalMutation<PastSurgeryModel>(
      operation: () =>
          _medicalRepository.addPastSurgery(_pastSurgeryFromMap(surgery)),
      onSuccess: (item) {
        final updated = List<Map<String, String>>.from(state.pastSurgeries)
          ..add(_pastSurgeryToMap(item));
        return state.copyWith(
          pastSurgeries: updated,
          updateSuccess: 'Surgery added',
        );
      },
    );
  }

  Future<void> updateSurgery(int index, Map<String, String> surgery) async {
    final id = state.pastSurgeries[index]['id'] ?? '';
    if (id.isEmpty) {
      _emitMissingItemIdError('surgery');
      return;
    }

    await _performMedicalMutation<PastSurgeryModel>(
      operation: () => _medicalRepository.updatePastSurgery(
        _pastSurgeryFromMap({...surgery, 'id': id}),
      ),
      onSuccess: (item) {
        final updated = List<Map<String, String>>.from(state.pastSurgeries);
        updated[index] = _pastSurgeryToMap(item);
        return state.copyWith(
          pastSurgeries: updated,
          updateSuccess: 'Surgery updated',
        );
      },
    );
  }

  Future<void> deleteSurgery(int index) async {
    final id = state.pastSurgeries[index]['id'] ?? '';
    if (id.isEmpty) {
      _emitMissingItemIdError('surgery');
      return;
    }

    await _performDeleteMutation(
      operation: () => _medicalRepository.deletePastSurgery(id),
      onSuccess: () {
        final updated = List<Map<String, String>>.from(state.pastSurgeries)
          ..removeAt(index);
        return state.copyWith(
          pastSurgeries: updated,
          updateSuccess: 'Surgery removed',
        );
      },
    );
  }

  Future<void> addContact(Map<String, String> contact) async {
    await _performMedicalMutation<EmergencyContactModel>(
      operation: () => _medicalRepository.addEmergencyContact(
        _emergencyContactFromMap(contact),
      ),
      onSuccess: (item) {
        final updated = List<Map<String, String>>.from(state.emergencyContacts)
          ..add(_emergencyContactToMap(item));
        return state.copyWith(
          emergencyContacts: updated,
          updateSuccess: 'Contact added',
        );
      },
    );
  }

  Future<void> updateContact(int index, Map<String, String> contact) async {
    final id = state.emergencyContacts[index]['id'] ?? '';
    if (id.isEmpty) {
      _emitMissingItemIdError('contact');
      return;
    }

    await _performMedicalMutation<EmergencyContactModel>(
      operation: () => _medicalRepository.updateEmergencyContact(
        _emergencyContactFromMap({...contact, 'id': id}),
      ),
      onSuccess: (item) {
        final updated = List<Map<String, String>>.from(state.emergencyContacts);
        updated[index] = _emergencyContactToMap(item);
        return state.copyWith(
          emergencyContacts: updated,
          updateSuccess: 'Contact updated',
        );
      },
    );
  }

  Future<void> deleteContact(int index) async {
    final id = state.emergencyContacts[index]['id'] ?? '';
    if (id.isEmpty) {
      _emitMissingItemIdError('contact');
      return;
    }

    await _performDeleteMutation(
      operation: () => _medicalRepository.deleteEmergencyContact(id),
      onSuccess: () {
        final updated = List<Map<String, String>>.from(state.emergencyContacts)
          ..removeAt(index);
        return state.copyWith(
          emergencyContacts: updated,
          updateSuccess: 'Contact removed',
        );
      },
    );
  }

  void navigateToEditProfile() {
    if (_context == null) {
      return;
    }
    Navigator.of(_context!).pushNamed(AppRoutes.editProfile, arguments: this);
  }

  void navigateToNotifications() {}

  void navigateToLanguage() {
    if (_context == null) {
      return;
    }
    Navigator.of(_context!).pushNamed(AppRoutes.language);
  }

  void navigateToPrivacy() {}

  void navigateToHelp() {}

  void callEmergencyContact(String phone) {
    if (_context == null) {
      return;
    }
    ScaffoldMessenger.of(
      _context!,
    ).showSnackBar(SnackBar(content: Text('Calling $phone...')));
  }

  void _updateLanguage() {
    emit(state.copyWith(currentLanguage: _localeCubit.currentLanguageName));
  }

  void _seedUserState() {
    final authUser = switch (_authCubit.state) {
      AuthAuthenticated(:final user) => user,
      _ when _authCubit.currentUser != null => _authCubit.currentUser!,
      _ => null,
    };

    emit(
      state.copyWith(
        fullName: authUser?.username.trim().isNotEmpty == true
            ? authUser!.username.trim()
            : authUser?.name ?? '',
        email: authUser?.email ?? '',
        phone: authUser?.phone ?? '',
        profileImageUrl: state.profileImageUrl ?? authUser?.profileImage,
        currentLanguage: _localeCubit.currentLanguageName,
      ),
    );
  }

  ProfileState _applyProfile(
    Profile profile, {
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
    String? updateSuccess,
    bool clearLoadError = false,
    bool clearUpdateError = false,
  }) {
    return state.copyWith(
      bloodType: profile.bloodType,
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      pregnancyStatus: profile.pregnancyStatus,
      medicalNotes: profile.medicalNotes,
      profileImageUrl: (profile.profileImageUrl?.trim().isNotEmpty ?? false)
          ? profile.profileImageUrl
          : state.profileImageUrl,
      medications: medications,
      allergies: allergies,
      chronicDiseases: chronicDiseases,
      pastSurgeries: pastSurgeries,
      emergencyContacts: emergencyContacts,
      isLoading: isLoading,
      isRefreshing: isRefreshing,
      isUpdating: isUpdating,
      hasLoadedProfile: hasLoadedProfile,
      loadError: loadError,
      updateSuccess: updateSuccess,
      clearLoadError: clearLoadError,
      clearUpdateError: clearUpdateError,
    );
  }

  Future<void> _performMedicalMutation<T>({
    required Future<Either<Failure, T>> Function() operation,
    required ProfileState Function(T item) onSuccess,
  }) async {
    if (state.isUpdating) {
      return;
    }

    emit(
      state.copyWith(
        isUpdating: true,
        clearUpdateError: true,
        clearUpdateSuccess: true,
      ),
    );

    final result = await operation();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isUpdating: false,
            updateError: failure.message,
            clearUpdateSuccess: true,
          ),
        );
      },
      (item) {
        emit(
          onSuccess(item).copyWith(isUpdating: false, clearUpdateError: true),
        );
        _clearFeedback();
      },
    );
  }

  Future<void> _performDeleteMutation({
    required Future<Either<Failure, bool>> Function() operation,
    required ProfileState Function() onSuccess,
  }) async {
    if (state.isUpdating) {
      return;
    }

    emit(
      state.copyWith(
        isUpdating: true,
        clearUpdateError: true,
        clearUpdateSuccess: true,
      ),
    );

    final result = await operation();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isUpdating: false,
            updateError: failure.message,
            clearUpdateSuccess: true,
          ),
        );
      },
      (_) {
        emit(onSuccess().copyWith(isUpdating: false, clearUpdateError: true));
        _clearFeedback();
      },
    );
  }

  void _emitMissingItemIdError(String label) {
    emit(
      state.copyWith(
        updateError: 'Unable to update $label because its id is missing',
        clearUpdateSuccess: true,
      ),
    );
    _clearFeedback();
  }

  Map<String, String> _medicationToMap(MedicationModel item) {
    return {
      'id': item.id,
      'name': item.name,
      'dosage': item.dosage,
      'frequency': item.frequency,
    };
  }

  MedicationModel _medicationFromMap(Map<String, String> item) {
    return MedicationModel(
      id: item['id'] ?? '',
      name: item['name'] ?? '',
      dosage: item['dosage'] ?? '',
      frequency: item['frequency'] ?? '',
    );
  }

  Map<String, String> _allergyToMap(AllergyModel item) {
    return {
      'id': item.id,
      'name': item.name,
      'severity': item.severity,
      'notes': item.notes,
    };
  }

  AllergyModel _allergyFromMap(Map<String, String> item) {
    return AllergyModel(
      id: item['id'] ?? '',
      name: item['name'] ?? '',
      severity: item['severity'] ?? '',
      notes: item['notes'] ?? '',
    );
  }

  Map<String, String> _chronicDiseaseToMap(ChronicDiseaseModel item) {
    return {
      'id': item.id,
      'name': item.name,
      'severity': item.severity,
      'diagnosed_year': item.diagnosedYear,
    };
  }

  ChronicDiseaseModel _chronicDiseaseFromMap(Map<String, String> item) {
    return ChronicDiseaseModel(
      id: item['id'] ?? '',
      name: item['name'] ?? '',
      severity: item['severity'] ?? '',
      diagnosedYear: item['diagnosed_year'] ?? '',
    );
  }

  Map<String, String> _pastSurgeryToMap(PastSurgeryModel item) {
    return {
      'id': item.id,
      'name': item.name,
      'year': item.year,
      'notes': item.notes,
    };
  }

  PastSurgeryModel _pastSurgeryFromMap(Map<String, String> item) {
    return PastSurgeryModel(
      id: item['id'] ?? '',
      name: item['name'] ?? '',
      year: item['year'] ?? '',
      notes: item['notes'] ?? '',
    );
  }

  Map<String, String> _emergencyContactToMap(EmergencyContactModel item) {
    return {
      'id': item.id,
      'name': item.name,
      'phone': item.phone,
      'relation': item.relation,
    };
  }

  EmergencyContactModel _emergencyContactFromMap(Map<String, String> item) {
    return EmergencyContactModel(
      id: item['id'] ?? '',
      name: item['name'] ?? '',
      phone: item['phone'] ?? '',
      relation: item['relation'] ?? '',
    );
  }

  void _clearFeedback() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!isClosed) {
        emit(
          state.copyWith(
            clearUpdateSuccess: true,
            clearUpdateError: true,
            clearUploadImageSuccess: true,
            clearUploadImageError: true,
            clearDeleteImageSuccess: true,
            clearDeleteImageError: true,
          ),
        );
      }
    });
  }

  Future<String?> _validateProfileImage(File file) async {
    const maxFileSizeInBytes = 5 * 1024 * 1024;
    const allowedExtensions = {'jpg', 'jpeg', 'png', 'webp'};

    final extension = file.path.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      return 'Selected file is not a valid image';
    }

    final fileLength = await file.length();
    if (fileLength > maxFileSizeInBytes) {
      return 'Selected image is too large';
    }

    return null;
  }

  bool _hasProfileData(Profile profile) {
    return profile.bloodType.trim().isNotEmpty ||
        profile.weightKg > 0 ||
        profile.heightCm > 0 ||
        profile.medicalNotes.trim().isNotEmpty ||
        (profile.profileImageUrl?.trim().isNotEmpty ?? false);
  }

  @override
  Future<void> close() {
    _localeSubscription.cancel();
    return super.close();
  }
}
