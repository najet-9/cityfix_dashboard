import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryLighter = Color(0xFFDBEAFE);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color accent = Color(0xFFF59E0B);
  static const Color accent2 = Color(0xFF10B981);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF97316);
  static const Color bg = Color(0xFFF0F4FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFF8FAFF);
  static const Color border = Color(0xFFE2E8F6);
  static const Color text = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  static const double radius = 16.0;
  static const double radiusSm = 10.0;
  static const double sidebarW = 260.0;

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor: bg,
      textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(
        bodyColor: text,
        displayColor: text,
      ),
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: surface,
        error: danger,
      ),
      dividerColor: border,
    );
  }
}
