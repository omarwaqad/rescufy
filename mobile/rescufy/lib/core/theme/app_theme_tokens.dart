import 'package:flutter/material.dart';

import 'colors.dart';

@immutable
class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  const AppThemeTokens({
    required this.success,
    required this.warning,
    required this.info,
    required this.surfaceMuted,
    required this.surfaceRaised,
    required this.outlineSoft,
    required this.heroGradient,
    required this.emergencyGradient,
  });

  final Color success;
  final Color warning;
  final Color info;
  final Color surfaceMuted;
  final Color surfaceRaised;
  final Color outlineSoft;
  final Gradient heroGradient;
  final Gradient emergencyGradient;

  static const light = AppThemeTokens(
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
    surfaceMuted: AppColors.surfaceMuted,
    surfaceRaised: AppColors.surfaceRaised,
    outlineSoft: AppColors.outlineSoft,
    heroGradient: AppColors.heroGradient,
    emergencyGradient: AppColors.emergencyGradient,
  );

  static const dark = AppThemeTokens(
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
    surfaceMuted: AppColorsDark.surfaceMuted,
    surfaceRaised: AppColorsDark.surfaceRaised,
    outlineSoft: AppColorsDark.outlineSoft,
    heroGradient: AppColorsDark.heroGradient,
    emergencyGradient: AppColors.emergencyGradient,
  );

  @override
  AppThemeTokens copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? surfaceMuted,
    Color? surfaceRaised,
    Color? outlineSoft,
    Gradient? heroGradient,
    Gradient? emergencyGradient,
  }) {
    return AppThemeTokens(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      outlineSoft: outlineSoft ?? this.outlineSoft,
      heroGradient: heroGradient ?? this.heroGradient,
      emergencyGradient: emergencyGradient ?? this.emergencyGradient,
    );
  }

  @override
  AppThemeTokens lerp(ThemeExtension<AppThemeTokens>? other, double t) {
    if (other is! AppThemeTokens) {
      return this;
    }

    return AppThemeTokens(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      info: Color.lerp(info, other.info, t) ?? info,
      surfaceMuted:
          Color.lerp(surfaceMuted, other.surfaceMuted, t) ?? surfaceMuted,
      surfaceRaised:
          Color.lerp(surfaceRaised, other.surfaceRaised, t) ?? surfaceRaised,
      outlineSoft: Color.lerp(outlineSoft, other.outlineSoft, t) ?? outlineSoft,
      heroGradient: t < 0.5 ? heroGradient : other.heroGradient,
      emergencyGradient: t < 0.5 ? emergencyGradient : other.emergencyGradient,
    );
  }
}

extension AppThemeTokensContext on BuildContext {
  AppThemeTokens get appThemeTokens =>
      Theme.of(this).extension<AppThemeTokens>() ?? AppThemeTokens.light;
}
