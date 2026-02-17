// lib/presentation/features/profile/widgets/medical_info_card.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicalInfoCard extends StatelessWidget {
  final String pregnancyStatus;
  final String medicalNotes;
  final VoidCallback onEditPressed;

  const MedicalInfoCard({
    super.key,
    required this.pregnancyStatus,
    required this.medicalNotes,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.medical_information,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Medical Information',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEditPressed,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _InfoRow(
              theme: theme,
              label: 'Pregnancy Status',
              value: pregnancyStatus,
            ),
            _InfoRow(theme: theme, label: 'Medical Notes', value: medicalNotes),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final ThemeData theme;
  final String label;
  final String value;

  const _InfoRow({
    required this.theme,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
