import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/core/theme/app_text_styles.dart';
import 'package:rescufy/core/theme/colors.dart';
import 'package:rescufy/l10n/app_localizations.dart';
import 'package:rescufy/presentation/shared/notifications/cubit/notification_cubit.dart';
import 'package:rescufy/presentation/shared/notifications/cubit/notification_state.dart';
import 'package:rescufy/presentation/shared/notifications/widgets/notification_empty_state.dart';
import 'package:rescufy/presentation/shared/notifications/widgets/notification_error_banner.dart';
import 'package:rescufy/presentation/shared/notifications/widgets/notification_list_item.dart';
import 'package:rescufy/presentation/shared/notifications/widgets/notification_message_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColorsDark.background : AppColors.background,
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => context.read<NotificationCubit>().refresh(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 120.h,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppColors.primary,
                  leading: showBackButton
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        )
                      : null,
                  actions: [
                    if (state.items.any((n) => !n.isRead))
                      TextButton(
                        onPressed: () =>
                            context.read<NotificationCubit>().markAllAsRead(),
                        child: Text(
                          l10n.markAllAsRead,
                          style: AppTextStyles.labelLarge(Colors.white),
                        ),
                      ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      l10n.notifications,
                      style: AppTextStyles.headlineMedium(
                        Colors.white,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primaryDark, AppColors.primary],
                        ),
                      ),
                    ),
                  ),
                ),
                ..._buildContentSlivers(
                  context: context,
                  state: state,
                  isDark: isDark,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildContentSlivers({
    required BuildContext context,
    required NotificationState state,
    required bool isDark,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    final l10n = AppLocalizations.of(context)!;

    if (state.status == NotificationStatus.loading && state.items.isEmpty) {
      return const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (state.status == NotificationStatus.error && state.items.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: NotificationMessageState(
            icon: Icons.notifications_off_outlined,
            title: l10n.notificationsLoadFailed,
            subtitle: state.errorMessage ?? l10n.notificationsLoadFailed,
            buttonLabel: l10n.retry,
            onPressed: () =>
                context.read<NotificationCubit>().loadNotifications(),
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
        ),
      ];
    }

    if (state.status == NotificationStatus.empty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: NotificationEmptyState(
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final notification = state.items[index];
            return NotificationListItem(
              notification: notification,
              isDark: isDark,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              onTap: () {
                if (!notification.isRead) {
                  context.read<NotificationCubit>().markAsRead(notification.id);
                }
              },
              onDelete: () => context
                  .read<NotificationCubit>()
                  .deleteNotification(notification.id),
            );
          }, childCount: state.items.length),
        ),
      ),
      if (state.errorMessage != null && state.items.isNotEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
            child: NotificationErrorBanner(
              message: state.errorMessage!,
              onRetry: () => context.read<NotificationCubit>().refresh(),
            ),
          ),
        ),
      SliverToBoxAdapter(child: SizedBox(height: 20.h)),
    ];
  }
}
