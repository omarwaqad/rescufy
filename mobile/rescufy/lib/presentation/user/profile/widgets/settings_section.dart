// lib/presentation/features/profile/widgets/settings_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsSection extends StatelessWidget {
  final VoidCallback onNotificationsTap;
  final VoidCallback onLanguageTap;
  final VoidCallback onPrivacyTap;
  final VoidCallback onHelpTap;

  const SettingsSection({
    super.key,
    required this.onNotificationsTap,
    required this.onLanguageTap,
    required this.onPrivacyTap,
    required this.onHelpTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Column(
        children: [
          _SettingItem(
            theme: theme,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage alerts',
            onTap: onNotificationsTap,
          ),
          Divider(height: 1.h),
          _SettingItem(
            theme: theme,
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English (US)',
            onTap: onLanguageTap,
          ),
          Divider(height: 1.h),
          _SettingItem(
            theme: theme,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy & Security',
            subtitle: 'Manage your data',
            onTap: onPrivacyTap,
          ),
          Divider(height: 1.h),
          _SettingItem(
            theme: theme,
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'FAQ, contact us',
            onTap: onHelpTap,
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final ThemeData theme;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingItem({
    required this.theme,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title, style: theme.textTheme.titleSmall),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
