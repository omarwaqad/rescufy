// lib/presentation/user/home/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/core/navigation/app_routes.dart';
import '../widgets/emergency_option_card.dart';
import '../widgets/info_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rescufy'),
        actions: [
          IconButton(
            icon: Badge(
              label: const Text('3'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Greeting
            Text(
              'Hello, Sara 👋',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 8.h),

            // Subtitle
            Text(
              'How can we help you today?',
              style: textTheme.bodyLarge?.copyWith(
                color: textTheme.bodySmall?.color,
              ),
            ),

            SizedBox(height: 28.h),

            // Emergency Actions Section
            Text(
              'Emergency Services',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 16.h),

            // Request Ambulance Card
            EmergencyOptionCard(
              title: 'Request Ambulance',
              subtitle: 'For myself or family member',
              icon: Icons.local_hospital,
              color: colorScheme.primary,
              onTap: () {
                _navigateToEmergencyForm(context, isSelfCase: true);
              },
            ),

            SizedBox(height: 12.h),

            // Report Someone Else Card
            EmergencyOptionCard(
              title: 'Report Emergency',
              subtitle: 'Witnessing an emergency situation',
              icon: Icons.warning_amber_rounded,
              color: const Color(0xFFF57C00), // Orange for urgency
              onTap: () {
                _navigateToEmergencyForm(context, isSelfCase: false);
              },
            ),

            SizedBox(height: 32.h),

            // Quick Access Section
            Text(
              'Quick Access',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 16.h),

            // Quick Access Grid
            _buildQuickAccessGrid(context, theme),

            SizedBox(height: 32.h),

            // Emergency Hotline Banner
            _buildHotlineBanner(theme, isDark),

            SizedBox(height: 20.h),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  // Quick Access Grid
  Widget _buildQuickAccessGrid(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InfoCard(
                title: 'First Aid',
                subtitle: 'Quick guides',
                icon: Icons.medical_services_outlined,
                iconColor: const Color(0xFF2E7D32),
                onTap: () => _showFirstAidGuide(context),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: InfoCard(
                title: 'Hospitals',
                subtitle: 'Find nearby',
                icon: Icons.local_hospital_outlined,
                iconColor: const Color(0xFF1976D2),
                onTap: () => _showNearbyHospitals(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: InfoCard(
                title: 'History',
                subtitle: 'Past requests',
                icon: Icons.history,
                iconColor: const Color(0xFF6A1B9A),
                onTap: () => _navigateToHistory(context),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: InfoCard(
                title: 'Safety Tips',
                subtitle: 'Stay prepared',
                icon: Icons.lightbulb_outline,
                iconColor: const Color(0xFFF57C00),
                onTap: () => _showEmergencyTips(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Emergency Hotline Banner
  Widget _buildHotlineBanner(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.primary.withOpacity(0.15)
            : theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.phone, color: Colors.white, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Hotline',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '24/7 Support • 123-456-7890',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: theme.colorScheme.primary,
            size: 18.sp,
          ),
        ],
      ),
    );
  }

  // Bottom Navigation Bar
  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          activeIcon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            break;
          case 1:
            _navigateToHistory(context);
            break;
          case 2:
            _navigateToProfile(context);
            break;
        }
      },
    );
  }

  // Navigation Methods
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.medical_services, color: theme.colorScheme.primary),
            SizedBox(width: 8.w),
            const Text('First Aid Guide'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFirstAidStep('1', 'Check the scene for safety', theme),
              _buildFirstAidStep('2', 'Call emergency services', theme),
              _buildFirstAidStep('3', 'Check responsiveness', theme),
              _buildFirstAidStep('4', 'Perform CPR if needed', theme),
              _buildFirstAidStep('5', 'Stop bleeding with pressure', theme),
              _buildFirstAidStep('6', 'Keep the person warm', theme),
              _buildFirstAidStep('7', 'Monitor until help arrives', theme),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstAidStep(String number, String text, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.w,
            height: 28.h,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(5.9),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
              color: const Color(0xFF2E7D32).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E7D32),
                  fontSize: 13,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }

  void _showNearbyHospitals(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.local_hospital, color: theme.colorScheme.primary),
            SizedBox(width: 8.w),
            const Text('Nearby Hospitals'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHospitalItem(
                'City General Hospital',
                '2.3 km',
                Icons.local_hospital,
              ),
              _buildHospitalItem(
                'Emergency Medical Center',
                '3.1 km',
                Icons.emergency,
              ),
              _buildHospitalItem(
                'Rescue Hospital',
                '4.5 km',
                Icons.medical_services,
              ),
              _buildHospitalItem('First Aid Clinic', '1.8 km', Icons.healing),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalItem(String name, String distance, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Icon(icon, size: 22.sp, color: const Color(0xFF1976D2)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 2.h),
                Text(
                  distance,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.directions, size: 20.sp, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  void _showEmergencyTips(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lightbulb, color: theme.colorScheme.primary),
            SizedBox(width: 8.w),
            const Text('Safety Tips'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• Stay calm and assess the situation'),
              SizedBox(height: 10),
              Text('• Call emergency services immediately'),
              SizedBox(height: 10),
              Text('• Provide clear location information'),
              SizedBox(height: 10),
              Text('• Follow dispatcher instructions'),
              SizedBox(height: 10),
              Text('• Keep emergency contacts accessible'),
              SizedBox(height: 10),
              Text('• Know your medical information'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userHistory);
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userProfile);
  }
}
