// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'app_text_styles.dart';
import 'button_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Color Scheme
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        error: AppColors.error,
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: AppTextStyles.headlineMedium(
          Colors.white,
        ).copyWith(fontWeight: FontWeight.w600),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge(AppColors.textPrimary),
        displayMedium: AppTextStyles.displayMedium(AppColors.textPrimary),
        displaySmall: AppTextStyles.displaySmall(AppColors.textPrimary),
        headlineLarge: AppTextStyles.displaySmall(AppColors.textPrimary),
        headlineMedium: AppTextStyles.headlineMedium(AppColors.textPrimary),
        headlineSmall: AppTextStyles.headlineSmall(AppColors.textPrimary),
        titleLarge: AppTextStyles.labelLarge(
          AppColors.textPrimary,
        ).copyWith(fontSize: 16),
        titleMedium: AppTextStyles.labelLarge(AppColors.textPrimary),
        titleSmall: AppTextStyles.labelMedium(AppColors.textSecondary),
        bodyLarge: AppTextStyles.bodyLarge(AppColors.textPrimary),
        bodyMedium: AppTextStyles.bodyMedium(AppColors.textPrimary),
        bodySmall: AppTextStyles.bodySmall(AppColors.textSecondary),
        labelLarge: AppTextStyles.labelLarge(AppColors.textPrimary),
        labelMedium: AppTextStyles.labelMedium(AppColors.textSecondary),
        labelSmall: AppTextStyles.labelSmall(AppColors.textDisabled),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppButtonStyles.primary,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: AppButtonStyles.secondary,
      ),
      textButtonTheme: TextButtonThemeData(style: AppButtonStyles.text),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.bodyMedium(AppColors.textSecondary),
        hintStyle: AppTextStyles.bodyMedium(AppColors.textDisabled),
        errorStyle: AppTextStyles.bodySmall(AppColors.error),
      ),

      // Cards
      cardTheme: const CardThemeData(
        color: AppColors.card,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        shadowColor: AppColors.shadow,
        margin: EdgeInsets.zero,
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: AppTextStyles.headlineMedium(AppColors.textPrimary),
        contentTextStyle: AppTextStyles.bodyMedium(AppColors.textPrimary),
      ),

      // Snackbars
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.bodyMedium(Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 0,
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTextStyles.labelSmall(AppColors.primary),
        unselectedLabelStyle: AppTextStyles.labelSmall(AppColors.textSecondary),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Visual Density
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: false,
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,

      // Color Scheme
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColorsDark.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColorsDark.surface,
        error: AppColors.error,
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorsDark.surface,
        foregroundColor: AppColorsDark.textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColorsDark.textPrimary),
        titleTextStyle: AppTextStyles.headlineMedium(
          AppColorsDark.textPrimary,
        ).copyWith(fontWeight: FontWeight.w600),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge(AppColorsDark.textPrimary),
        displayMedium: AppTextStyles.displayMedium(AppColorsDark.textPrimary),
        displaySmall: AppTextStyles.displaySmall(AppColorsDark.textPrimary),
        headlineLarge: AppTextStyles.displaySmall(AppColorsDark.textPrimary),
        headlineMedium: AppTextStyles.headlineMedium(AppColorsDark.textPrimary),
        headlineSmall: AppTextStyles.headlineSmall(AppColorsDark.textPrimary),
        titleLarge: AppTextStyles.labelLarge(
          AppColorsDark.textPrimary,
        ).copyWith(fontSize: 16),
        titleMedium: AppTextStyles.labelLarge(AppColorsDark.textPrimary),
        titleSmall: AppTextStyles.labelMedium(AppColorsDark.textSecondary),
        bodyLarge: AppTextStyles.bodyLarge(AppColorsDark.textPrimary),
        bodyMedium: AppTextStyles.bodyMedium(AppColorsDark.textPrimary),
        bodySmall: AppTextStyles.bodySmall(AppColorsDark.textSecondary),
        labelLarge: AppTextStyles.labelLarge(AppColorsDark.textPrimary),
        labelMedium: AppTextStyles.labelMedium(AppColorsDark.textSecondary),
        labelSmall: AppTextStyles.labelSmall(AppColorsDark.textSecondary),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.buttonLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.labelLarge(AppColors.primary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTextStyles.labelMedium(AppColors.primary),
        ),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsDark.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColorsDark.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColorsDark.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.bodyMedium(AppColorsDark.textSecondary),
        hintStyle: AppTextStyles.bodyMedium(AppColorsDark.textDisabled),
        errorStyle: AppTextStyles.bodySmall(AppColors.error),
      ),

      // Cards
      cardTheme: const CardThemeData(
        color: AppColorsDark.card,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        shadowColor: Colors.black45,
        margin: EdgeInsets.zero,
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: AppColorsDark.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: AppTextStyles.headlineMedium(AppColorsDark.textPrimary),
        contentTextStyle: AppTextStyles.bodyMedium(AppColorsDark.textPrimary),
      ),

      // Snackbars
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColorsDark.surface,
        contentTextStyle: AppTextStyles.bodyMedium(AppColorsDark.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: AppColorsDark.divider,
        thickness: 1,
        space: 0,
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColorsDark.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColorsDark.textSecondary,
        selectedLabelStyle: AppTextStyles.labelSmall(AppColors.primary),
        unselectedLabelStyle: AppTextStyles.labelSmall(
          AppColorsDark.textSecondary,
        ),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Visual Density
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: false,
    );
  }
}
