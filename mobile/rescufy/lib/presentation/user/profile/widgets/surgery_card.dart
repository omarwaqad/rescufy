// lib/presentation/user/profile/widgets/surgery_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurgeryCard extends StatelessWidget {
  final Map<String, String> surgery;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SurgeryCard({
    super.key,
    required this.surgery,
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
        color: Colors.teal.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.teal.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.healing, size: 20.sp, color: Colors.teal),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  surgery['name']!,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                surgery['year']!,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4.w),
              _CardActions(onEdit: onEdit, onDelete: onDelete),
            ],
          ),
          if (surgery['notes']!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(surgery['notes']!, style: theme.textTheme.bodySmall),
          ],
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
