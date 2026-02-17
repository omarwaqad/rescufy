// lib/presentation/features/auth/cubit/login/login_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/core/failures.dart';
import '../../../../../domain/usecases/auth/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  // Stream controllers for UI reactivity (keeping your pattern)
  final _obscurePasswordController = StreamController<bool>.broadcast();
  final _rememberMeController = StreamController<bool>.broadcast();

  // Expose streams
  Stream<bool> get obscurePasswordStream => _obscurePasswordController.stream;
  Stream<bool> get rememberMeStream => _rememberMeController.stream;

  // Internal state
  bool _obscurePassword = true;
  bool _rememberMe = false;

  LoginCubit(this.loginUseCase) : super(const LoginInitial());

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    _obscurePasswordController.add(_obscurePassword);
  }

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    _rememberMeController.add(_rememberMe);
  }

  Future<void> login(String email, String password) async {
    emit(const LoginLoading());

    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (failure) {
        // Emit different states based on failure type
        if (failure is AdminLoginFailure) {
          emit(LoginAdminBlocked(message: failure.message));
        } else {
          emit(LoginError(message: failure.message));
        }
      },
      (user) {
        emit(LoginSuccess(user: user));
      },
    );
  }

  @override
  Future<void> close() {
    _obscurePasswordController.close();
    _rememberMeController.close();
    return super.close();
  }
}
