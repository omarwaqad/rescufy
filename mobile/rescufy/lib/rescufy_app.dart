// lib/rescufy_app.dart
import 'package:flutter/material.dart';
import 'package:rescufy/core/navigation/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/core/cubit/theme/theme_cubit.dart';
import 'package:rescufy/core/cubit/theme/theme_state.dart';

class RescufyApp extends StatelessWidget {
  const RescufyApp({super.key, required AppRouter appRouter});
  @override
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Rescufy',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode, // 🔥 IMPORTANT
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter().generateRoute,
          );
        },
      ),
    );
  }
}
