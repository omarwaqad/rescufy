import 'package:equatable/equatable.dart';

enum FeedbackType { driver, paramedic, hospital }

enum FeedbackStatus { initial, loading, success, error }

class FeedbackState extends Equatable {
  const FeedbackState({
    this.status = FeedbackStatus.initial,
    this.submittedTypes = const {},
    this.errorMessage,
  });

  final FeedbackStatus status;
  final Set<FeedbackType> submittedTypes;
  final String? errorMessage;

  bool get isLoading => status == FeedbackStatus.loading;
  bool get isSuccess => status == FeedbackStatus.success;
  bool get isError => status == FeedbackStatus.error;

  bool isSubmitted(FeedbackType type) => submittedTypes.contains(type);

  FeedbackState copyWith({
    FeedbackStatus? status,
    Set<FeedbackType>? submittedTypes,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FeedbackState(
      status: status ?? this.status,
      submittedTypes: submittedTypes ?? this.submittedTypes,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, submittedTypes, errorMessage];
}
