import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rescufy/core/network/network_exceptions.dart';
import 'package:rescufy/data/datasources/local/medical_local_data_source.dart';
import 'package:rescufy/data/datasources/remote/medical_remote_data_source.dart';
import 'package:rescufy/data/models/medical_profile/allergy_model.dart';
import 'package:rescufy/data/models/medical_profile/chronic_disease_model.dart';
import 'package:rescufy/data/models/medical_profile/emergency_contact_model.dart';
import 'package:rescufy/data/models/medical_profile/medication_model.dart';
import 'package:rescufy/data/models/medical_profile/past_surgery_model.dart';
import 'package:rescufy/domain/core/failures.dart';

class MedicalRepository {
  MedicalRepository(this._remoteDataSource, this._localDataSource);

  final MedicalRemoteDataSource _remoteDataSource;
  final MedicalLocalDataSource _localDataSource;

  Future<Either<Failure, List<MedicationModel>>> getMedications() async {
    return _getRemoteThenCache(
      remoteFetch: _remoteDataSource.getMedications,
      localFetch: _localDataSource.getAllMedications,
      saveAll: _localDataSource.saveAllMedications,
    );
  }

  Future<Either<Failure, MedicationModel>> addMedication(
    MedicationModel medication,
  ) async {
    return _write(
      remoteCall: () => _remoteDataSource.addMedication(medication),
      updateLocal: _localDataSource.updateMedicationItem,
    );
  }

  Future<Either<Failure, MedicationModel>> updateMedication(
    MedicationModel medication,
  ) async {
    return _write(
      remoteCall: () => _remoteDataSource.updateMedication(medication),
      updateLocal: _localDataSource.updateMedicationItem,
    );
  }

  Future<Either<Failure, bool>> deleteMedication(String id) async {
    return _delete(
      remoteDelete: () => _remoteDataSource.deleteMedication(id),
      deleteLocal: () => _localDataSource.deleteMedicationItem(id),
    );
  }

  Future<Either<Failure, List<AllergyModel>>> getAllergies() async {
    return _getRemoteThenCache(
      remoteFetch: _remoteDataSource.getAllergies,
      localFetch: _localDataSource.getAllAllergies,
      saveAll: _localDataSource.saveAllAllergies,
    );
  }

  Future<Either<Failure, AllergyModel>> addAllergy(AllergyModel allergy) async {
    return _write(
      remoteCall: () => _remoteDataSource.addAllergy(allergy),
      updateLocal: _localDataSource.updateAllergyItem,
    );
  }

  Future<Either<Failure, AllergyModel>> updateAllergy(
    AllergyModel allergy,
  ) async {
    return _write(
      remoteCall: () => _remoteDataSource.updateAllergy(allergy),
      updateLocal: _localDataSource.updateAllergyItem,
    );
  }

  Future<Either<Failure, bool>> deleteAllergy(String id) async {
    return _delete(
      remoteDelete: () => _remoteDataSource.deleteAllergy(id),
      deleteLocal: () => _localDataSource.deleteAllergyItem(id),
    );
  }

  Future<Either<Failure, List<ChronicDiseaseModel>>>
  getChronicDiseases() async {
    return _getRemoteThenCache(
      remoteFetch: _remoteDataSource.getChronicDiseases,
      localFetch: _localDataSource.getAllChronicDiseases,
      saveAll: _localDataSource.saveAllChronicDiseases,
    );
  }

  Future<Either<Failure, ChronicDiseaseModel>> addChronicDisease(
    ChronicDiseaseModel disease,
  ) async {
    return _write(
      remoteCall: () => _remoteDataSource.addChronicDisease(disease),
      updateLocal: _localDataSource.updateChronicDiseaseItem,
    );
  }

  Future<Either<Failure, ChronicDiseaseModel>> updateChronicDisease(
    ChronicDiseaseModel disease,
  ) async {
    return _write(
      remoteCall: () => _remoteDataSource.updateChronicDisease(disease),
      updateLocal: _localDataSource.updateChronicDiseaseItem,
    );
  }

  Future<Either<Failure, bool>> deleteChronicDisease(String id) async {
    return _delete(
      remoteDelete: () => _remoteDataSource.deleteChronicDisease(id),
      deleteLocal: () => _localDataSource.deleteChronicDiseaseItem(id),
    );
  }

  Future<Either<Failure, List<EmergencyContactModel>>>
  getEmergencyContacts() async {
    return _getRemoteThenCache(
      remoteFetch: _remoteDataSource.getEmergencyContacts,
      localFetch: _localDataSource.getAllEmergencyContacts,
      saveAll: _localDataSource.saveAllEmergencyContacts,
    );
  }

  Future<Either<Failure, EmergencyContactModel>> addEmergencyContact(
    EmergencyContactModel contact,
  ) async {
    return _write(
      remoteCall: () => _remoteDataSource.addEmergencyContact(contact),
      updateLocal: _localDataSource.updateEmergencyContactItem,
    );
  }

  Future<Either<Failure, EmergencyContactModel>> updateEmergencyContact(
    EmergencyContactModel contact,
  ) async {
    return _write(
      remoteCall: () => _remoteDataSource.updateEmergencyContact(contact),
      updateLocal: _localDataSource.updateEmergencyContactItem,
    );
  }

  Future<Either<Failure, bool>> deleteEmergencyContact(String id) async {
    return _delete(
      remoteDelete: () => _remoteDataSource.deleteEmergencyContact(id),
      deleteLocal: () => _localDataSource.deleteEmergencyContactItem(id),
    );
  }

  Future<Either<Failure, List<PastSurgeryModel>>> getPastSurgeries() async {
    return _getRemoteThenCache(
      remoteFetch: _remoteDataSource.getPastSurgeries,
      localFetch: _localDataSource.getAllPastSurgeries,
      saveAll: _localDataSource.saveAllPastSurgeries,
    );
  }

  Future<Either<Failure, PastSurgeryModel>> addPastSurgery(
    PastSurgeryModel surgery,
  ) async {
    return _write(
      remoteCall: () => _remoteDataSource.addPastSurgery(surgery),
      updateLocal: _localDataSource.updatePastSurgeryItem,
    );
  }

  Future<Either<Failure, PastSurgeryModel>> updatePastSurgery(
    PastSurgeryModel surgery,
  ) async {
    return _write(
      remoteCall: () => _remoteDataSource.updatePastSurgery(surgery),
      updateLocal: _localDataSource.updatePastSurgeryItem,
    );
  }

  Future<Either<Failure, bool>> deletePastSurgery(String id) async {
    return _delete(
      remoteDelete: () => _remoteDataSource.deletePastSurgery(id),
      deleteLocal: () => _localDataSource.deletePastSurgeryItem(id),
    );
  }

  Future<Either<Failure, List<T>>> _getRemoteThenCache<T>({
    required Future<List<T>> Function() remoteFetch,
    required List<T> Function() localFetch,
    required Future<void> Function(List<T> items) saveAll,
  }) async {
    final cachedItems = localFetch();

    try {
      final remoteItems = await remoteFetch();
      await saveAll(remoteItems);
      return Right(remoteItems);
    } on DioException catch (e) {
      if (cachedItems.isNotEmpty) {
        return Right(cachedItems);
      }
      return Left(NetworkExceptions.handleDioException(e));
    } catch (e) {
      if (cachedItems.isNotEmpty) {
        return Right(cachedItems);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, T>> _write<T>({
    required Future<T> Function() remoteCall,
    required Future<void> Function(T item) updateLocal,
  }) async {
    try {
      final item = await remoteCall();
      await updateLocal(item);
      return Right(item);
    } on DioException catch (e) {
      return Left(NetworkExceptions.handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> _delete({
    required Future<void> Function() remoteDelete,
    required Future<void> Function() deleteLocal,
  }) async {
    try {
      await remoteDelete();
      await deleteLocal();
      return const Right(true);
    } on DioException catch (e) {
      return Left(NetworkExceptions.handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
