import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rescufy/core/theme/app_spacing.dart';
import 'package:rescufy/core/theme/app_theme_tokens.dart';

import '../cubit/dashboard_state.dart';

class DashboardWaitingCard extends StatelessWidget {
  const DashboardWaitingCard({
    super.key,
    required this.signalRStatus,
    required this.isOnline,
  });

  final DashboardSignalRStatus signalRStatus;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;
    final iconColor = isOnline ? theme.colorScheme.primary : tokens.warning;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl.w),
        child: Column(
          children: [
            Icon(Icons.local_hospital_outlined, size: 48.sp, color: iconColor),
            SizedBox(height: 14.h),
            Text(
              'Waiting for emergency requests',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xs.h),
            Text(
              signalRStatus == DashboardSignalRStatus.connected
                  ? 'The mock SignalR service will emit a request automatically after a short interval.'
                  : 'The dashboard will begin listening as soon as the connection is active.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
