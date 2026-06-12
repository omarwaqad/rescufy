import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rescufy/core/theme/app_spacing.dart';
import 'package:rescufy/core/theme/app_theme_tokens.dart';

import 'info_card.dart';

class HomeQuickAccessGrid extends StatelessWidget {
  const HomeQuickAccessGrid({
    super.key,
    required this.firstAidTitle,
    required this.firstAidSubtitle,
    required this.hospitalsTitle,
    required this.hospitalsSubtitle,
    required this.historyTitle,
    required this.historySubtitle,
    required this.safetyTitle,
    required this.safetySubtitle,
    required this.onFirstAidTap,
    required this.onHospitalsTap,
    required this.onHistoryTap,
    required this.onSafetyTap,
  });

  final String firstAidTitle;
  final String firstAidSubtitle;
  final String hospitalsTitle;
  final String hospitalsSubtitle;
  final String historyTitle;
  final String historySubtitle;
  final String safetyTitle;
  final String safetySubtitle;
  final VoidCallback onFirstAidTap;
  final VoidCallback onHospitalsTap;
  final VoidCallback onHistoryTap;
  final VoidCallback onSafetyTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appThemeTokens;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InfoCard(
                title: firstAidTitle,
                subtitle: firstAidSubtitle,
                icon: Icons.medical_services_outlined,
                iconColor: tokens.success,
                onTap: onFirstAidTap,
              ),
            ),
            SizedBox(width: AppSpacing.sm.w),
            Expanded(
              child: InfoCard(
                title: hospitalsTitle,
                subtitle: hospitalsSubtitle,
                icon: Icons.local_hospital_outlined,
                iconColor: tokens.info,
                onTap: onHospitalsTap,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm.h),
        Row(
          children: [
            Expanded(
              child: InfoCard(
                title: historyTitle,
                subtitle: historySubtitle,
                icon: Icons.history,
                iconColor: Theme.of(context).colorScheme.primary,
                onTap: onHistoryTap,
              ),
            ),
            SizedBox(width: AppSpacing.sm.w),
            Expanded(
              child: InfoCard(
                title: safetyTitle,
                subtitle: safetySubtitle,
                icon: Icons.lightbulb_outline,
                iconColor: tokens.warning,
                onTap: onSafetyTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
