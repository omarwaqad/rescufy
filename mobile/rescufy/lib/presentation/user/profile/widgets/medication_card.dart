// lib/presentation/user/profile/widgets/medication_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicationCard extends StatelessWidget {
  final Map<String, String> medication;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MedicationCard({
    super.key,
    required this.medication,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medication,
                size: 20.sp,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  medication['name']!,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _CardActions(onEdit: onEdit, onDelete: onDelete),
            ],
          ),
          SizedBox(height: 8.h),
          _DetailRow(
            theme: theme,
            label: 'Dosage',
            value: medication['dosage']!,
          ),
          _DetailRow(
            theme: theme,
            label: 'Frequency',
            value: medication['frequency']!,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final ThemeData theme;
  final String label;
  final String value;

  const _DetailRow({
    required this.theme,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _CardActions extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _CardActions({this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.edit_outlined,
                size: 18.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        if (onDelete != null)
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.delete_outline,
                size: 18.sp,
                color: Colors.red.shade300,
              ),
            ),
          ),
      ],
    );
  }
}
