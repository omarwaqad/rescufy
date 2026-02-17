// lib/core/theme/app_text_styles.dart
import 'package:flutter/material.dart';

class AppTextStyles {
  // Headings - Poppins
  static TextStyle displayLarge(Color color) => TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: color,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium(Color color) => TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: color,
    height: 1.2,
  );

  static TextStyle displayBold(Color color) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: color,
    height: 1.2,
  );

  static TextStyle displaySmall(Color color) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: color,
    height: 1.3,
  );

  static TextStyle headlineMedium(Color color) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: color,
    height: 1.4,
  );

  static TextStyle headlineSmall(Color color) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color,
    height: 1.4,
  );

  // Body - Inter
  static TextStyle bodyLarge(Color color) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.5,
  );

  static TextStyle bodyMedium(Color color) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.5,
  );

  static TextStyle bodySmall(Color color) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.5,
  );

  // Labels & Captions
  static TextStyle labelLarge(Color color) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: color,
    height: 1.4,
  );

  static TextStyle labelMedium(Color color) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: color,
    height: 1.4,
  );

  static TextStyle labelSmall(Color color) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.4,
  );

  // Buttons
  static TextStyle get buttonLarge => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.4,
  );

  static TextStyle get buttonMedium => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.4,
  );

  static TextStyle get buttonSmall => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.4,
  );

  // Special Emergency Text
  static TextStyle emergencyHeading(Color color) => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: color,
    height: 1.2,
  );

  static TextStyle emergencySubtitle(Color color) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: color,
    height: 1.4,
  );
}
