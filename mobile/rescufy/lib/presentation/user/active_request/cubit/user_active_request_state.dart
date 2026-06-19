import 'package:equatable/equatable.dart';
import 'package:rescufy/domain/entities/user_active_request.dart';

enum UserActiveRequestStatus { initial, loading, success, error }

class UserActiveRequestState extends Equatable {
  const UserActiveRequestState({
    this.status = UserActiveRequestStatus.initial,
    this.request,
    this.errorMessage,
  });

  final UserActiveRequestStatus status;
  final UserActiveRequest? request;
  final String? errorMessage;

  bool get isLoading => status == UserActiveRequestStatus.loading;
  bool get isSuccess => status == UserActiveRequestStatus.success;
  bool get isError => status == UserActiveRequestStatus.error;
  bool get hasRequest => request != null;

  UserActiveRequestState copyWith({
    UserActiveRequestStatus? status,
    UserActiveRequest? request,
    String? errorMessage,
    bool clearError = false,
    bool clearRequest = false,
  }) {
    return UserActiveRequestState(
      status: status ?? this.status,
      request: clearRequest ? null : request ?? this.request,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, request, errorMessage];
}
