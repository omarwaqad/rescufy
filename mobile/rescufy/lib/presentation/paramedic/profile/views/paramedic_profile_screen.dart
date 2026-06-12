import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/core/cubit/theme/theme_cubit.dart';
import 'package:rescufy/core/cubit/theme/theme_state.dart';
import 'package:rescufy/core/di/injection_container.dart' as di;
import 'package:rescufy/core/navigation/app_routes.dart';
import 'package:rescufy/core/theme/app_spacing.dart';
import 'package:rescufy/core/theme/app_theme_tokens.dart';
import 'package:rescufy/domain/entities/paramedic_profile.dart';
import 'package:rescufy/presentation/auth/cubit/auth/auth_cubit.dart';
import 'package:rescufy/presentation/auth/cubit/auth/auth_state.dart';
import 'package:rescufy/presentation/paramedic/profile/cubit/paramedic_profile_cubit.dart';
import 'package:rescufy/presentation/paramedic/profile/cubit/paramedic_profile_state.dart';

class ParamedicProfileScreen extends StatelessWidget {
  const ParamedicProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: _ThemeToggleAction(),
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => di.sl<ParamedicProfileCubit>()..loadProfile(),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                state.route,
                (route) => false,
              );
              return;
            }

            if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
            }
          },
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: tokens.heroGradient),
            child: SafeArea(
              child: BlocBuilder<ParamedicProfileCubit, ParamedicProfileState>(
                builder: (context, state) {
                  return RefreshIndicator(
                    onRefresh: context.read<ParamedicProfileCubit>().refresh,
                    child: _ProfileContent(
                      profile: state.profile,
                      roleLabel: state.roleLabel,
                      isLoading:
                          state.status == ParamedicProfileStatus.loading,
                      errorMessage: state.status == ParamedicProfileStatus.error
                          ? state.errorMessage
                          : null,
                      onRetry: () =>
                          context.read<ParamedicProfileCubit>().loadProfile(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IdentitySection extends StatelessWidget {
  const _IdentitySection({
    required this.profile,
    required this.roleLabel,
    required this.isLoading,
  });

  final ParamedicProfile? profile;
  final String roleLabel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = profile?.displayName.trim() ?? '';

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.xl.h,
        ),
        child: Column(
          children: [
            Semantics(
              label: displayName.isNotEmpty
                  ? '$displayName profile avatar'
                  : 'Profile avatar',
              child: Container(
                width: 96.w,
                height: 96.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: context.appThemeTokens.emergencyGradient,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 4.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_outline,
                  color: theme.colorScheme.onPrimary,
                  size: 46.sp,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            if (isLoading)
              _SkeletonBlock(width: 170.w, height: 22.h)
            else if (displayName.isNotEmpty)
              Text(
                displayName,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            SizedBox(height: AppSpacing.sm.h),
            _StatusBadge(
              label: roleLabel,
              variant: roleLabel == 'Ambulance Driver'
                  ? _BadgeVariant.info
                  : _BadgeVariant.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _AmbulanceInformationCard extends StatelessWidget {
  const _AmbulanceInformationCard({
    required this.profile,
    required this.isLoading,
  });

  final ParamedicProfile? profile;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return _ProfileSectionCard(
      title: 'Ambulance Information',
      icon: Icons.local_shipping_outlined,
      accent: _ProfileAccent.info,
      children: [
        if (isLoading) ...const [
          _SkeletonInfoRow(label: 'Ambulance Number'),
          _SkeletonInfoRow(label: 'Vehicle Information'),
          _SkeletonInfoRow(label: 'Ambulance Status'),
        ] else ...[
          if (_hasText(profile?.ambulanceNumber))
            _InfoRow(
              label: 'Ambulance Number',
              value: profile!.ambulanceNumber,
            ),
          if (_hasText(profile?.vehicleInfo))
            _InfoRow(label: 'Vehicle Information', value: profile!.vehicleInfo),
          if (_hasText(profile?.ambulanceStatus))
            _InfoRow(
              label: 'Ambulance Status',
              trailing: _StatusBadge(
                label: profile!.ambulanceStatus!,
                variant: _badgeVariantFromStatus(profile!.ambulanceStatus!),
              ),
            ),
        ],
      ],
    );
  }
}

class _DriverInformationCard extends StatelessWidget {
  const _DriverInformationCard({
    required this.profile,
    required this.isLoading,
  });

  final ParamedicProfile? profile;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return _ProfileSectionCard(
      title: 'Driver Information',
      icon: Icons.badge_outlined,
      accent: _ProfileAccent.primary,
      children: [
        if (isLoading) ...const [
          _SkeletonInfoRow(label: 'Driver Name'),
          _SkeletonInfoRow(label: 'Driver Phone'),
        ] else ...[
          if (_hasText(profile?.driverName))
            _InfoRow(label: 'Driver Name', value: profile!.driverName),
          if (_hasText(profile?.driverPhone))
            _InfoRow(label: 'Driver Phone', value: profile!.driverPhone),
        ],
      ],
    );
  }
}

class _AccountStatusCard extends StatelessWidget {
  const _AccountStatusCard({required this.status, required this.isLoading});

  final String? status;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return _ProfileSectionCard(
      title: 'Account Status',
      icon: Icons.verified_user_outlined,
      accent: _ProfileAccent.success,
      children: [
        if (isLoading)
          const _SkeletonInfoRow(label: 'Status')
        else if (_hasText(status))
          _InfoRow(
            label: 'Status',
            trailing: _StatusBadge(
              label: status!,
              variant: status == 'Active'
                  ? _BadgeVariant.success
                  : _BadgeVariant.warning,
            ),
          ),
      ],
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.profile,
    required this.roleLabel,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
  });

  final ParamedicProfile? profile;
  final String roleLabel;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final hasError = _hasText(errorMessage);
    final status = profile == null
        ? null
        : profile!.isActive
        ? 'Active'
        : 'Inactive';

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg.w,
        AppSpacing.lg.h,
        AppSpacing.lg.w,
        AppSpacing.xl.h,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _IdentitySection(
                profile: profile,
                roleLabel: roleLabel,
                isLoading: isLoading,
              ),
              if (hasError) ...[
                SizedBox(height: AppSpacing.md.h),
                _InlineErrorCard(message: errorMessage!, onRetry: onRetry),
              ],
              SizedBox(height: AppSpacing.md.h),
              _AmbulanceInformationCard(
                profile: profile,
                isLoading: isLoading,
              ),
              SizedBox(height: AppSpacing.md.h),
              _DriverInformationCard(profile: profile, isLoading: isLoading),
              SizedBox(height: AppSpacing.md.h),
              _AccountStatusCard(status: status, isLoading: isLoading),
              SizedBox(height: AppSpacing.md.h),
              const _SettingsSection(),
              SizedBox(height: AppSpacing.xl.h),
              const _LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineErrorCard extends StatelessWidget {
  const _InlineErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.error,
              size: 22.sp,
            ),
            SizedBox(width: AppSpacing.sm.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile could not refresh',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonInfoRow extends StatelessWidget {
  const _SkeletonInfoRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          flex: 6,
          child: Align(
            alignment: Alignment.centerRight,
            child: _SkeletonBlock(width: 120.w, height: 18.h),
          ),
        ),
      ],
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appThemeTokens;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: tokens.surfaceMuted.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadii.sm.r),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection();

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final language = locale.languageCode == 'ar' ? 'Arabic' : 'English';

    return _ProfileSectionCard(
      title: 'Settings',
      icon: Icons.tune_outlined,
      accent: _ProfileAccent.warning,
      children: [
        const _ThemeSettingRow(),
        _SettingsRow(
          icon: Icons.language_outlined,
          label: 'Language',
          value: language,
          onTap: () => Navigator.pushNamed(context, AppRoutes.language),
        ),
      ],
    );
  }
}

class _ThemeToggleAction extends StatelessWidget {
  const _ThemeToggleAction();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;

        return Semantics(
          label: 'Theme toggle',
          toggled: isDark,
          child: Switch.adaptive(
            value: isDark,
            activeThumbColor: theme.colorScheme.primary,
            onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
          ),
        );
      },
    );
  }
}

class _ThemeSettingRow extends StatelessWidget {
  const _ThemeSettingRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;

        return _SettingsRow(
          icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
          label: 'Theme',
          value: isDark ? 'Dark' : 'Light',
          trailing: Switch.adaptive(
            value: isDark,
            onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
          ),
        );
      },
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  const _ProfileSectionCard({
    required this.title,
    required this.icon,
    required this.accent,
    required this.children,
  });

  final String title;
  final IconData icon;
  final _ProfileAccent accent;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = _accentColor(context, accent);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadii.sm.r),
                  ),
                  child: Icon(icon, color: accentColor, size: 20.sp),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md.h),
            for (var index = 0; index < children.length; index++) ...[
              children[index],
              if (index < children.length - 1) const Divider(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, this.value, this.trailing})
    : assert(value != null || trailing != null);

  final String label;
  final String? value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          flex: 6,
          child: Align(
            alignment: Alignment.centerRight,
            child:
                trailing ??
                Text(
                  value!,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}

bool _hasText(String? value) {
  return value?.trim().isNotEmpty ?? false;
}

_BadgeVariant _badgeVariantFromStatus(String status) {
  final normalizedStatus = status.trim().toLowerCase();

  if (normalizedStatus == 'available' ||
      normalizedStatus == 'active' ||
      normalizedStatus == 'online') {
    return _BadgeVariant.success;
  }

  if (normalizedStatus == 'inactive' ||
      normalizedStatus == 'unavailable' ||
      normalizedStatus == 'offline') {
    return _BadgeVariant.warning;
  }

  return _BadgeVariant.info;
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.sm.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xs.h),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: tokens.surfaceMuted.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(AppRadii.sm.r),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 19.sp),
            ),
            SizedBox(width: AppSpacing.sm.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
                size: 22.sp,
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.variant});

  final String label;
  final _BadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (variant) {
      _BadgeVariant.primary => theme.colorScheme.primary,
      _BadgeVariant.info => context.appThemeTokens.info,
      _BadgeVariant.success => context.appThemeTokens.success,
      _BadgeVariant.warning => context.appThemeTokens.warning,
      _BadgeVariant.error => theme.colorScheme.error,
    };

    return Semantics(
      label: label,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadii.pill.r),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout_outlined),
        label: const Text('Logout'),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.error,
          side: BorderSide(color: theme.colorScheme.error),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AuthCubit>().logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

Color _accentColor(BuildContext context, _ProfileAccent accent) {
  final theme = Theme.of(context);
  final tokens = context.appThemeTokens;

  return switch (accent) {
    _ProfileAccent.primary => theme.colorScheme.primary,
    _ProfileAccent.info => tokens.info,
    _ProfileAccent.success => tokens.success,
    _ProfileAccent.warning => tokens.warning,
    _ProfileAccent.error => theme.colorScheme.error,
  };
}

enum _ProfileAccent { primary, info, success, warning, error }

enum _BadgeVariant { primary, info, success, warning, error }
