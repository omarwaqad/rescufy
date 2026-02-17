import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/services/location_service.dart';
import 'package:rescufy/core/navigation/app_routes.dart';
import '../cubit/emergency_request_cubit.dart';
import '../cubit/emergency_request_state.dart';
import 'emergency_form_screen.dart';

/// This wrapper handles ALL Bloc logic
/// The actual screen (EmergencyFormView) knows NOTHING about Bloc
class EmergencyFormBuilder extends StatelessWidget {
  final bool isSelfCase;

  const EmergencyFormBuilder({super.key, required this.isSelfCase});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmergencyRequestCubit, EmergencyRequestState>(
      listener: (context, state) {
        if (state is EmergencyRequestSuccess) {
          _showSuccessDialog(context, state.ambulanceId, state.eta);
        } else if (state is EmergencyRequestError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final locationState = _extractLocationState(state);
        final isSubmitting = state is EmergencyRequestLoading;

        return EmergencyFormScreen(
          isSelfCase: isSelfCase,
          isLocationLoading: locationState.isLoading,
          hasLocationError: locationState.hasError,
          locationErrorMessage: locationState.errorMessage,
          address: locationState.address,
          latitude: locationState.latitude,
          longitude: locationState.longitude,
          isSubmitting: isSubmitting,
          onRefreshLocation: () {
            context.read<EmergencyRequestCubit>().detectLocation();
          },
          onSubmit: (description, peopleCount) {
            context.read<EmergencyRequestCubit>().submitEmergencyRequest(
              description: description,
              isSelfCase: isSelfCase,
              peopleCount: peopleCount,
            );
          },
        );
      },
    );
  }

  _LocationState _extractLocationState(EmergencyRequestState state) {
    if (state is LocationDetecting) {
      return _LocationState(isLoading: true);
    } else if (state is LocationDetected) {
      return _LocationState(
        address: state.address,
        latitude: state.latitude,
        longitude: state.longitude,
      );
    } else if (state is LocationError) {
      return _LocationState(hasError: true, errorMessage: state.message);
    }
    return _LocationState(isLoading: true);
  }

  void _showSuccessDialog(
    BuildContext context,
    String ambulanceId,
    String eta,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Request Submitted!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            Text('Ambulance: $ambulanceId'),
            Text('ETA: $eta'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Go Home'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.userHistory);
            },
            child: const Text('Track'),
          ),
        ],
      ),
    );
  }
}

class _LocationState {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final String? address;
  final double? latitude;
  final double? longitude;

  _LocationState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.address,
    this.latitude,
    this.longitude,
  });
}
