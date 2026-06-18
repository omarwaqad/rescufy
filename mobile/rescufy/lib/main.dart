// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/cubit/locale/locale_cubit.dart';
import 'package:rescufy/core/cubit/theme/theme_cubit.dart';
import 'package:rescufy/core/di/injection_container.dart' as di;
import 'package:rescufy/core/navigation/app_router.dart';
import 'package:rescufy/core/theme/app_theme.dart';
import 'package:rescufy/presentation/auth/cubit/auth/auth_cubit.dart';
import 'package:rescufy/presentation/shared/notifications/cubit/notification_cubit.dart';
import 'package:rescufy/rescufy_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RescufyBootstrapApp());
}

class RescufyBootstrapApp extends StatefulWidget {
  const RescufyBootstrapApp({super.key});

  @override
  State<RescufyBootstrapApp> createState() => _RescufyBootstrapAppState();
}

class _RescufyBootstrapAppState extends State<RescufyBootstrapApp> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _StartupLoadingApp();
        }

        if (snapshot.hasError) {
          return _StartupErrorApp(
            onRetry: () {
              setState(() {
                _initFuture = _initializeDependencies();
              });
            },
          );
        }

        return const RescufyRoot();
      },
    );
  }

  Future<void> _initializeDependencies() {
    return di.init().timeout(const Duration(seconds: 20));
  }
}

class RescufyRoot extends StatelessWidget {
  const RescufyRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
        BlocProvider(create: (_) => di.sl<LocaleCubit>()),
        BlocProvider(create: (_) => di.sl<AuthCubit>()),
        BlocProvider(
          create: (_) => di.sl<NotificationCubit>()..loadUnreadCount(),
        ),
      ],
      child: RescufyApp(appRouter: AppRouter()),
    );
  }
}

class _StartupLoadingApp extends StatelessWidget {
  const _StartupLoadingApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 40),
                const SizedBox(height: 16),
                const Text('App startup failed', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
