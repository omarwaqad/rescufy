import 'package:flutter/material.dart';

import 'app_spacing.dart';
import 'app_text_styles.dart';
import 'app_theme_tokens.dart';
import 'button_styles.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSurface: AppColors.textPrimary,
    ),
    scaffoldBackgroundColor: AppColors.background,
    surfaceColor: AppColors.surface,
    cardColor: AppColors.card,
    borderColor: AppColors.border,
    dividerColor: AppColors.divider,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textDisabled: AppColors.textDisabled,
    shadowColor: AppColors.shadow,
    tokens: AppThemeTokens.light,
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColorsDark.surface,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSurface: AppColorsDark.textPrimary,
    ),
    scaffoldBackgroundColor: AppColorsDark.background,
    surfaceColor: AppColorsDark.surface,
    cardColor: AppColorsDark.card,
    borderColor: AppColorsDark.border,
    dividerColor: AppColorsDark.divider,
    textPrimary: AppColorsDark.textPrimary,
    textSecondary: AppColorsDark.textSecondary,
    textDisabled: AppColorsDark.textDisabled,
    shadowColor: Colors.black45,
    tokens: AppThemeTokens.dark,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBackgroundColor,
    required Color surfaceColor,
    required Color cardColor,
    required Color borderColor,
    required Color dividerColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color textDisabled,
    required Color shadowColor,
    required AppThemeTokens tokens,
  }) {
    final textTheme = TextTheme(
      displayLarge: AppTextStyles.displayLarge(textPrimary),
      displayMedium: AppTextStyles.displayMedium(textPrimary),
      displaySmall: AppTextStyles.displaySmall(textPrimary),
      headlineLarge: AppTextStyles.displaySmall(textPrimary),
      headlineMedium: AppTextStyles.headlineMedium(textPrimary),
      headlineSmall: AppTextStyles.headlineSmall(textPrimary),
      titleLarge: AppTextStyles.labelLarge(textPrimary).copyWith(fontSize: 16),
      titleMedium: AppTextStyles.labelLarge(textPrimary),
      titleSmall: AppTextStyles.labelMedium(textSecondary),
      bodyLarge: AppTextStyles.bodyLarge(textPrimary),
      bodyMedium: AppTextStyles.bodyMedium(textPrimary),
      bodySmall: AppTextStyles.bodySmall(textSecondary),
      labelLarge: AppTextStyles.labelLarge(textPrimary),
      labelMedium: AppTextStyles.labelMedium(textSecondary),
      labelSmall: AppTextStyles.labelSmall(textDisabled),
    );

    return ThemeData(
      brightness: brightness,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: AppTextStyles.headlineMedium(
          textPrimary,
        ).copyWith(fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: AppButtonStyles.primary),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: AppButtonStyles.secondary,
      ),
      textButtonTheme: TextButtonThemeData(style: AppButtonStyles.text),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.bodyMedium(textSecondary),
        hintStyle: AppTextStyles.bodyMedium(textDisabled),
        errorStyle: AppTextStyles.bodySmall(AppColors.error),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: brightness == Brightness.dark ? 0 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        shadowColor: shadowColor,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        titleTextStyle: AppTextStyles.headlineMedium(textPrimary),
        contentTextStyle: AppTextStyles.bodyMedium(textPrimary),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: AppTextStyles.bodyMedium(colorScheme.onPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final base = textTheme.labelMedium;
          if (states.contains(WidgetState.selected)) {
            return base?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            );
          }

          return base?.copyWith(color: textSecondary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? colorScheme.primary
              : textSecondary;
          return IconThemeData(color: color);
        }),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: AppTextStyles.labelSmall(colorScheme.primary),
        unselectedLabelStyle: AppTextStyles.labelSmall(textSecondary),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      extensions: <ThemeExtension<dynamic>>[tokens],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
    );
  }
}
