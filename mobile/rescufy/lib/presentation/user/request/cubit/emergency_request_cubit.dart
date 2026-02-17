import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/services/location_service.dart';
import 'package:rescufy/domain/repositories/emergency_repository.dart';
import 'emergency_request_state.dart';

class EmergencyRequestCubit extends Cubit<EmergencyRequestState> {
  final LocationService _locationService;
  final EmergencyRepository _emergencyRepository;

  double? _latitude;
  double? _longitude;
  String? _address;

  EmergencyRequestCubit(this._locationService, this._emergencyRepository)
    : super(const EmergencyRequestInitial());

  Future<void> detectLocation() async {
    emit(const LocationDetecting());

    try {
      final result = await _locationService.getCurrentLocation();

      if (result != null) {
        _latitude = result.latitude;
        _longitude = result.longitude;
        _address = result.address;

        emit(
          LocationDetected(
            latitude: result.latitude,
            longitude: result.longitude,
            address: result.address,
          ),
        );
      } else {
        emit(
          const LocationError(
            message: 'Unable to get location. Please enable location services.',
          ),
        );
      }
    } catch (e) {
      emit(LocationError(message: 'Error: ${e.toString()}'));
    }
  }

  Future<void> submitEmergencyRequest({
    required String description,
    required bool isSelfCase,
    String? peopleCount,
  }) async {
    if (_latitude == null || _longitude == null || _address == null) {
      emit(const EmergencyRequestError(message: 'Location not available.'));
      return;
    }

    emit(const EmergencyRequestLoading());

    final result = await _emergencyRepository.createEmergencyRequest(
      description: description,
      isSelfCase: isSelfCase,
      latitude: _latitude!,
      longitude: _longitude!,
      address: _address!,
      peopleCount: peopleCount,
    );

    result.fold(
      (failure) => emit(EmergencyRequestError(message: failure.message)),
      (response) => emit(
        EmergencyRequestSuccess(
          ambulanceId: response['ambulance_id'] ?? '#AMB-001',
          eta: response['eta'] ?? '12-15 minutes',
        ),
      ),
    );
  }
}
