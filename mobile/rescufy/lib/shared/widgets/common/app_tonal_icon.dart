import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rescufy/core/theme/app_spacing.dart';

class AppTonalIcon extends StatelessWidget {
  const AppTonalIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 48,
    this.iconSize = 24,
    this.shape = BoxShape.rectangle,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(AppRadii.sm.r)
            : null,
        shape: shape,
      ),
      child: Icon(icon, color: color, size: iconSize.sp),
    );
  }
}
