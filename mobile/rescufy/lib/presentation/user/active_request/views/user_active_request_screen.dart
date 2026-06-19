import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/core/theme/app_text_styles.dart';
import 'package:rescufy/core/theme/colors.dart';
import 'package:rescufy/domain/entities/user_active_request.dart';
import 'package:rescufy/l10n/app_localizations.dart';
import 'package:rescufy/presentation/user/active_request/cubit/user_active_request_cubit.dart';
import 'package:rescufy/presentation/user/active_request/cubit/user_active_request_state.dart';

class UserActiveRequestScreen extends StatefulWidget {
  const UserActiveRequestScreen({super.key, required this.requestId});

  final int requestId;

  @override
  State<UserActiveRequestScreen> createState() => _UserActiveRequestScreenState();
}

class _UserActiveRequestScreenState extends State<UserActiveRequestScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    context.read<UserActiveRequestCubit>().loadRequest(widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColorsDark.background : AppColors.background,
      body: BlocConsumer<UserActiveRequestCubit, UserActiveRequestState>(
        listenWhen: (prev, curr) => prev.errorMessage != curr.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && !state.hasRequest) {
            return _LoadingView(textColor: textColor);
          }

          if (state.isError && !state.hasRequest) {
            return _ErrorView(
              message: state.errorMessage ?? l10n.requestHistoryLoadFailed,
              onRetry: () => context.read<UserActiveRequestCubit>().loadRequest(widget.requestId),
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            );
          }

          final request = state.request;
          if (request == null) {
            return _ErrorView(
              message: l10n.requestHistoryLoadFailed,
              onRetry: () => context.read<UserActiveRequestCubit>().loadRequest(widget.requestId),
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<UserActiveRequestCubit>().refresh(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 140.h,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppColors.primary,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      l10n.activeRequestTitle,
                      style: AppTextStyles.headlineMedium(Colors.white)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primaryDark, AppColors.primary],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _EmergencyStatusCard(
                          request: request,
                          isDark: isDark,
                          textColor: textColor,
                          secondaryTextColor: secondaryTextColor,
                        ),
                        SizedBox(height: 16.h),
                        _RequestTimeline(
                          currentStatus: request.status,
                          isDark: isDark,
                          textColor: textColor,
                          secondaryTextColor: secondaryTextColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmergencyStatusCard extends StatelessWidget {
  const _EmergencyStatusCard({
    required this.request,
    required this.isDark,
    required this.textColor,
    required this.secondaryTextColor,
  });

  final UserActiveRequest request;
  final bool isDark;
  final Color textColor;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusUi = _RequestStatusUi.fromValue(context, request.status);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${l10n.requestId} #${request.requestId}',
                  style: AppTextStyles.labelLarge(AppColors.primary)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              _StatusBadge(statusUi: statusUi),
            ],
          ),
          SizedBox(height: 20.h),
          _DetailRow(
            icon: Icons.local_hospital,
            label: l10n.hospitalName,
            value: request.hospitalName ?? l10n.notAvailable,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
          SizedBox(height: 12.h),
          _DetailRow(
            icon: Icons.timer,
            label: l10n.etaLabel,
            value: request.eta != null ? '${request.eta} ${l10n.minutes}' : l10n.notAvailable,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
          SizedBox(height: 12.h),
          _DetailRow(
            icon: Icons.info_outline,
            label: l10n.requestStatus,
            value: statusUi.label,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.textColor,
    required this.secondaryTextColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color textColor;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.sp, color: AppColors.primary),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall(secondaryTextColor),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: AppTextStyles.bodyLarge(textColor)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.statusUi});

  final _RequestStatusUi statusUi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: statusUi.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: statusUi.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: statusUi.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            statusUi.label,
            style: AppTextStyles.labelMedium(statusUi.color)
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _RequestTimeline extends StatelessWidget {
  const _RequestTimeline({
    required this.currentStatus,
    required this.isDark,
    required this.textColor,
    required this.secondaryTextColor,
  });

  final String currentStatus;
  final bool isDark;
  final Color textColor;
  final Color secondaryTextColor;

  static const _steps = [
    'Assigned',
    'Accepted',
    'OnTheWay',
    'Arrived',
    'PickedUp',
    'UnderExecuting',
    'Delivered',
  ];

  static final _stepLabels = {
    'Assigned': 'Assigned',
    'Accepted': 'Accepted',
    'OnTheWay': 'On The Way',
    'Arrived': 'Arrived',
    'PickedUp': 'Picked Up',
    'UnderExecuting': 'Heading To Hospital',
    'Delivered': 'Delivered',
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentIndex = _indexOfStatus(currentStatus);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.caseProgressLabel,
            style: AppTextStyles.headlineSmall(textColor)
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          ...List.generate(_steps.length, (index) {
            final isCompleted = index < currentIndex;
            final isCurrent = index == currentIndex;
            final stepLabel = _stepLabels[_steps[index]] ?? _steps[index];

            return _TimelineItem(
              label: stepLabel,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
              isLast: index == _steps.length - 1,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            );
          }),
        ],
      ),
    );
  }

  int _indexOfStatus(String status) {
    final normalized = status.toLowerCase().replaceAll('_', '').replaceAll(' ', '');
    for (var i = 0; i < _steps.length; i++) {
      if (_steps[i].toLowerCase().replaceAll('_', '') == normalized) {
        return i;
      }
    }
    return -1;
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.label,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
    required this.textColor,
    required this.secondaryTextColor,
  });

  final String label;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;
  final Color textColor;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    final color = isCompleted || isCurrent ? AppColors.success : secondaryTextColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.success : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: isCurrent ? 2 : 1,
                ),
              ),
              child: isCompleted
                  ? Icon(Icons.check, color: Colors.white, size: 14.sp)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 24.h,
                color: isCompleted ? AppColors.success : secondaryTextColor.withValues(alpha: 0.3),
              ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h, bottom: isLast ? 0 : 16.h),
            child: Text(
              label,
              style: AppTextStyles.bodyMedium(
                isCompleted || isCurrent ? textColor : secondaryTextColor,
              ).copyWith(
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({required this.textColor});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColorsDark.background
          : AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16.h),
            Text(l10n.loading, style: AppTextStyles.bodyMedium(textColor)),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.textColor,
    required this.secondaryTextColor,
  });

  final String message;
  final VoidCallback onRetry;
  final Color textColor;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColorsDark.background
          : AppColors.background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: AppColors.error, size: 48.sp),
              SizedBox(height: 14.h),
              Text(
                l10n.requestHistoryLoadFailed,
                style: AppTextStyles.headlineMedium(textColor)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(message, style: AppTextStyles.bodyMedium(secondaryTextColor)),
              SizedBox(height: 18.h),
              SizedBox(
                width: 180.w,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: onRetry,
                  child: Text(l10n.retry, style: AppTextStyles.buttonLarge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestStatusUi {
  const _RequestStatusUi({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  factory _RequestStatusUi.fromValue(BuildContext context, String value) {
    final l10n = AppLocalizations.of(context)!;
    final normalized = value.toLowerCase().replaceAll('_', '').replaceAll(' ', '');

    switch (normalized) {
      case 'assigned':
        return _RequestStatusUi(
          label: l10n.statusAssigned,
          color: AppColors.info,
          icon: Icons.assignment_ind,
        );
      case 'accepted':
        return _RequestStatusUi(
          label: l10n.statusAccepted,
          color: AppColors.success,
          icon: Icons.check_circle,
        );
      case 'ontheway':
      case 'onroute':
      case 'on_the_way':
        return _RequestStatusUi(
          label: l10n.statusOnTheWay,
          color: AppColors.primary,
          icon: Icons.local_shipping,
        );
      case 'arrived':
        return _RequestStatusUi(
          label: l10n.statusArrived,
          color: AppColors.warning,
          icon: Icons.place,
        );
      case 'pickedup':
      case 'picked_up':
        return _RequestStatusUi(
          label: l10n.statusPickedUp,
          color: AppColors.primary,
          icon: Icons.medical_services,
        );
      case 'underexecuting':
      case 'under_executing':
      case 'headingtohospital':
        return _RequestStatusUi(
          label: l10n.statusHeadingToHospital,
          color: AppColors.primary,
          icon: Icons.local_hospital,
        );
      case 'delivered':
      case 'completed':
      case 'finished':
        return _RequestStatusUi(
          label: l10n.statusDelivered,
          color: AppColors.success,
          icon: Icons.done_all,
        );
      case 'canceled':
      case 'cancelled':
      case 'notdelivered':
        return _RequestStatusUi(
          label: l10n.statusCancelled,
          color: AppColors.error,
          icon: Icons.cancel,
        );
      default:
        return _RequestStatusUi(
          label: value,
          color: AppColors.textSecondary,
          icon: Icons.help_outline,
        );
    }
  }
}
