import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/core/theme/app_text_styles.dart';
import 'package:rescufy/core/theme/colors.dart';
import 'package:rescufy/l10n/app_localizations.dart';
import 'package:rescufy/presentation/user/feedback/cubit/feedback_cubit.dart';
import 'package:rescufy/presentation/user/feedback/cubit/feedback_state.dart';

class FeedbackBottomSheet extends StatefulWidget {
  const FeedbackBottomSheet({
    super.key,
    required this.title,
    required this.onSubmit,
    this.initialRating = 0,
  });

  final String title;
  final ValueChanged<({int rating, String? comment})> onSubmit;
  final int initialRating;

  @override
  State<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();

  static void show({
    required BuildContext context,
    required String title,
    required ValueChanged<({int rating, String? comment})> onSubmit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) => FeedbackBottomSheet(
        title: title,
        onSubmit: onSubmit,
      ),
    );
  }
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 24.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: secondaryTextColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            widget.title,
            style: AppTextStyles.headlineSmall(textColor)
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24.h),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return GestureDetector(
                  onTap: () => setState(() => _rating = starIndex),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Icon(
                      starIndex <= _rating ? Icons.star : Icons.star_border,
                      color: starIndex <= _rating ? Colors.amber : secondaryTextColor,
                      size: 36.sp,
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: Text(
              _rating == 0 ? l10n.selectRating : '$_rating / 5',
              style: AppTextStyles.bodyMedium(secondaryTextColor),
            ),
          ),
          SizedBox(height: 24.h),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: l10n.feedbackCommentHint,
              hintStyle: AppTextStyles.bodyMedium(secondaryTextColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.all(14.w),
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _rating > 0
                  ? () {
                      final comment = _commentController.text.trim();
                      widget.onSubmit((
                        rating: _rating,
                        comment: comment.isEmpty ? null : comment,
                      ));
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 52.h),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
              ),
              child: Text(l10n.submitFeedback),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class FeedbackSection extends StatelessWidget {
  const FeedbackSection({
    super.key,
    required this.request,
  });

  final ({int id, String? driverId, String? paramedicId, int? hospitalId, String status}) request;

  static bool isFeedbackEligible(String status) {
    final s = status.toLowerCase().replaceAll('_', '').replaceAll(' ', '');
    return const ['finished', 'delivered', 'completed'].contains(s);
  }

  @override
  Widget build(BuildContext context) {
    if (!isFeedbackEligible(request.status)) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => context.read<FeedbackCubit>(),
      child: BlocConsumer<FeedbackCubit, FeedbackState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status || prev.errorMessage != curr.errorMessage,
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.feedbackSubmittedSuccess)),
            );
            context.read<FeedbackCubit>().resetSuccess();
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          final hasAnyTarget =
              (request.driverId != null && request.driverId!.isNotEmpty) ||
              (request.paramedicId != null && request.paramedicId!.isNotEmpty) ||
              (request.hospitalId != null && request.hospitalId! > 0);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              _SectionHeader(
                title: l10n.actionsLabel,
                icon: Icons.star_border,
                textColor: textColor,
              ),
              SizedBox(height: 12.h),
              _FeedbackActionTile(
                label: l10n.rateDriver,
                icon: Icons.local_shipping,
                isAvailable: request.driverId != null && request.driverId!.isNotEmpty,
                unavailableLabel: l10n.rateDriverNotAvailable,
                isSubmitted: state.isSubmitted(FeedbackType.driver),
                submittedLabel: l10n.driverFeedbackSubmitted,
                onTap: state.isLoading
                    ? null
                    : () => _onRateDriver(context, state),
              ),
              _FeedbackActionTile(
                label: l10n.rateParamedic,
                icon: Icons.medical_services,
                isAvailable: request.paramedicId != null && request.paramedicId!.isNotEmpty,
                unavailableLabel: l10n.rateParamedicNotAvailable,
                isSubmitted: state.isSubmitted(FeedbackType.paramedic),
                submittedLabel: l10n.paramedicFeedbackSubmitted,
                onTap: state.isLoading
                    ? null
                    : () => _onRateParamedic(context, state),
              ),
              _FeedbackActionTile(
                label: l10n.rateHospital,
                icon: Icons.local_hospital,
                isAvailable: request.hospitalId != null && request.hospitalId! > 0,
                unavailableLabel: l10n.rateHospitalNotAvailable,
                isSubmitted: state.isSubmitted(FeedbackType.hospital),
                submittedLabel: l10n.hospitalFeedbackSubmitted,
                onTap: state.isLoading
                    ? null
                    : () => _onRateHospital(context, state),
              ),
              if (!hasAnyTarget)
                Padding(
                  padding: EdgeInsets.only(top: 8.h, left: 4.w),
                  child: Text(
                    l10n.feedbackNotAvailable,
                    style: AppTextStyles.bodySmall(secondaryTextColor),
                  ),
                ),
              if (state.isLoading)
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _onRateDriver(BuildContext context, FeedbackState state) {
    if (state.isSubmitted(FeedbackType.driver)) return;
    final l10n = AppLocalizations.of(context)!;
    FeedbackBottomSheet.show(
      context: context,
      title: l10n.rateDriver,
      onSubmit: (result) {
        Navigator.of(context).pop();
        context.read<FeedbackCubit>().submitDriverFeedback(
          driverId: request.driverId!,
          requestId: request.id,
          rate: result.rating,
          comment: result.comment,
        );
      },
    );
  }

  void _onRateParamedic(BuildContext context, FeedbackState state) {
    if (state.isSubmitted(FeedbackType.paramedic)) return;
    final l10n = AppLocalizations.of(context)!;
    FeedbackBottomSheet.show(
      context: context,
      title: l10n.rateParamedic,
      onSubmit: (result) {
        Navigator.of(context).pop();
        context.read<FeedbackCubit>().submitParamedicFeedback(
          paramedicId: request.paramedicId!,
          requestId: request.id,
          rate: result.rating,
          comment: result.comment,
        );
      },
    );
  }

  void _onRateHospital(BuildContext context, FeedbackState state) {
    if (state.isSubmitted(FeedbackType.hospital)) return;
    final l10n = AppLocalizations.of(context)!;
    FeedbackBottomSheet.show(
      context: context,
      title: l10n.rateHospital,
      onSubmit: (result) {
        Navigator.of(context).pop();
        context.read<FeedbackCubit>().submitHospitalFeedback(
          hospitalId: request.hospitalId!,
          requestId: request.id,
          rate: result.rating,
          comment: result.comment,
        );
      },
    );
  }
}

class _FeedbackActionTile extends StatelessWidget {
  const _FeedbackActionTile({
    required this.label,
    required this.icon,
    required this.isAvailable,
    required this.unavailableLabel,
    required this.isSubmitted,
    required this.submittedLabel,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isAvailable;
  final String unavailableLabel;
  final bool isSubmitted;
  final String submittedLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;

    if (isSubmitted) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.success.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 20.sp),
            SizedBox(width: 12.w),
            Text(
              submittedLabel,
              style: AppTextStyles.bodyMedium(textColor).copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      );
    }

    if (!isAvailable) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: (isDark ? AppColorsDark.surface : Colors.white).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: secondaryTextColor.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: secondaryTextColor, size: 20.sp),
            SizedBox(width: 12.w),
            Text(
              unavailableLabel,
              style: AppTextStyles.bodyMedium(secondaryTextColor).copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.primary, size: 20.sp),
        label: Text(
          label,
          style: AppTextStyles.labelLarge(AppColors.primary)
              .copyWith(fontWeight: FontWeight.w600),
        ),
        style: TextButton.styleFrom(
          alignment: AlignmentDirectional.centerStart,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          backgroundColor: isDark ? AppColorsDark.surface : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.textColor,
  });

  final String title;
  final IconData icon;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          title,
          style: AppTextStyles.headlineSmall(textColor)
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
