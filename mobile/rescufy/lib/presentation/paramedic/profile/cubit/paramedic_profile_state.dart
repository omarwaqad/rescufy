import 'package:equatable/equatable.dart';
import 'package:rescufy/domain/entities/paramedic_profile.dart';

enum ParamedicProfileStatus { initial, loading, loaded, error }

class ParamedicProfileState extends Equatable {
  const ParamedicProfileState({
    required this.status,
    this.profile,
    this.roleLabel = 'Paramedic',
    this.errorMessage,
    this.isRefreshing = false,
  });

  const ParamedicProfileState.initial()
    : this(status: ParamedicProfileStatus.initial);

  final ParamedicProfileStatus status;
  final ParamedicProfile? profile;
  final String roleLabel;
  final String? errorMessage;
  final bool isRefreshing;

  ParamedicProfileState copyWith({
    ParamedicProfileStatus? status,
    ParamedicProfile? profile,
    String? roleLabel,
    String? errorMessage,
    bool clearError = false,
    bool? isRefreshing,
  }) {
    return ParamedicProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      roleLabel: roleLabel ?? this.roleLabel,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    roleLabel,
    errorMessage,
    isRefreshing,
  ];
}
