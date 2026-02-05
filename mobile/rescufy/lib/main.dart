// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/theme/app_theme.dart';
import 'package:rescufy/core/navigation/app_routes.dart';

import 'package:rescufy/core/di/injection_container.dart' as di;

// Screens
import 'package:rescufy/presentation/screens/splash_screen.dart';
import 'package:rescufy/presentation/features/home/views/home_screen.dart';
import 'package:rescufy/presentation/features/auth/views/login_screen.dart';
import 'package:rescufy/presentation/features/auth/views/signup_screen.dart';
import 'package:rescufy/presentation/features/request/views/emergency_form_screen.dart';
import 'package:rescufy/presentation/features/request/views/request_history_screen.dart';
import 'package:rescufy/presentation/features/profile/views/profile_screen.dart';

// Cubits
import 'package:rescufy/presentation/features/auth/cubit/login_cubit.dart';
import 'package:rescufy/domain/usecases/login_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  runApp(const RescufyApp());
}

class RescufyApp extends StatelessWidget {
  const RescufyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rescufy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,

      // Route generator for better control
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.splash:
            return MaterialPageRoute(builder: (_) => const SplashScreen());

          case AppRoutes.login:
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => LoginCubit(di.sl<LoginUseCase>()),
                child: const LoginScreen(),
              ),
            );

          case '/signup':
            return MaterialPageRoute(builder: (_) => const SignupScreen());

          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());

          case '/emergency-form':
            final args = settings.arguments;
            final isSelfCase = args is bool ? args : true;
            return MaterialPageRoute(
              builder: (_) => EmergencyFormScreen(isSelfCase: isSelfCase),
            );

          case '/history':
            return MaterialPageRoute(
              builder: (_) => const RequestHistoryScreen(),
            );

          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());

          default:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
      },

      // Fallback for unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      },
    );
  }
}
