import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/services/location_service.dart';
import 'package:rescufy/domain/usecases/get_nearby_hospitals_usecase.dart';

import 'hospitals_state.dart';

class HospitalsCubit extends Cubit<HospitalsState> {
  HospitalsCubit(this._locationService, this._getNearbyHospitalsUseCase)
    : super(const HospitalsState.initial());

  final LocationService _locationService;
  final GetNearbyHospitalsUseCase _getNearbyHospitalsUseCase;

  Future<void> loadNearbyHospitals({double radiusKm = 10}) async {
    emit(
      state.copyWith(
        status: HospitalsStatus.loading,
        radiusKm: radiusKm,
        clearError: true,
      ),
    );

    final location = await _locationService.getCurrentLocation();
    if (location == null) {
      emit(
        state.copyWith(
          status: HospitalsStatus.error,
          errorMessage: 'location_unavailable',
        ),
      );
      return;
    }

    final result = await _getNearbyHospitalsUseCase(
      latitude: location.latitude,
      longitude: location.longitude,
      radiusKm: radiusKm,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HospitalsStatus.error,
          latitude: location.latitude,
          longitude: location.longitude,
          address: location.address,
          errorMessage: failure.message,
        ),
      ),
      (hospitals) => emit(
        state.copyWith(
          status: hospitals.isEmpty
              ? HospitalsStatus.empty
              : HospitalsStatus.success,
          hospitals: hospitals,
          latitude: location.latitude,
          longitude: location.longitude,
          address: location.address,
          clearError: true,
        ),
      ),
    );
  }
}
