import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/di/injection_container.dart' as di;
import 'package:rescufy/presentation/paramedic/dashboard/cubit/dashboard_cubit.dart';
import 'package:rescufy/presentation/paramedic/dashboard/views/dashboard_screen.dart';
import 'package:rescufy/presentation/paramedic/history/views/history_screen.dart';
import 'package:rescufy/presentation/paramedic/profile/views/paramedic_profile_screen.dart';
import 'package:rescufy/shared/widgets/navigation/app_navigation_shell.dart';

class ParamedicNavigationScreen extends StatefulWidget {
  const ParamedicNavigationScreen({super.key});

  @override
  State<ParamedicNavigationScreen> createState() =>
      _ParamedicNavigationScreenState();
}

class _ParamedicNavigationScreenState extends State<ParamedicNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    HistoryScreen(),
    ParamedicProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<DashboardCubit>(),
      child: AppNavigationShell(
        currentIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        screens: _screens,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
