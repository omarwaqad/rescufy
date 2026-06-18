import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rescufy/core/di/injection_container.dart' as di;
import 'package:rescufy/core/navigation/app_routes.dart';
import 'package:rescufy/core/theme/app_text_styles.dart';
import 'package:rescufy/core/theme/colors.dart';
import 'package:rescufy/domain/entities/incoming_request.dart';
import 'package:rescufy/domain/entities/request_history.dart';
import 'package:rescufy/l10n/app_localizations.dart';
import 'package:rescufy/presentation/paramedic/history/cubit/history_cubit.dart';
import 'package:rescufy/presentation/paramedic/history/cubit/history_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<HistoryCubit>()..loadHistory(),
      child: const _HistoryScreenBody(),
    );
  }
}

class _HistoryScreenBody extends StatelessWidget {
  const _HistoryScreenBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColorsDark.background : AppColors.background,
      body: BlocConsumer<HistoryCubit, HistoryState>(
        listenWhen: (prev, curr) =>
            prev.errorMessage != curr.errorMessage &&
            curr.errorMessage != null &&
            curr.errorMessage!.isNotEmpty,
        listener: (context, state) {
          if (state.errorMessage != null && state.status != HistoryStatus.loading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          final items = state.items;

          return RefreshIndicator(
            onRefresh: () => context.read<HistoryCubit>().refresh(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 120.h,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppColors.primary,
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      onPressed: () => context.read<HistoryCubit>().refresh(),
                      icon: const Icon(Icons.refresh_rounded),
                      color: Colors.white,
                      tooltip: l10n.refresh,
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      l10n.requestHistoryTitle,
                      style: AppTextStyles.headlineMedium(
                        Colors.white,
                      ).copyWith(fontWeight: FontWeight.bold),
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
                  child: _RequestStatsHeader(
                    items: items,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  ),
                ),
                ..._buildContentSlivers(
                  context: context,
                  state: state,
                  isDark: isDark,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildContentSlivers({
    required BuildContext context,
    required HistoryState state,
    required bool isDark,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    final l10n = AppLocalizations.of(context)!;

    if (state.status == HistoryStatus.loading && state.items.isEmpty) {
      return const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (state.status == HistoryStatus.error && state.items.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _HistoryMessageState(
            icon: Icons.history_toggle_off,
            title: l10n.requestHistoryLoadFailed,
            subtitle: state.errorMessage ?? l10n.requestHistoryLoadFailed,
            buttonLabel: l10n.retry,
            onPressed: () => context.read<HistoryCubit>().loadHistory(),
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
        ),
      ];
    }

    if (state.status == HistoryStatus.empty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _HistoryEmptyState(
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final request = state.items[index];
            return _RequestHistoryCard(
              request: request,
              isDark: isDark,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            );
          }, childCount: state.items.length),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 4.h, bottom: 20.h),
          child: state.isLoadingDetails
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink(),
        ),
      ),
    ];
  }
}

class _RequestStatsHeader extends StatelessWidget {
  const _RequestStatsHeader({
    required this.items,
    required this.textColor,
    required this.secondaryTextColor,
  });

  final List<RequestHistory> items;
  final Color textColor;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final completedCount = items.where(_isCompleted).length;
    final cancelledCount = items.where(_isCancelled).length;
    final inProgressCount = items.length - completedCount - cancelledCount;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.check_circle,
            label: l10n.requestHistoryCompleted,
            value: '$completedCount',
            color: AppColors.success,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
          _StatItem(
            icon: Icons.access_time,
            label: l10n.requestHistoryInProgress,
            value: '$inProgressCount',
            color: AppColors.warning,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
          _StatItem(
            icon: Icons.cancel,
            label: l10n.requestHistoryCancelled,
            value: '$cancelledCount',
            color: AppColors.error,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
        ],
      ),
    );
  }

  bool _isCompleted(RequestHistory request) {
    return const {
      'Delivered',
      'Finished',
      'Closed',
    }.contains(request.requestStatus);
  }

  bool _isCancelled(RequestHistory request) {
    return const {'Canceled', 'NotDelivered'}.contains(request.requestStatus);
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
    required this.secondaryTextColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color textColor;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: AppTextStyles.headlineMedium(
            textColor,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.bodySmall(secondaryTextColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState({
    required this.textColor,
    required this.secondaryTextColor,
  });

  final Color textColor;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.history, size: 60.sp, color: AppColors.primary),
            ),
            SizedBox(height: 24.h),
            Text(
              l10n.requestHistoryEmptyTitle,
              style: AppTextStyles.headlineMedium(textColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              l10n.requestHistoryEmptyMessage,
              style: AppTextStyles.bodyMedium(secondaryTextColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryMessageState extends StatelessWidget {
  const _HistoryMessageState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
    required this.textColor,
    required this.secondaryTextColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;
  final Color textColor;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 60.sp, color: AppColors.primary),
            ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: AppTextStyles.headlineMedium(textColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium(secondaryTextColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: 180.w,
              height: 50.h,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text(buttonLabel, style: AppTextStyles.buttonLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestHistoryCard extends StatelessWidget {
  const _RequestHistoryCard({
    required this.request,
    required this.isDark,
    required this.textColor,
    required this.secondaryTextColor,
  });

  final RequestHistory request;
  final bool isDark;
  final Color textColor;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusUi = _RequestStatusUi.fromValue(context, request.requestStatus);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.card : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => _showRequestDetails(context, request),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '${l10n.requestId} #${request.id}',
                          style: AppTextStyles.labelLarge(
                            AppColors.primary,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    _StatusBadge(statusUi: statusUi),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  request.description,
                  style: AppTextStyles.bodyLarge(
                    textColor,
                  ).copyWith(fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 16.w,
                  runSpacing: 12.h,
                  children: [
                    _InfoChip(
                      icon: Icons.calendar_today,
                      label: _formatDate(context, request.createdAt),
                      isDark: isDark,
                      secondaryTextColor: secondaryTextColor,
                    ),
                    _InfoChip(
                      icon: Icons.flag_outlined,
                      label: statusUi.label,
                      isDark: isDark,
                      secondaryTextColor: secondaryTextColor,
                    ),
                  ],
                ),
                if (_hasValue(request.assignedAmbulancePlate)) ...[
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColorsDark.background
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: _CardDetailRow(
                      icon: Icons.local_hospital,
                      label: request.assignedAmbulancePlate!,
                      textColor: textColor,
                    ),
                  ),
                ],
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => _showRequestDetails(context, request),
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        label: Text(
                          l10n.viewDetails,
                          style: AppTextStyles.labelLarge(
                            AppColors.primary,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRequestDetails(BuildContext context, RequestHistory request) {
    final statusUi = _RequestStatusUi.fromValue(context, request.requestStatus);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final l10n = AppLocalizations.of(context)!;
    final historyCubit = context.read<HistoryCubit>();

    final statusLower = request.requestStatus.toLowerCase();
    final isAcceptEnabled = statusLower == 'assigned';
    final isActiveCaseEnabled = const {
      'accepted',
      'ontheway',
      'arrived',
      'pickedup',
      'underexecuting',
    }.contains(statusLower);

    final details = <_DetailItem>[
      _DetailItem(label: l10n.requestId, value: '#${request.id}'),
      _DetailItem(label: l10n.requestStatus, value: statusUi.label),
      if (request.description.trim().isNotEmpty)
        _DetailItem(label: l10n.descriptionLabel, value: request.description),
      if (request.address.trim().isNotEmpty)
        _DetailItem(label: l10n.addressLabel, value: request.address),
      _DetailItem(
        label: l10n.createdDate,
        value: _formatDate(context, request.createdAt),
      ),
      if (_hasValue(request.assignedAmbulancePlate))
        _DetailItem(
          label: l10n.assignedAmbulancePlate,
          value: request.assignedAmbulancePlate!,
        ),
      if (_hasValue(request.driverName))
        _DetailItem(label: l10n.driverName, value: request.driverName!),
      if (_hasValue(request.hospitalName))
        _DetailItem(label: l10n.hospitalName, value: request.hospitalName!),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: historyCubit,
          child: BlocListener<HistoryCubit, HistoryState>(
            listenWhen: (prev, curr) =>
                prev.selectedRequest != curr.selectedRequest &&
                curr.selectedRequest != null &&
                curr.pendingAction != null,
            listener: (sheetContext, state) {
              final request = state.selectedRequest!;
              Navigator.pop(sheetContext);
              switch (state.pendingAction!) {
                case HistoryAction.openIncomingRequest:
                  Navigator.of(context).pushNamed(
                    AppRoutes.paramedicIncomingRequest,
                    arguments: request,
                  );
                  break;
                case HistoryAction.openActiveCase:
                  Navigator.of(context).pushNamed(
                    AppRoutes.paramedicActiveCase,
                    arguments: request,
                  );
                  break;
              }
              historyCubit.clearNavigation();
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: isDark ? AppColorsDark.surface : Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColorsDark.divider : AppColors.divider,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryDark, AppColors.primary],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.description,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.requestHistoryDetailsTitle,
                                style: AppTextStyles.headlineMedium(
                                  Colors.white,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '#${request.id}',
                                style: AppTextStyles.bodyMedium(
                                  Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(
                            title: l10n.requestStatus,
                            icon: Icons.info_outline,
                            textColor: textColor,
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: statusUi.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: statusUi.color.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(statusUi.icon, color: statusUi.color),
                                SizedBox(width: 12.w),
                                Text(
                                  statusUi.label,
                                  style: AppTextStyles.bodyLarge(
                                    statusUi.color,
                                  ).copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          _SectionHeader(
                            title: l10n.requestHistoryDetailsTitle,
                            icon: Icons.medical_services,
                            textColor: textColor,
                          ),
                          SizedBox(height: 12.h),
                          _DetailCard(
                            items: details,
                            isDark: isDark,
                            textColor: textColor,
                            secondaryTextColor: secondaryTextColor,
                          ),
                          SizedBox(height: 24.h),
                          _SectionHeader(
                            title: 'Actions',
                            icon: Icons.play_circle_outline,
                            textColor: textColor,
                          ),
                          SizedBox(height: 12.h),
                          BlocBuilder<HistoryCubit, HistoryState>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: isAcceptEnabled
                                          ? () => context
                                              .read<HistoryCubit>()
                                              .openRequest(
                                                request.id,
                                                HistoryAction.openIncomingRequest,
                                              )
                                          : null,
                                      child: state.isLoadingDetails
                                          ? SizedBox(
                                              width: 20.w,
                                              height: 20.w,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                            )
                                          : const Text('Accept Request'),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: isActiveCaseEnabled
                                          ? () => context
                                              .read<HistoryCubit>()
                                              .openRequest(
                                                request.id,
                                                HistoryAction.openActiveCase,
                                              )
                                          : null,
                                      child: state.isLoadingDetails
                                          ? SizedBox(
                                              width: 20.w,
                                              height: 20.w,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            )
                                          : const Text('Active Case'),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static String _formatDate(BuildContext context, DateTime dateTime) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(locale).add_jm().format(dateTime.toLocal());
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
            style: AppTextStyles.labelMedium(
              statusUi.color,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.secondaryTextColor,
  });

  final IconData icon;
  final String label;
  final bool isDark;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.background : AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: secondaryTextColor),
          SizedBox(width: 6.w),
          Text(label, style: AppTextStyles.bodySmall(secondaryTextColor)),
        ],
      ),
    );
  }
}

class _CardDetailRow extends StatelessWidget {
  const _CardDetailRow({
    required this.icon,
    required this.label,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.primary),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall(
              textColor,
            ).copyWith(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
          style: AppTextStyles.headlineSmall(
            textColor,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.items,
    required this.isDark,
    required this.textColor,
    required this.secondaryTextColor,
  });

  final List<_DetailItem> items;
  final bool isDark;
  final Color textColor;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.background : AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: items.map((item) {
          final isLast = identical(item, items.last);
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      item.label,
                      style: AppTextStyles.bodyMedium(secondaryTextColor),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.value,
                      style: AppTextStyles.bodyMedium(
                        textColor,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              if (!isLast) ...[
                SizedBox(height: 12.h),
                Divider(
                  color: isDark ? AppColorsDark.divider : AppColors.divider,
                  height: 1,
                ),
                SizedBox(height: 12.h),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _DetailItem {
  const _DetailItem({required this.label, required this.value});

  final String label;
  final String value;
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

  factory _RequestStatusUi.fromValue(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;

    switch (status) {
      case 'Pending':
        return _RequestStatusUi(
          label: l10n.requestStatusPending,
          color: AppColors.warning,
          icon: Icons.hourglass_top,
        );
      case 'Assigned':
        return _RequestStatusUi(
          label: l10n.requestStatusAssigned,
          color: AppColors.info,
          icon: Icons.assignment_turned_in_outlined,
        );
      case 'Accepted':
        return _RequestStatusUi(
          label: l10n.requestStatusAccepted,
          color: AppColors.info,
          icon: Icons.check_circle_outline,
        );
      case 'OnTheWay':
        return _RequestStatusUi(
          label: l10n.requestStatusOnTheWay,
          color: AppColors.primary,
          icon: Icons.local_shipping_outlined,
        );
      case 'Arrived':
        return _RequestStatusUi(
          label: l10n.requestStatusArrived,
          color: AppColors.primary,
          icon: Icons.location_on_outlined,
        );
      case 'PickedUp':
        return _RequestStatusUi(
          label: l10n.requestStatusPickedUp,
          color: AppColors.primary,
          icon: Icons.medical_services_outlined,
        );
      case 'UnderExecuting':
        return _RequestStatusUi(
          label: l10n.requestStatusUnderExecuting,
          color: AppColors.warning,
          icon: Icons.sync,
        );
      case 'Delivered':
        return _RequestStatusUi(
          label: l10n.requestStatusDelivered,
          color: AppColors.success,
          icon: Icons.done_all,
        );
      case 'NotDelivered':
        return _RequestStatusUi(
          label: l10n.requestStatusNotDelivered,
          color: AppColors.error,
          icon: Icons.report_problem_outlined,
        );
      case 'Canceled':
        return _RequestStatusUi(
          label: l10n.requestStatusCanceled,
          color: AppColors.error,
          icon: Icons.cancel_outlined,
        );
      case 'Finished':
        return _RequestStatusUi(
          label: l10n.requestStatusFinished,
          color: AppColors.success,
          icon: Icons.task_alt,
        );
      case 'Closed':
        return _RequestStatusUi(
          label: l10n.requestStatusClosed,
          color: AppColors.success,
          icon: Icons.lock_outline,
        );
      default:
        return _RequestStatusUi(
          label: l10n.unknownRequestStatus,
          color: AppColors.textSecondary,
          icon: Icons.info_outline,
        );
    }
  }
}
