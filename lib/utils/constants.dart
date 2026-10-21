import 'package:flutter/material.dart';

class AppConstants {
  // ==================== رنگ‌های اصلی ====================
  static const Color primaryColor = Color(0xFF17365D);
  static const Color secondaryColor = Color(0xFF1F4E78);
  static const Color accentColor = Color(0xFF2E86DE);
  static const Color successColor = Color(0xFF28A745);
  static const Color dangerColor = Color(0xFFDC3545);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF17A2B8);

  // ==================== رنگ‌های حضور و غیاب ====================
  static const Color presentColor = Color(0xFFC6EFCE);
  static const Color absentColor = Color(0xFFFFC7CE);
  static const Color pendingColor = Color(0xFFFFF2CC);
  static const Color presentTextColor = Color(0xFF006100);
  static const Color absentTextColor = Color(0xFF9C0006);
  static const Color pendingTextColor = Color(0xFF7F6000);

  // ==================== گرادیانت‌ها ====================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF17365D), Color(0xFF2E86DE)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFFC5C7D), Color(0xFF6A82FB)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFF7971E), Color(0xFFFFD200)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // ==================== روزهای هفته ====================
  static const List<String> days = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه شنبه',
    'چهارشنبه',
  ];

  // ==================== سانس‌های زمانی ====================
  static const List<String> timeSlots = [
    '07:45 - 09:15',
    '09:15 - 10:45',
    '10:45 - 12:15',
    '14:00 - 15:30',
    '15:30 - 17:00',
  ];

  // ==================== انواع هفته ====================
  static const String weekNormal = 'عادی';
  static const String weekOdd = 'هفته فرد';
  static const String weekEven = 'هفته زوج';

  // ==================== وضعیت‌های حضور ====================
  static const String statusPresent = 'حاضر';
  static const String statusAbsent = 'غایب';
  static const String statusPending = 'ثبت نشده';

  // ==================== تنظیمات ====================
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 14.0;
  static const double radiusLarge = 20.0;
  static const double radiusXLarge = 28.0;

  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
}