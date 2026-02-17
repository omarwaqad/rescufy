// lib/presentation/features/auth/cubit/register/register_cubit.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/navigation/app_routes.dart';
import '../../../../domain/usecases/auth/register_usecase.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  final _obscurePasswordController = StreamController<bool>.broadcast();
  final _obscureConfirmPasswordController = StreamController<bool>.broadcast();
  final _selectedGenderController = StreamController<String>.broadcast();
  final _isLoadingController = StreamController<bool>.broadcast();

  Stream<bool> get obscurePasswordStream => _obscurePasswordController.stream;
  Stream<bool> get obscureConfirmPasswordStream =>
      _obscureConfirmPasswordController.stream;
  Stream<String> get selectedGenderStream => _selectedGenderController.stream;
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  BuildContext? _context;
  GlobalKey<FormState>? _formKey;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedGender = '';

  RegisterCubit(this.registerUseCase) : super(const RegisterState());

  void initialize({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
  }) {
    _context = context;
    _formKey = formKey;
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    _obscurePasswordController.add(_obscurePassword);
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    _obscureConfirmPasswordController.add(_obscureConfirmPassword);
  }

  void setGender(String gender) {
    _selectedGender = gender;
    _selectedGenderController.add(_selectedGender);
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required String nationalId,
    required String phoneNumber,
    required String age,
    required String gender,
  }) async {
    if (_context == null || _formKey == null) return;
    if (!_formKey!.currentState!.validate()) return;

    _isLoadingController.add(true);

    // Parse age
    int parsedAge = 0;
    try {
      parsedAge = int.parse(age);
    } catch (e) {
      _isLoadingController.add(false);
      _showSnackbar(message: 'Invalid age format', isError: true);
      return;
    }

    final result = await registerUseCase(
      RegisterParams(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        nationalId: nationalId,
        phoneNumber: phoneNumber,
        age: parsedAge,
        gender: _selectedGender,
      ),
    );

    result.fold(
      (failure) {
        _isLoadingController.add(false);
        _showSnackbar(message: failure.message, isError: true);
      },
      (user) {
        _isLoadingController.add(false);
        _showSnackbar(message: 'Account created successfully!', isError: false);
        Navigator.of(_context!).pushReplacementNamed(AppRoutes.userHome);
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
    _obscurePasswordController.close();
    _obscureConfirmPasswordController.close();
    _selectedGenderController.close();
    _isLoadingController.close();
    return super.close();
  }
}
