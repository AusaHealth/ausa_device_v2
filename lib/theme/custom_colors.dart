import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  // Card Colors
  Color get cardColorMain => brightness == Brightness.light 
    ? const Color(0xFFEEF5FC)
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
