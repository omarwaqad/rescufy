import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/domain/repositories/feedback_repository.dart';
import 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit({
    required FeedbackRepository feedbackRepository,
  }) : _feedbackRepository = feedbackRepository,
       super(const FeedbackState());

  final FeedbackRepository _feedbackRepository;

  Future<void> submitDriverFeedback({
    required String driverId,
    required int requestId,
    required int rate,
    String? comment,
  }) async {
    if (state.isSubmitted(FeedbackType.driver)) return;

    emit(state.copyWith(status: FeedbackStatus.loading, clearError: true));

    final result = await _feedbackRepository.submitDriverFeedback(
      driverId: driverId,
      requestId: requestId,
      rate: rate,
      comment: comment,
    );

    result.fold(
      (failure) {
        developer.log(
          'Driver feedback failed: ${failure.message}',
          name: 'Rescufy.FeedbackCubit',
        );
        emit(
          state.copyWith(
            status: FeedbackStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        developer.log(
          'Driver feedback submitted: requestId=$requestId',
          name: 'Rescufy.FeedbackCubit',
        );
        final updated = Set<FeedbackType>.from(state.submittedTypes)
          ..add(FeedbackType.driver);
        emit(
          state.copyWith(
            status: FeedbackStatus.success,
            submittedTypes: updated,
          ),
        );
      },
    );
  }

  Future<void> submitParamedicFeedback({
    required String paramedicId,
    required int requestId,
    required int rate,
    String? comment,
  }) async {
    if (state.isSubmitted(FeedbackType.paramedic)) return;

    emit(state.copyWith(status: FeedbackStatus.loading, clearError: true));

    final result = await _feedbackRepository.submitParamedicFeedback(
      paramedicId: paramedicId,
      requestId: requestId,
      rate: rate,
      comment: comment,
    );

    result.fold(
      (failure) {
        developer.log(
          'Paramedic feedback failed: ${failure.message}',
          name: 'Rescufy.FeedbackCubit',
        );
        emit(
          state.copyWith(
            status: FeedbackStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        developer.log(
          'Paramedic feedback submitted: requestId=$requestId',
          name: 'Rescufy.FeedbackCubit',
        );
        final updated = Set<FeedbackType>.from(state.submittedTypes)
          ..add(FeedbackType.paramedic);
        emit(
          state.copyWith(
            status: FeedbackStatus.success,
            submittedTypes: updated,
          ),
        );
      },
    );
  }

  Future<void> submitHospitalFeedback({
    required int hospitalId,
    required int requestId,
    required int rate,
    String? comment,
  }) async {
    if (state.isSubmitted(FeedbackType.hospital)) return;

    emit(state.copyWith(status: FeedbackStatus.loading, clearError: true));

    final result = await _feedbackRepository.submitHospitalFeedback(
      hospitalId: hospitalId,
      requestId: requestId,
      rate: rate,
      comment: comment,
    );

    result.fold(
      (failure) {
        developer.log(
          'Hospital feedback failed: ${failure.message}',
          name: 'Rescufy.FeedbackCubit',
        );
        emit(
          state.copyWith(
            status: FeedbackStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        developer.log(
          'Hospital feedback submitted: requestId=$requestId',
          name: 'Rescufy.FeedbackCubit',
        );
        final updated = Set<FeedbackType>.from(state.submittedTypes)
          ..add(FeedbackType.hospital);
        emit(
          state.copyWith(
            status: FeedbackStatus.success,
            submittedTypes: updated,
          ),
        );
      },
    );
  }

  void resetSuccess() {
    if (state.status == FeedbackStatus.success) {
      emit(state.copyWith(status: FeedbackStatus.initial));
    }
  }
}
