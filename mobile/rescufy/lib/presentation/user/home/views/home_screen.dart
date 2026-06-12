import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/core/navigation/app_routes.dart';
import 'package:rescufy/core/theme/app_spacing.dart';
import 'package:rescufy/core/theme/app_theme_tokens.dart';
import 'package:rescufy/l10n/app_localizations.dart';
import 'package:rescufy/presentation/auth/cubit/auth/auth_cubit.dart';
import 'package:rescufy/presentation/auth/cubit/auth/auth_state.dart';
import 'package:rescufy/shared/widgets/common/app_screen_header.dart';

import '../widgets/emergency_option_card.dart';
import '../widgets/home_hotline_banner.dart';
import '../widgets/home_quick_access_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.showBottomNavigationBar = true});

  final bool showBottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthCubit>().state;
    final username = switch (authState) {
      AuthAuthenticated(:final user) when user.username.trim().isNotEmpty =>
        user.username.trim(),
      AuthAuthenticated(:final user) when user.name.trim().isNotEmpty =>
        user.name.trim(),
      _ => 'User',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          SizedBox(width: AppSpacing.xs.w),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: tokens.heroGradient),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HomeHeroPanel(
                title: l10n.helloUser(username),
                subtitle: l10n.howCanWeHelp,
                label: l10n.emergencyServices,
              ),
              SizedBox(height: AppSpacing.xxl.h),
              _SectionHeader(
                title: l10n.emergencyServices,
                icon: Icons.emergency_share_outlined,
                color: theme.colorScheme.primary,
              ),
              SizedBox(height: AppSpacing.md.h),
              EmergencyOptionCard(
                title: l10n.requestAmbulance,
                subtitle: l10n.forMyselfOrFamily,
                icon: Icons.local_hospital,
                color: theme.colorScheme.primary,
                onTap: () =>
                    _navigateToEmergencyForm(context, isSelfCase: true),
              ),
              SizedBox(height: AppSpacing.sm.h),
              EmergencyOptionCard(
                title: l10n.reportEmergency,
                subtitle: l10n.witnessingEmergency,
                icon: Icons.warning_amber_rounded,
                color: tokens.warning,
                onTap: () =>
                    _navigateToEmergencyForm(context, isSelfCase: false),
              ),
              SizedBox(height: AppSpacing.xxl.h),
              _SectionHeader(
                title: l10n.quickAccess,
                icon: Icons.dashboard_customize_outlined,
                color: tokens.info,
              ),
              SizedBox(height: AppSpacing.md.h),
              HomeQuickAccessGrid(
                firstAidTitle: l10n.firstAid,
                firstAidSubtitle: l10n.quickGuides,
                hospitalsTitle: l10n.hospitals,
                hospitalsSubtitle: l10n.findNearby,
                historyTitle: l10n.history,
                historySubtitle: l10n.pastRequests,
                safetyTitle: l10n.safetyTips,
                safetySubtitle: l10n.stayPrepared,
                onFirstAidTap: () => _showFirstAidGuide(context),
                onHospitalsTap: () => _showNearbyHospitals(context),
                onHistoryTap: () => _navigateToHistory(context),
                onSafetyTap: () => _showEmergencyTips(context),
              ),
              SizedBox(height: AppSpacing.xxl.h),
              HomeHotlineBanner(
                title: l10n.emergencyHotline,
                subtitle: l10n.support24_7,
              ),
              SizedBox(height: AppSpacing.lg.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: showBottomNavigationBar
          ? _buildBottomNavigationBar(context)
          : null,
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: AppLocalizations.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.local_hospital_outlined),
          activeIcon: const Icon(Icons.local_hospital),
          label: AppLocalizations.of(context)!.hospitals,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.history_outlined),
          activeIcon: const Icon(Icons.history),
          label: AppLocalizations.of(context)!.history,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline),
          activeIcon: const Icon(Icons.person),
          label: AppLocalizations.of(context)!.profile,
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 1:
            _navigateToHospitals(context);
            break;
          case 2:
            _navigateToHistory(context);
            break;
          case 3:
            _navigateToProfile(context);
            break;
          case 0:
            break;
        }
      },
    );
  }

  void _navigateToEmergencyForm(
    BuildContext context, {
    required bool isSelfCase,
  }) {
    Navigator.pushNamed(
      context,
      AppRoutes.emergencyForm,
      arguments: isSelfCase,
    );
  }

  void _showFirstAidGuide(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.medical_services, color: theme.colorScheme.primary),
            SizedBox(width: AppSpacing.xs.w),
            Text(l10n.firstAidGuide),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFirstAidStep(
                context,
                '1',
                l10n.checkSceneSafety,
                tokens.success,
              ),
              _buildFirstAidStep(
                context,
                '2',
                l10n.callEmergencyServices,
                tokens.success,
              ),
              _buildFirstAidStep(
                context,
                '3',
                l10n.checkResponsiveness,
                tokens.success,
              ),
              _buildFirstAidStep(context, '4', l10n.performCPR, tokens.success),
              _buildFirstAidStep(
                context,
                '5',
                l10n.stopBleeding,
                tokens.success,
              ),
              _buildFirstAidStep(
                context,
                '6',
                l10n.keepPersonWarm,
                tokens.success,
              ),
              _buildFirstAidStep(
                context,
                '7',
                l10n.monitorUntilHelp,
                tokens.success,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstAidStep(
    BuildContext context,
    String number,
    String text,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.w,
            height: 28.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: color,
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }

  void _showNearbyHospitals(BuildContext context) {
    _navigateToHospitals(context);
  }

  Widget _buildSafetyTip(BuildContext context, String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadii.sm.r),
            ),
            child: Icon(Icons.check_rounded, color: color, size: 16.sp),
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencyTips(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lightbulb, color: theme.colorScheme.primary),
            SizedBox(width: AppSpacing.xs.w),
            Text(l10n.safetyTips),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSafetyTip(context, l10n.safetyTip1, tokens.warning),
              _buildSafetyTip(context, l10n.safetyTip2, tokens.warning),
              _buildSafetyTip(context, l10n.safetyTip3, tokens.warning),
              _buildSafetyTip(context, l10n.safetyTip4, tokens.warning),
              _buildSafetyTip(context, l10n.safetyTip5, tokens.warning),
              _buildSafetyTip(context, l10n.safetyTip6, tokens.warning),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.userHistory);
  }

  void _navigateToHospitals(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.userHospitals);
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.userProfile);
  }
}

class _HomeHeroPanel extends StatelessWidget {
  const _HomeHeroPanel({
    required this.title,
    required this.subtitle,
    required this.label,
  });

  final String title;
  final String subtitle;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: tokens.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadii.lg.r),
        border: Border.all(color: tokens.outlineSoft),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.06),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: AppScreenHeader(
        title: title,
        subtitle: subtitle,
        trailing: Semantics(
          label: label,
          child: Container(
            constraints: BoxConstraints(maxWidth: 132.w),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm.w,
              vertical: AppSpacing.xs.h,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadii.pill.r),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 14.sp,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;

    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadii.sm.r),
            border: Border.all(color: color.withValues(alpha: 0.16)),
          ),
          child: Icon(icon, color: color, size: 18.sp),
        ),
        SizedBox(width: AppSpacing.sm.w),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          width: 44.w,
          height: 1,
          decoration: BoxDecoration(
            color: tokens.outlineSoft,
            borderRadius: BorderRadius.circular(AppRadii.pill.r),
          ),
        ),
      ],
    );
  }
}
