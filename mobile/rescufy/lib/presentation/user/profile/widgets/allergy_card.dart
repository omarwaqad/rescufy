// lib/presentation/features/profile/widgets/allergy_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllergyCard extends StatelessWidget {
  final Map<String, String> allergy;

  const AllergyCard({super.key, required this.allergy});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severityColor = allergy['severity'] == 'Severe'
        ? Colors.red
        : allergy['severity'] == 'Moderate'
        ? Colors.orange
        : Colors.yellow.shade700;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: severityColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: severityColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 20.sp,
                color: severityColor,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  allergy['name']!,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  allergy['severity']!,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: severityColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(allergy['notes']!, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
