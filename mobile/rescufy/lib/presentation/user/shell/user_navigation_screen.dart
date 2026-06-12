import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/di/injection_container.dart' as di;
import 'package:rescufy/l10n/app_localizations.dart';
import 'package:rescufy/presentation/user/hospitals/cubit/hospitals_cubit.dart';
import 'package:rescufy/presentation/user/hospitals/views/hospitals_screen.dart';
import 'package:rescufy/presentation/user/history/views/request_history_screen.dart';
import 'package:rescufy/presentation/user/history/cubit/request_history_cubit.dart';
import 'package:rescufy/presentation/user/home/views/home_screen.dart';
import 'package:rescufy/presentation/user/profile/cubit/profile_cubit.dart';
import 'package:rescufy/presentation/user/profile/views/profile_screen.dart';
import 'package:rescufy/shared/widgets/navigation/app_navigation_shell.dart';

class UserNavigationScreen extends StatefulWidget {
  const UserNavigationScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<UserNavigationScreen> createState() => _UserNavigationScreenState();
}

class _UserNavigationScreenState extends State<UserNavigationScreen> {
  late int _currentIndex;
  late final HospitalsCubit _hospitalsCubit;
  late final RequestHistoryCubit _requestHistoryCubit;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 3);
    _hospitalsCubit = di.sl<HospitalsCubit>()..loadNearbyHospitals();
    _requestHistoryCubit = di.sl<RequestHistoryCubit>()..loadRequestHistory();
  }

  @override
  void dispose() {
    _hospitalsCubit.close();
    _requestHistoryCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ProfileCubit>()),
        BlocProvider.value(value: _hospitalsCubit),
        BlocProvider.value(value: _requestHistoryCubit),
      ],
      child: AppNavigationShell(
        currentIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        screens: const [
          HomeScreen(showBottomNavigationBar: false),
          HospitalsScreen(),
          RequestHistoryScreen(showBackButton: false),
          ProfileScreen(),
        ],
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_hospital_outlined),
            selectedIcon: const Icon(Icons.local_hospital),
            label: l10n.hospitals,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n.history,
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
