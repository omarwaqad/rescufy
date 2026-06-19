import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/core/navigation/app_routes.dart';
import 'package:rescufy/core/theme/colors.dart';
import 'package:rescufy/presentation/shared/notifications/cubit/notification_cubit.dart';
import 'package:rescufy/presentation/shared/notifications/cubit/notification_state.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key, this.color, this.size = 24});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final iconColor = color ?? Theme.of(context).colorScheme.onSurface;

    return BlocBuilder<NotificationCubit, NotificationState>(
      buildWhen: (previous, current) => previous.unreadCount != current.unreadCount,
      builder: (context, state) {
        final unreadCount = state.unreadCount;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: isLight
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border, width: 1),
                    )
                  : null,
              child: IconButton(
                icon: Icon(Icons.notifications_outlined, color: iconColor, size: size.sp),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
              ),
            ),
            if (unreadCount > 0)
              Positioned.directional(
                textDirection: Directionality.of(context),
                top: 6.h,
                end: 6.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: isLight
                        ? Border.all(color: Colors.white, width: 1.5)
                        : null,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16.w,
                    minHeight: 16.h,
                  ),
                  child: Center(
                    child: Text(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: unreadCount > 99 ? 8.sp : 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
