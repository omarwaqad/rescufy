import 'package:rescufy/core/network/dio_client.dart';
import 'package:rescufy/core/network/endpoints/profile_endpoints.dart';
import 'package:rescufy/data/models/medical_profile/allergy_model.dart';
import 'package:rescufy/data/models/medical_profile/chronic_disease_model.dart';
import 'package:rescufy/data/models/medical_profile/emergency_contact_model.dart';
import 'package:rescufy/data/models/medical_profile/medication_model.dart';
import 'package:rescufy/data/models/medical_profile/past_surgery_model.dart';

class MedicalRemoteDataSource {
  MedicalRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Future<List<MedicationModel>> getMedications() async {
    final response = await _dioClient.get(ProfileEndpoints.getMedications);
    return _extractList(response.data).map(MedicationModel.fromJson).toList();
  }

  Future<MedicationModel> addMedication(MedicationModel medication) async {
    final payload = medication.toJson()..remove('id');
    final response = await _dioClient.post(
      ProfileEndpoints.editMedications,
      data: payload,
    );
    return MedicationModel.fromJson(_extractItem(response.data, payload));
  }

  Future<MedicationModel> updateMedication(MedicationModel medication) async {
    final payload = medication.toJson();
    final response = await _dioClient.put(
      ProfileEndpoints.editMedications,
      data: payload,
    );
    return MedicationModel.fromJson(_extractItem(response.data, payload));
  }

  Future<void> deleteMedication(String id) async {
    await _dioClient.delete(
      ProfileEndpoints.deleteMedications.replaceFirst('{id}', id),
    );
  }

  Future<List<AllergyModel>> getAllergies() async {
    final response = await _dioClient.get(ProfileEndpoints.getAllergies);
    return _extractList(response.data).map(AllergyModel.fromJson).toList();
  }

  Future<AllergyModel> addAllergy(AllergyModel allergy) async {
    final payload = allergy.toJson()..remove('id');
    final response = await _dioClient.post(
      ProfileEndpoints.editAllergies,
      data: payload,
    );
    return AllergyModel.fromJson(_extractItem(response.data, payload));
  }

  Future<AllergyModel> updateAllergy(AllergyModel allergy) async {
    final payload = allergy.toJson();
    final response = await _dioClient.put(
      ProfileEndpoints.editAllergies,
      data: payload,
    );
    return AllergyModel.fromJson(_extractItem(response.data, payload));
  }

  Future<void> deleteAllergy(String id) async {
    await _dioClient.delete(
      ProfileEndpoints.deleteAllergies.replaceFirst('{id}', id),
    );
  }

  Future<List<ChronicDiseaseModel>> getChronicDiseases() async {
    final response = await _dioClient.get(ProfileEndpoints.getChronicDiseases);
    return _extractList(
      response.data,
    ).map(ChronicDiseaseModel.fromJson).toList();
  }

  Future<ChronicDiseaseModel> addChronicDisease(
    ChronicDiseaseModel disease,
  ) async {
    final payload = disease.toJson()..remove('id');
    final response = await _dioClient.post(
      ProfileEndpoints.editChronicDiseases,
      data: payload,
    );
    return ChronicDiseaseModel.fromJson(_extractItem(response.data, payload));
  }

  Future<ChronicDiseaseModel> updateChronicDisease(
    ChronicDiseaseModel disease,
  ) async {
    final payload = disease.toJson();
    final response = await _dioClient.put(
      ProfileEndpoints.editChronicDiseases,
      data: payload,
    );
    return ChronicDiseaseModel.fromJson(_extractItem(response.data, payload));
  }

  Future<void> deleteChronicDisease(String id) async {
    await _dioClient.delete(
      ProfileEndpoints.deleteChronicDiseases.replaceFirst('{id}', id),
    );
  }

  Future<List<EmergencyContactModel>> getEmergencyContacts() async {
    final response = await _dioClient.get(
      ProfileEndpoints.getEmergencyContacts,
    );
    return _extractList(
      response.data,
    ).map(EmergencyContactModel.fromJson).toList();
  }

  Future<EmergencyContactModel> addEmergencyContact(
    EmergencyContactModel contact,
  ) async {
    final payload = contact.toJson()..remove('id');
    final response = await _dioClient.post(
      ProfileEndpoints.editEmergencyContacts,
      data: payload,
    );
    return EmergencyContactModel.fromJson(_extractItem(response.data, payload));
  }

  Future<EmergencyContactModel> updateEmergencyContact(
    EmergencyContactModel contact,
  ) async {
    final payload = contact.toJson();
    final response = await _dioClient.put(
      ProfileEndpoints.editEmergencyContacts,
      data: payload,
    );
    return EmergencyContactModel.fromJson(_extractItem(response.data, payload));
  }

  Future<void> deleteEmergencyContact(String id) async {
    await _dioClient.delete(
      ProfileEndpoints.deleteEmergencyContacts.replaceFirst('{id}', id),
    );
  }

  Future<List<PastSurgeryModel>> getPastSurgeries() async {
    final response = await _dioClient.get(ProfileEndpoints.getPastSurgeries);
    return _extractList(response.data).map(PastSurgeryModel.fromJson).toList();
  }

  Future<PastSurgeryModel> addPastSurgery(PastSurgeryModel surgery) async {
    final payload = surgery.toJson()..remove('id');
    final response = await _dioClient.post(
      ProfileEndpoints.editPastSurgeries,
      data: payload,
    );
    return PastSurgeryModel.fromJson(_extractItem(response.data, payload));
  }

  Future<PastSurgeryModel> updatePastSurgery(PastSurgeryModel surgery) async {
    final payload = surgery.toJson();
    final response = await _dioClient.put(
      ProfileEndpoints.editPastSurgeries,
      data: payload,
    );
    return PastSurgeryModel.fromJson(_extractItem(response.data, payload));
  }

  Future<void> deletePastSurgery(String id) async {
    await _dioClient.delete(
      ProfileEndpoints.deletePastSurgeries.replaceFirst('{id}', id),
    );
  }

  List<Map<String, dynamic>> _extractList(dynamic data) {
    if (data is List) {
      return data.whereType<Map>().map(_castMap).toList();
    }

    if (data is Map<String, dynamic>) {
      for (final key in const ['data', 'items', 'result', 'results']) {
        final nested = data[key];
        if (nested is List) {
          return nested.whereType<Map>().map(_castMap).toList();
        }
      }
    }

    return const [];
  }

  Map<String, dynamic> _extractItem(
    dynamic data,
    Map<String, dynamic> fallback,
  ) {
    if (data is Map<String, dynamic>) {
      if (_looksLikeEntity(data)) {
        return data;
      }

      for (final key in const ['data', 'item', 'result']) {
        final nested = data[key];
        if (nested is Map<String, dynamic>) {
          return nested;
        }
      }
    }

    return fallback;
  }

  bool _looksLikeEntity(Map<String, dynamic> data) {
    return data.keys.any(
      (key) => const {
        'id',
        'Id',
        'name',
        'Name',
        'dosage',
        'severity',
        'phone',
        'year',
      }.contains(key),
    );
  }

  Map<String, dynamic> _castMap(Map<dynamic, dynamic> map) {
    return map.map((key, value) => MapEntry(key.toString(), value));
  }
}
