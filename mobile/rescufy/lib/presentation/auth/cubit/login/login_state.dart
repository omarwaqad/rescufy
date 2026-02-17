// lib/presentation/features/auth/cubit/login/login_state.dart
import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/user.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final User user;

  const LoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoginAdminBlocked extends LoginState {
  final String message;

  const LoginAdminBlocked({required this.message});

  @override
  List<Object?> get props => [message];
}
