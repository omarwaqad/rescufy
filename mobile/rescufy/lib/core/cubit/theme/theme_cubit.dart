// lib/presentation/core/cubit/theme/theme_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light));

  void toggleTheme() {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(ThemeState(themeMode: newMode));
    // TODO: Save to local storage
  }

  void setTheme(ThemeMode mode) {
    emit(ThemeState(themeMode: mode));
    // TODO: Save to local storage
  }

  bool get isDarkMode => state.themeMode == ThemeMode.dark;
}
