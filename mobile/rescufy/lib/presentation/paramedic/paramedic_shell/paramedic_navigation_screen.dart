import 'package:flutter/material.dart';
import '../dashboard/views/dashboard_screen.dart';
import '../history/views/history_screen.dart';
import '../profile/views/paramedic_profile_screen.dart';

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
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF2A3142), width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF1A1F2E),
          indicatorColor: const Color(0xFF00D9A5).withOpacity(0.2),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, color: Colors.white70),
              selectedIcon: Icon(Icons.dashboard, color: Color(0xFF00D9A5)),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined, color: Colors.white70),
              selectedIcon: Icon(Icons.history, color: Color(0xFF00D9A5)),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.white70),
              selectedIcon: Icon(Icons.person, color: Color(0xFF00D9A5)),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
