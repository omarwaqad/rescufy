import 'package:hive/hive.dart';
import 'package:rescufy/data/models/medical_profile/allergy_model.dart';
import 'package:rescufy/data/models/medical_profile/chronic_disease_model.dart';
import 'package:rescufy/data/models/medical_profile/emergency_contact_model.dart';
import 'package:rescufy/data/models/medical_profile/medication_model.dart';
import 'package:rescufy/data/models/medical_profile/past_surgery_model.dart';

class MedicalLocalDataSource {
  MedicalLocalDataSource({
    required Box<MedicationModel> medicationsBox,
    required Box<AllergyModel> allergiesBox,
    required Box<ChronicDiseaseModel> chronicDiseasesBox,
    required Box<EmergencyContactModel> emergencyContactsBox,
    required Box<PastSurgeryModel> pastSurgeriesBox,
  }) : _medicationsBox = medicationsBox,
       _allergiesBox = allergiesBox,
       _chronicDiseasesBox = chronicDiseasesBox,
       _emergencyContactsBox = emergencyContactsBox,
       _pastSurgeriesBox = pastSurgeriesBox;

  final Box<MedicationModel> _medicationsBox;
  final Box<AllergyModel> _allergiesBox;
  final Box<ChronicDiseaseModel> _chronicDiseasesBox;
  final Box<EmergencyContactModel> _emergencyContactsBox;
  final Box<PastSurgeryModel> _pastSurgeriesBox;

  List<MedicationModel> getAllMedications() => _medicationsBox.values.toList();

  Future<void> saveAllMedications(List<MedicationModel> items) async {
    await _replaceAll(_medicationsBox, items, (item) => item.cacheKey);
  }

  Future<void> updateMedicationItem(MedicationModel item) async {
    await _medicationsBox.put(item.cacheKey, item);
  }

  Future<void> deleteMedicationItem(String id) async {
    await _medicationsBox.delete(id);
  }

  List<AllergyModel> getAllAllergies() => _allergiesBox.values.toList();

  Future<void> saveAllAllergies(List<AllergyModel> items) async {
    await _replaceAll(_allergiesBox, items, (item) => item.cacheKey);
  }

  Future<void> updateAllergyItem(AllergyModel item) async {
    await _allergiesBox.put(item.cacheKey, item);
  }

  Future<void> deleteAllergyItem(String id) async {
    await _allergiesBox.delete(id);
  }

  List<ChronicDiseaseModel> getAllChronicDiseases() =>
      _chronicDiseasesBox.values.toList();

  Future<void> saveAllChronicDiseases(List<ChronicDiseaseModel> items) async {
    await _replaceAll(_chronicDiseasesBox, items, (item) => item.cacheKey);
  }

  Future<void> updateChronicDiseaseItem(ChronicDiseaseModel item) async {
    await _chronicDiseasesBox.put(item.cacheKey, item);
  }

  Future<void> deleteChronicDiseaseItem(String id) async {
    await _chronicDiseasesBox.delete(id);
  }

  List<EmergencyContactModel> getAllEmergencyContacts() =>
      _emergencyContactsBox.values.toList();

  Future<void> saveAllEmergencyContacts(
    List<EmergencyContactModel> items,
  ) async {
    await _replaceAll(_emergencyContactsBox, items, (item) => item.cacheKey);
  }

  Future<void> updateEmergencyContactItem(EmergencyContactModel item) async {
    await _emergencyContactsBox.put(item.cacheKey, item);
  }

  Future<void> deleteEmergencyContactItem(String id) async {
    await _emergencyContactsBox.delete(id);
  }

  List<PastSurgeryModel> getAllPastSurgeries() =>
      _pastSurgeriesBox.values.toList();

  Future<void> saveAllPastSurgeries(List<PastSurgeryModel> items) async {
    await _replaceAll(_pastSurgeriesBox, items, (item) => item.cacheKey);
  }

  Future<void> updatePastSurgeryItem(PastSurgeryModel item) async {
    await _pastSurgeriesBox.put(item.cacheKey, item);
  }

  Future<void> deletePastSurgeryItem(String id) async {
    await _pastSurgeriesBox.delete(id);
  }

  Future<void> _replaceAll<T>(
    Box<T> box,
    List<T> items,
    String Function(T item) keySelector,
  ) async {
    await box.clear();
    final entries = <dynamic, T>{};
    for (final item in items) {
      entries[keySelector(item)] = item;
    }
    if (entries.isNotEmpty) {
      await box.putAll(entries);
    }
  }
}
