import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rescufy/core/theme/app_spacing.dart';
import 'package:rescufy/core/theme/app_theme_tokens.dart';
import 'package:rescufy/presentation/paramedic/dashboard/cubit/dashboard_state.dart';

class DashboardStatusHero extends StatelessWidget {
  const DashboardStatusHero({
    super.key,
    required this.isOnline,
    required this.signalRStatus,
    required this.onToggleAvailability,
  });

  final bool isOnline;
  final DashboardSignalRStatus signalRStatus;
  final VoidCallback onToggleAvailability;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;
    final availabilityColor = isOnline ? tokens.success : tokens.warning;
    final (connectionLabel, connectionColor) = switch (signalRStatus) {
      DashboardSignalRStatus.connected => ('Connected', tokens.success),
      DashboardSignalRStatus.connecting => ('Connecting', tokens.warning),
      DashboardSignalRStatus.reconnecting => ('Reconnecting', tokens.warning),
      DashboardSignalRStatus.disconnected => (
        'Disconnected',
        theme.colorScheme.error,
      ),
    };

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 46.w,
                  height: 46.w,
                  decoration: BoxDecoration(
                    color: availabilityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadii.md.r),
                  ),
                  child: Icon(
                    isOnline
                        ? Icons.online_prediction
                        : Icons.power_settings_new,
                    color: availabilityColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Availability',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        isOnline ? 'Online for dispatch' : 'Offline',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isOnline,
                  onChanged: (_) => onToggleAvailability(),
                  activeThumbColor: theme.colorScheme.primary,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm.h),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm.w,
                vertical: 10.h,
              ),
              decoration: BoxDecoration(
                color: tokens.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadii.sm.r),
                border: Border.all(color: tokens.outlineSoft),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: connectionColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs.w),
                  Expanded(
                    child: Text(
                      isOnline
                          ? 'Dispatch channel ready'
                          : 'Turn on availability when your unit is ready',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Text(
                    connectionLabel,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: connectionColor,
                      fontWeight: FontWeight.w800,
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
