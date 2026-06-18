import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/di/injection_container.dart' as di;
import 'package:rescufy/l10n/app_localizations.dart';
import 'package:rescufy/presentation/paramedic/dashboard/cubit/dashboard_cubit.dart';
import 'package:rescufy/presentation/paramedic/dashboard/views/dashboard_screen.dart';
import 'package:rescufy/presentation/paramedic/history/views/history_screen.dart';
import 'package:rescufy/presentation/paramedic/profile/views/paramedic_profile_screen.dart';
import 'package:rescufy/presentation/shared/notifications/cubit/notification_cubit.dart';
import 'package:rescufy/presentation/shared/notifications/views/notifications_screen.dart';
import 'package:rescufy/shared/widgets/navigation/app_navigation_shell.dart';

class ParamedicNavigationScreen extends StatefulWidget {
  const ParamedicNavigationScreen({super.key});

  @override
  State<ParamedicNavigationScreen> createState() =>
      _ParamedicNavigationScreenState();
}

class _ParamedicNavigationScreenState extends State<ParamedicNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const HistoryScreen(),
    const NotificationsScreen(showBackButton: false),
    const ParamedicProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<DashboardCubit>()),
        BlocProvider.value(value: di.sl<NotificationCubit>()),
      ],
      child: AppNavigationShell(
        currentIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        screens: _screens,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n.history,
          ),
          NavigationDestination(
            icon: const Icon(Icons.notifications_outlined),
            selectedIcon: const Icon(Icons.notifications),
            label: l10n.notifications,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}
