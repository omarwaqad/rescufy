// lib/core/theme/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFB40D14);
  static const Color primaryDark = Color(0xFF8A0A10);
  static const Color primaryLight = Color(0xFFE63946);

  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color card = Colors.white;
  static const Color surfaceMuted = Color(0xFFF1F4F7);
  static const Color surfaceRaised = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFF9E9E9E);
  static const Color textInverse = Colors.white;

  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);

  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color shadow = Color(0x1A000000);
  static const Color outlineSoft = Color(0xFFE8EDF2);

  static const Gradient primaryGradient = LinearGradient(
    colors: [primaryDark, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient emergencyGradient = LinearGradient(
    colors: [primary, Color(0xFFD32F2F)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Gradient heroGradient = LinearGradient(
    colors: [Color(0x14B40D14), Color(0x00B40D14)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppColorsDark {
  static const Color background = Color(0xFF111315);
  static const Color surface = Color(0xFF181C20);
  static const Color card = Color(0xFF1D2227);
  static const Color surfaceMuted = Color(0xFF22282E);
  static const Color surfaceRaised = Color(0xFF252C33);

  static const Color textPrimary = Color(0xFFE8EDF2);
  static const Color textSecondary = Color(0xFFB6C0CA);
  static const Color textDisabled = Color(0xFF7A8591);

  static const Color border = Color(0xFF313841);
  static const Color divider = Color(0xFF252C33);
  static const Color outlineSoft = Color(0xFF2A3037);

  static const Gradient heroGradient = LinearGradient(
    colors: [Color(0x26B40D14), Color(0x00111315)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
