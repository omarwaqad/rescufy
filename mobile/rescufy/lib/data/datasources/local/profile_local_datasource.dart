import 'package:hive/hive.dart';
import 'package:rescufy/data/models/medical_profile/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveProfile(ProfileModel profile);
  ProfileModel? getProfile();
  Future<void> saveProfileImageUrl(String? imageUrl);
  Future<void> clearProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  ProfileLocalDataSourceImpl(this._profileBox);

  final Box<ProfileModel> _profileBox;

  static const String profileKey = 'profile';

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    await _profileBox.put(profileKey, profile);
  }

  @override
  ProfileModel? getProfile() {
    return _profileBox.get(profileKey);
  }

  @override
  Future<void> saveProfileImageUrl(String? imageUrl) async {
    final currentProfile = getProfile();
    final updatedProfile =
        (currentProfile ??
                const ProfileModel(
                  bloodTypeValue: '',
                  weightKgValue: 0,
                  heightCmValue: 0,
                  pregnancyStatusValue: false,
                  medicalNotesValue: '',
                ))
            .copyWith(profileImageUrlValue: imageUrl);

    await saveProfile(updatedProfile);
  }

  @override
  Future<void> clearProfile() async {
    await _profileBox.delete(profileKey);
  }
}
