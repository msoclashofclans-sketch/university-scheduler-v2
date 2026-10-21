import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../widgets/section_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تنظیمات'),
        ),
        body: Consumer2<AppProvider, ThemeProvider>(
          builder: (context, provider, themeProvider, _) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SectionHeader(
                  title: 'ظاهر برنامه',
                  icon: Icons.palette_rounded,
                ),
                _buildTile(
                  context,
                  icon: Icons.dark_mode_rounded,
                  title: 'حالت تاریک',
                  subtitle: themeProvider.isDarkMode
                      ? 'فعال'
                      : 'غیرفعال',
                  color: AppConstants.purpleGradient,
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (_) => themeProvider.toggleTheme(),
                    activeThumbColor: AppConstants.accentColor,
                  ),
                ),
                const SizedBox(height: 20),
                const SectionHeader(
                  title: 'اطلاعات سیستم',
                  icon: Icons.info_rounded,
                ),
                _buildInfoTile(
                  context,
                  'تعداد کلاس‌ها',
                  provider.totalClassrooms.toString(),
                  Icons.meeting_room_rounded,
                ),
                _buildInfoTile(
                  context,
                  'تعداد دروس',
                  provider.totalCourses.toString(),
                  Icons.book_rounded,
                ),
                _buildInfoTile(
                  context,
                  'تعداد اساتید',
                  provider.totalTeachers.toString(),
                  Icons.person_rounded,
                ),
                _buildInfoTile(
                  context,
                  'تعداد رکورد حضور',
                  provider.attendanceMap.length.toString(),
                  Icons.fact_check_rounded,
                ),
                const SizedBox(height: 20),
                const SectionHeader(
                  title: 'مدیریت داده‌ها',
                  icon: Icons.storage_rounded,
                ),
                _buildTile(
                  context,
                  icon: Icons.delete_forever_rounded,
                  title: 'پاک کردن همه داده‌ها',
                  subtitle: 'حذف کامل کلاس‌ها، دروس و حضور و غیاب',
                  color: AppConstants.dangerGradient,
                  onTap: () => _confirmClear(context, provider),
                ),
                const SizedBox(height: 30),
                _buildAbout(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient color,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2330) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11),
        ),
        trailing: trailing ??
            (onTap != null
                ? const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 14,
                    color: Colors.grey,
                  )
                : null),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05, end: 0);
  }

  Widget _buildInfoTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2330) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.accentColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppConstants.accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstants.accentColor,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppConstants.primaryGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.school_rounded, color: Colors.white, size: 40),
          SizedBox(height: 10),
          Text(
            'سامانه مدیریت کلاس‌ها',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'نسخه 2.0.0',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          SizedBox(height: 8),
          Text(
            'حضور و غیاب اساتید + مدیریت برنامه',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).scale(duration: 500.ms);
  }

  Future<void> _confirmClear(
    BuildContext context,
    AppProvider provider,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: AppConstants.dangerColor),
            SizedBox(width: 8),
            Text('هشدار'),
          ],
        ),
        content: const Text(
          'آیا مطمئن هستید که می‌خواهید همه داده‌ها را پاک کنید؟\n'
          'این عمل قابل بازگشت نیست.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('لغو'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.dangerColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('پاک کن'),
          ),
        ],
      ),
    );

    if (result == true) {
      await provider.clearAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('همه داده‌ها پاک شد'),
            backgroundColor: AppConstants.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}