import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  // ==================== تم روشن ====================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppConstants.primaryColor,
      primary: AppConstants.primaryColor,
      secondary: AppConstants.accentColor,
      brightness: Brightness.light,
    ),
    fontFamily: GoogleFonts.vazirmatn().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: AppConstants.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.vazirmatn(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        textStyle: GoogleFonts.vazirmatn(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        borderSide: const BorderSide(
          color: AppConstants.accentColor,
          width: 2,
        ),
      ),
    ),
  );

  // ==================== تم تاریک ====================
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F1620),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppConstants.accentColor,
      primary: AppConstants.accentColor,
      secondary: AppConstants.infoColor,
      brightness: Brightness.dark,
    ),
    fontFamily: GoogleFonts.vazirmatn().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0F1620),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.vazirmatn(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      color: const Color(0xFF1A2330),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.accentColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        textStyle: GoogleFonts.vazirmatn(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A2330),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        borderSide: const BorderSide(
          color: AppConstants.accentColor,
          width: 2,
        ),
      ),
    ),
  );

  // ==================== سایه‌های حرفه‌ای ====================
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> glowShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.35),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];
}