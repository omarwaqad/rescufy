import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rescufy/core/theme/app_spacing.dart';
import 'package:rescufy/core/theme/app_theme_tokens.dart';
import 'package:rescufy/shared/widgets/common/app_tonal_icon.dart';

class EmergencyOptionCard extends StatelessWidget {
  const EmergencyOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          decoration: BoxDecoration(
            color: tokens.surfaceRaised,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: color.withValues(alpha: 0.14),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              AppTonalIcon(icon: icon, color: color, size: 56, iconSize: 28),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(subtitle, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: color.withValues(alpha: 0.5),
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
