// lib/presentation/features/auth/cubit/verify_reset_otp/verify_reset_otp_cubit.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/navigation/app_routes.dart';
import '../../../../domain/usecases/auth/verify_reset_otp_usecase.dart';
import 'verify_reset_otp_state.dart';

class VerifyResetOtpCubit extends Cubit<VerifyResetOtpState> {
  final VerifyResetOtpUseCase verifyOtpUseCase;

  final _isLoadingController = StreamController<bool>.broadcast();
  final _otpController = StreamController<String>.broadcast();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;
  Stream<String> get otpStream => _otpController.stream;

  BuildContext? _context;

  VerifyResetOtpCubit(this.verifyOtpUseCase)
    : super(const VerifyResetOtpState());

  void initialize(BuildContext context) {
    _context = context;
  }

  void updateOtp(String otp) {
    _otpController.add(otp);
  }

  Future<void> verifyResetOtp(String email, String otp) async {
    if (_context == null) return;

    _isLoadingController.add(true);

    final result = await verifyOtpUseCase(
      VerifyResetOtpParams(email: email, otp: otp),
    );

    result.fold(
      (failure) {
        _isLoadingController.add(false);
        _showSnackbar(message: failure.message, isError: true);
      },
      (_) {
        _isLoadingController.add(false);
        Navigator.of(_context!).pushNamed(
          AppRoutes.resetPassword,
          arguments: {'email': email, 'otp': otp},
        );
      },
    );
  }

  void navigateBack() {
    if (_context == null) return;
    Navigator.of(_context!).pop();
  }

  void _showSnackbar({required String message, bool isError = false}) {
    if (_context == null) return;
    final colorScheme = Theme.of(_context!).colorScheme;

    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
      ),
    );
  }

  @override
  Future<void> close() {
    _isLoadingController.close();
    _otpController.close();
    return super.close();
  }
}
