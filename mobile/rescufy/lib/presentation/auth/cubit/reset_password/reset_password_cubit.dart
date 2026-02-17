// lib/presentation/features/auth/cubit/reset_password/reset_password_cubit.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/navigation/app_routes.dart';
import '../../../../domain/usecases/auth/reset_password_usecase.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase resetPasswordUseCase;

  final _obscurePasswordController = StreamController<bool>.broadcast();
  final _obscureConfirmPasswordController = StreamController<bool>.broadcast();
  final _isLoadingController = StreamController<bool>.broadcast();

  Stream<bool> get obscurePasswordStream => _obscurePasswordController.stream;
  Stream<bool> get obscureConfirmPasswordStream =>
      _obscureConfirmPasswordController.stream;
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  BuildContext? _context;
  GlobalKey<FormState>? _formKey;
  String _email = '';
  String _otp = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  ResetPasswordCubit(this.resetPasswordUseCase)
    : super(const ResetPasswordState());

  void initialize({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String email,
    required String otp,
  }) {
    _context = context;
    _formKey = formKey;
    _email = email;
    _otp = otp;
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    _obscurePasswordController.add(_obscurePassword);
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    _obscureConfirmPasswordController.add(_obscureConfirmPassword);
  }

  Future<void> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (_context == null || _formKey == null) return;
    if (!_formKey!.currentState!.validate()) return;

    _isLoadingController.add(true);

    final result = await resetPasswordUseCase(
      ResetPasswordParams(
        email: _email,
        otp: _otp,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );

    result.fold(
      (failure) {
        _isLoadingController.add(false);
        _showSnackbar(message: failure.message, isError: true);
      },
      (_) {
        _isLoadingController.add(false);
        _showSnackbar(message: 'Password reset successful!', isError: false);
        Navigator.of(
          _context!,
        ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
      },
    );
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
    _obscurePasswordController.close();
    _obscureConfirmPasswordController.close();
    _isLoadingController.close();
    return super.close();
  }
}
