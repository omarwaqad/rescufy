// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/cubit/theme/theme_cubit.dart';

import 'package:rescufy/core/di/injection_container.dart' as di;
import 'package:rescufy/core/navigation/app_router.dart';

import 'package:rescufy/rescufy_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  runApp(
    BlocProvider(
      create: (_) => di.sl<ThemeCubit>(),
      child: RescufyApp(appRouter: AppRouter()),
    ),
  );
}
