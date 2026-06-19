import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/core/theme/app_text_styles.dart';
import 'package:rescufy/core/theme/colors.dart';

class NotificationMessageState extends StatelessWidget {
  const NotificationMessageState({
    super.key,
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
