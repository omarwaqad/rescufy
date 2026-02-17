// lib/presentation/features/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/core/navigation/app_routes.dart';
import 'package:rescufy/presentation/onboarding/widgets/background_and_text.dart';
import 'package:rescufy/presentation/onboarding/widgets/rescufy_logo_and_name.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Uses theme's scaffold background color (auto switches for dark mode)
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            children: [
              // Logo and Name at top
              const RescufyLogoAndName(),

              SizedBox(height: 20.h),

              // Background image and text
              const Expanded(child: BackgroundAndText()),

              SizedBox(height: 24.h),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  // ✅ Uses theme's primary button style (defined in app_theme.dart)
                  child: Text(
                    'Get Started',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
