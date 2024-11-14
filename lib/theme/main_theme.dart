// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension CustomColorScheme on ColorScheme {
  // Card Colors
  Color get cardColorMain => brightness == Brightness.light 
    ? const Color(0xFFE9EAE4)
    : const Color(0xFF1E2938);
    
  Color get cardColorSecondary => brightness == Brightness.light
    ? const Color(0xFFF5EEFA)
    : const Color(0xFF2A1E38);
    
  Color get cardColorAccent => brightness == Brightness.light
    ? const Color(0xFFFCF3EE)
    : const Color(0xFF382B1E);

  // Status Colors
  Color get statusSuccess => brightness == Brightness.light
    ? const Color(0xFF4CAF50)
    : const Color(0xFF81C784);
    
  Color get statusWarning => brightness == Brightness.light
    ? const Color(0xFFFFA000)
    : const Color(0xFFFFB74D);
    
  Color get statusError => brightness == Brightness.light
    ? const Color(0xFFE53935)
    : const Color(0xFFE57373);

  // Medical Category Colors
  Color get appointmentColor => const Color(0xFF2196F3);
  Color get medicationColor => const Color(0xFF9C27B0);
  Color get testResultColor => const Color(0xFF00BCD4);
  Color get vitalSignsColor => const Color(0xFF4CAF50);

  // Text Colors
  Color get textPrimary => brightness == Brightness.light
    ? const Color(0xFF2C3E50)
    : const Color(0xFFECEFF1);
    
  Color get textSecondary => brightness == Brightness.light
    ? const Color(0xFF607D8B)
    : const Color(0xFFB0BEC5);

  // Background Colors
  Color get backgroundPrimary => brightness == Brightness.light
    ? const Color(0xFFF8FAFC)
    : const Color(0xFF121212);
    
  Color get backgroundSecondary => brightness == Brightness.light
    ? const Color(0xFFECEFF1)
    : const Color(0xFF1E1E1E);
}

class AppTheme {
  static const _seedColor = Color.fromARGB(255, 223, 223, 215);

  // Text Styles
  static TextStyle get _baseTextStyle => GoogleFonts.poppins();
  
  static TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      displayLarge: _baseTextStyle.copyWith(
        fontSize: 44,
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
      displayMedium: _baseTextStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      displaySmall: _baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      labelLarge: _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }

  // Light Theme
  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );

    return _buildTheme(colorScheme);
  }

  // Dark Theme
  static ThemeData darkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );

    return _buildTheme(colorScheme);
  }

  // Base Theme Builder
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(
        colorScheme.brightness == Brightness.light 
          ? colorScheme.textPrimary 
          : colorScheme.onBackground,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      iconTheme: IconThemeData(
        color: colorScheme.textPrimary,
        size: 24,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        fillColor: colorScheme.backgroundSecondary,
        filled: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}