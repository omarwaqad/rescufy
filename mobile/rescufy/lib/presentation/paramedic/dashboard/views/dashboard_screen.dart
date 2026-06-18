import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/core/navigation/app_routes.dart';
import 'package:rescufy/core/theme/app_spacing.dart';
import 'package:rescufy/core/theme/app_theme_tokens.dart';
import 'package:rescufy/domain/entities/incoming_request.dart';
import 'package:rescufy/presentation/paramedic/dashboard/cubit/dashboard_cubit.dart';
import 'package:rescufy/presentation/paramedic/dashboard/cubit/dashboard_state.dart';
import 'package:rescufy/presentation/shared/notifications/widgets/notification_badge.dart';
import 'package:rescufy/shared/widgets/common/app_screen_header.dart';

import '../widgets/dashboard_inline_message.dart';
import '../widgets/dashboard_status_hero.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }

    _initialized = true;
    context.read<DashboardCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;

    return BlocConsumer<DashboardCubit, DashboardState>(
      listenWhen: (prev, curr) =>
          curr.incomingRequest != null &&
          curr.incomingRequest != prev.incomingRequest,
      listener: (context, state) async {
        final request = state.incomingRequest;
        if (request == null) {
          return;
        }

        await Navigator.of(
          context,
        ).pushNamed(AppRoutes.paramedicIncomingRequest, arguments: request);

        if (context.mounted) {
          context.read<DashboardCubit>().clearIncomingRequest();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: DecoratedBox(
            decoration: BoxDecoration(gradient: tokens.heroGradient),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg.w,
                  AppSpacing.lg.h,
                  AppSpacing.lg.w,
                  AppSpacing.xl.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppScreenHeader(
                      title: 'Dispatch Dashboard',
                      subtitle: 'Ambulance unit operations',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _SystemStatusPill(
                            status: state.signalRStatus,
                          ),
                          SizedBox(width: AppSpacing.sm.w),
                          const NotificationBadge(),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl.h),
                    DashboardStatusHero(
                      isOnline: state.isOnline,
                      signalRStatus: state.signalRStatus,
                      onToggleAvailability: context
                          .read<DashboardCubit>()
                          .toggleAvailability,
                    ),
                    if (state.error != null) ...[
                      SizedBox(height: AppSpacing.md.h),
                      DashboardInlineMessage(
                        icon: Icons.error_outline,
                        color: theme.colorScheme.error,
                        message: state.error!,
                      ),
                    ],
                    SizedBox(height: AppSpacing.xl.h),
                    _ActiveShiftSummary(
                      isOnline: state.isOnline,
                      signalRStatus: state.signalRStatus,
                      hasIncomingRequest: state.incomingRequest != null,
                    ),
                    SizedBox(height: AppSpacing.xl.h),
                    _SectionHeader(
                      title: 'Active Emergency',
                      actionLabel: state.incomingRequest == null
                          ? 'Standing by'
                          : 'Incoming',
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    _ActiveEmergencySection(request: state.incomingRequest),
                    SizedBox(height: AppSpacing.xl.h),
                    const _SectionHeader(
                      title: 'Recent Activity',
                      actionLabel: 'Today',
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    _RecentActivitySection(
                      isOnline: state.isOnline,
                      signalRStatus: state.signalRStatus,
                    ),
                    SizedBox(height: AppSpacing.xl.h),
                    const _SectionHeader(
                      title: 'Driver Performance',
                      actionLabel: 'Shift',
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    const _PerformanceSnapshot(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SystemStatusPill extends StatelessWidget {
  const _SystemStatusPill({required this.status});

  final DashboardSignalRStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, color) = _connectionStatusData(context, status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadii.pill.r),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hub_outlined, color: color, size: 15.sp),
          SizedBox(width: 6.w),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveShiftSummary extends StatelessWidget {
  const _ActiveShiftSummary({
    required this.isOnline,
    required this.signalRStatus,
    required this.hasIncomingRequest,
  });

  final bool isOnline;
  final DashboardSignalRStatus signalRStatus;
  final bool hasIncomingRequest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;
    final availabilityColor = isOnline ? tokens.success : tokens.warning;
    final (connectionLabel, connectionColor) = _connectionStatusData(
      context,
      signalRStatus,
    );
    final lastActivity = hasIncomingRequest
        ? 'Request received now'
        : isOnline
        ? 'Standing by'
        : 'Unit offline';

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Shift Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            Row(
              children: [
                Expanded(
                  child: _SummaryTile(
                    label: 'Availability',
                    value: isOnline ? 'Online' : 'Offline',
                    icon: Icons.radio_button_checked,
                    color: availabilityColor,
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Expanded(
                  child: _SummaryTile(
                    label: 'Connection',
                    value: connectionLabel,
                    icon: Icons.sync_alt,
                    color: connectionColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm.h),
            _SummaryTile(
              label: 'Last activity',
              value: lastActivity,
              icon: Icons.schedule_outlined,
              color: tokens.info,
              horizontal: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.horizontal = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelValue = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.all(AppSpacing.sm.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppRadii.sm.r),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: horizontal
          ? Row(
              children: [
                Icon(icon, color: color, size: 18.sp),
                SizedBox(width: AppSpacing.sm.w),
                Expanded(child: labelValue),
              ],
            )
          : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Icon(icon, color: color, size: 18.sp),
                SizedBox(height: AppSpacing.xs.h),
                labelValue,
          ],
        ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.actionLabel});

  final String title;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          actionLabel,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.textTheme.bodySmall?.color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ActiveEmergencySection extends StatelessWidget {
  const _ActiveEmergencySection({required this.request});

  final IncomingRequest? request;

  @override
  Widget build(BuildContext context) {
    final currentRequest = request;
    if (currentRequest == null) {
      return const _NoActiveEmergencyCard();
    }

    return _IncomingEmergencyCard(request: currentRequest);
  }
}

class _NoActiveEmergencyCard extends StatelessWidget {
  const _NoActiveEmergencyCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: tokens.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadii.sm.r),
              ),
              child: Icon(
                Icons.local_hospital_outlined,
                color: tokens.success,
                size: 23.sp,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No active emergency',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    'Dispatch channel is clear. Keep availability on when ready to receive the next case.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncomingEmergencyCard extends StatelessWidget {
  const _IncomingEmergencyCard({required this.request});

  final IncomingRequest request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;
    final severityColor = request.isCritical
        ? theme.colorScheme.error
        : tokens.warning;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadii.pill.r),
                  ),
                  child: Text(
                    request.severity.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: severityColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  request.caseId,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              request.emergencyType,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: AppSpacing.xs.h),
            Text(
              '${request.patientName} • ${request.patientAge} • ${request.patientGender}',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: AppSpacing.md.h),
            _EmergencyDetailRow(
              icon: Icons.place_outlined,
              label: request.address,
            ),
            SizedBox(height: AppSpacing.xs.h),
            _EmergencyDetailRow(
              icon: Icons.local_hospital_outlined,
              label: request.hospitalName,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyDetailRow extends StatelessWidget {
  const _EmergencyDetailRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17.sp, color: theme.colorScheme.primary),
        SizedBox(width: AppSpacing.xs.w),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  const _RecentActivitySection({
    required this.isOnline,
    required this.signalRStatus,
  });

  final bool isOnline;
  final DashboardSignalRStatus signalRStatus;

  @override
  Widget build(BuildContext context) {
    final (connectionLabel, _) = _connectionStatusData(context, signalRStatus);
    final items = [
      (
        title: isOnline ? 'Available for dispatch' : 'Availability off',
        meta: isOnline ? 'Current shift' : 'Tap availability to receive cases',
        icon: isOnline ? Icons.check_circle_outline : Icons.pause_circle_outline,
      ),
      (
        title: 'SignalR $connectionLabel',
        meta: 'System channel',
        icon: Icons.hub_outlined,
      ),
      (
        title: 'No completed cases recorded',
        meta: 'Today',
        icon: Icons.assignment_turned_in_outlined,
      ),
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md.w,
          vertical: AppSpacing.sm.h,
        ),
        child: Column(
          children: [
            for (var index = 0; index < items.length; index++) ...[
              _ActivityTimelineItem(
                title: items[index].title,
                meta: items[index].meta,
                icon: items[index].icon,
                isLast: index == items.length - 1,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActivityTimelineItem extends StatelessWidget {
  const _ActivityTimelineItem({
    required this.title,
    required this.meta,
    required this.icon,
    required this.isLast,
  });

  final String title;
  final String meta;
  final IconData icon;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: tokens.surfaceMuted,
                  shape: BoxShape.circle,
                  border: Border.all(color: tokens.outlineSoft),
                ),
                child: Icon(icon, size: 16.sp, color: theme.colorScheme.primary),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    color: tokens.outlineSoft,
                  ),
                ),
            ],
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 2.h : AppSpacing.md.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(meta, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceSnapshot extends StatelessWidget {
  const _PerformanceSnapshot();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md.w),
        child: Row(
          children: [
            const Expanded(
              child: _PerformanceMetric(label: 'Cases', value: '0'),
            ),
            _MetricDivider(),
            const Expanded(
              child: _PerformanceMetric(label: 'Avg response', value: '--'),
            ),
            _MetricDivider(),
            const Expanded(
              child: _PerformanceMetric(label: 'Shift', value: '0h'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PerformanceMetric extends StatelessWidget {
  const _PerformanceMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: theme.textTheme.labelMedium,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _MetricDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokens = context.appThemeTokens;

    return Container(
      width: 1,
      height: 38.h,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.sm.w),
      color: tokens.outlineSoft,
    );
  }
}

(String, Color) _connectionStatusData(
  BuildContext context,
  DashboardSignalRStatus status,
) {
  final theme = Theme.of(context);
  final tokens = context.appThemeTokens;

  return switch (status) {
    DashboardSignalRStatus.connected => ('Connected', tokens.success),
    DashboardSignalRStatus.connecting => ('Connecting', tokens.warning),
    DashboardSignalRStatus.reconnecting => ('Reconnecting', tokens.warning),
    DashboardSignalRStatus.disconnected => (
      'Disconnected',
      theme.colorScheme.error,
    ),
  };
}
