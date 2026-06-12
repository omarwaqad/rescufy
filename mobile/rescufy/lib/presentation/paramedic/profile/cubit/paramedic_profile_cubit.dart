import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/domain/entities/user_role.dart';
import 'package:rescufy/domain/repositories/paramedic_profile_repository.dart';
import 'package:rescufy/presentation/auth/cubit/auth/auth_cubit.dart';
import 'package:rescufy/presentation/paramedic/profile/cubit/paramedic_profile_state.dart';

class ParamedicProfileCubit extends Cubit<ParamedicProfileState> {
  ParamedicProfileCubit(this._repository, this._authCubit)
    : super(const ParamedicProfileState.initial());

  final ParamedicProfileRepository _repository;
  final AuthCubit _authCubit;

  Future<void> loadProfile({bool refresh = false}) async {
    if (state.status == ParamedicProfileStatus.loading && !refresh) {
      return;
    }

    if (refresh) {
      emit(state.copyWith(isRefreshing: true, clearError: true));
    } else {
      emit(
        state.copyWith(
          status: ParamedicProfileStatus.loading,
          clearError: true,
        ),
      );
    }

    final result = await _repository.getProfile();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: state.profile == null
              ? ParamedicProfileStatus.error
              : ParamedicProfileStatus.loaded,
          errorMessage: failure.message,
          isRefreshing: false,
        ),
      ),
      (profile) => emit(
        state.copyWith(
          status: ParamedicProfileStatus.loaded,
          profile: profile,
          roleLabel: _resolveRoleLabel(),
          isRefreshing: false,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> refresh() => loadProfile(refresh: true);

  String _resolveRoleLabel() {
    final role = _authCubit.currentUser?.role;

    return switch (role) {
      UserRole.ambulanceDriver => 'Ambulance Driver',
      UserRole.paramedic => 'Paramedic',
      _ => 'Paramedic',
    };
  }
}
