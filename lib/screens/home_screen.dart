import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:permission_handler/permission_handler.dart'; // اضافه شده برای رفع خطای Permission
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../utils/page_transitions.dart';
import '../widgets/gradient_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/loading_overlay.dart';
import 'schedule_screen.dart';
import 'class_screen.dart';
import 'teacher_screen.dart';
import 'attendance_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'teacher_stats_screen.dart'; // اضافه شده برای صفحه آمار

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Consumer2<AppProvider, ThemeProvider>(
          builder: (context, provider, themeProvider, _) {
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: provider.loadAll,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildHeader(context, provider, themeProvider),
                      ),
                      SliverToBoxAdapter(child: _buildStats(provider)),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.15,
                          ),
                          delegate: SliverChildListDelegate([
                            _menuCard(
                              context,
                              title: 'برنامه کلاس‌ها',
                              subtitle: 'نمای هفتگی',
                              icon: Icons.calendar_month_rounded,
                              gradient: AppConstants.primaryGradient,
                              onTap: () => Navigator.push(
                                context,
                                PageTransitions.slideFromRight(const ScheduleScreen()),
                              ),
                            ),
                            _menuCard(
                              context,
                              title: 'کلاس‌ها',
                              subtitle: '${provider.totalClassrooms} کلاس',
                              icon: Icons.meeting_room_rounded,
                              gradient: AppConstants.successGradient,
                              onTap: () => Navigator.push(
                                context,
                                PageTransitions.slideFromRight(const ClassScreen()),
                              ),
                            ),
                            _menuCard(
                              context,
                              title: 'اساتید',
                              subtitle: '${provider.totalTeachers} استاد',
                              icon: Icons.person_rounded,
                              gradient: AppConstants.dangerGradient,
                              onTap: () => Navigator.push(
                                context,
                                PageTransitions.slideFromRight(const TeacherScreen()),
                              ),
                            ),
                            _menuCard(
                              context,
                              title: 'حضور و غیاب',
                              subtitle: '${provider.presentCount} حاضر',
                              icon: Icons.fact_check_rounded,
                              gradient: AppConstants.oceanGradient,
                              onTap: () => Navigator.push(
                                context,
                                PageTransitions.slideFromRight(const AttendanceScreen()),
                              ),
                            ),
                            _menuCard(
                              context,
                              title: 'گزارش‌ها',
                              subtitle: 'خروجی Excel',
                              icon: Icons.analytics_rounded,
                              gradient: AppConstants.sunsetGradient,
                              onTap: () => Navigator.push(
                                context,
                                PageTransitions.slideFromRight(const ReportsScreen()),
                              ),
                            ),
                            _menuCard(
                              context,
                              title: 'آمار اساتید', // دکمه جدید
                              subtitle: 'تعداد دروس',
                              icon: Icons.bar_chart_rounded,
                              gradient: const LinearGradient(colors: [Colors.teal, Colors.green]),
                              onTap: () => Navigator.push(
                                context,
                                PageTransitions.slideFromRight(const TeacherStatsScreen()),
                              ),
                            ),
                            _menuCard(
                              context,
                              title: 'تنظیمات',
                              subtitle: 'مدیریت و تم',
                              icon: Icons.settings_rounded,
                              gradient: AppConstants.purpleGradient,
                              onTap: () => Navigator.push(
                                context,
                                PageTransitions.slideFromRight(const SettingsScreen()),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      // نام سازنده در پایین صفحه
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 30),
                          child: Center(
                            child: Text(
                              'طراحی و توسعه: مسعود خسروی',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                LoadingOverlay(
                  isLoading: provider.isLoading,
                  message: provider.statusMessage,
                  progress: provider.loadingProgress > 0 ? provider.loadingProgress : null,
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _pickFiles(context),
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.upload_file_rounded),
          label: const Text('ورود اطلاعات'),
        ).animate().scale(delay: 600.ms, duration: 500.ms),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppProvider provider, ThemeProvider themeProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
      decoration: const BoxDecoration(
        gradient: AppConstants.primaryGradient,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('سامانه مدیریت کلاس‌ها', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text('حضور و غیاب اساتید', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            onPressed: themeProvider.toggleTheme,
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: StatCard(label: 'کلاس‌ها', value: provider.totalClassrooms.toString(), icon: Icons.meeting_room_rounded, color: AppConstants.primaryColor)),
              const SizedBox(width: 12),
              Expanded(child: StatCard(label: 'دروس', value: provider.totalCourses.toString(), icon: Icons.book_rounded, color: AppConstants.accentColor)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: StatCard(label: 'حاضر', value: provider.presentCount.toString(), icon: Icons.check_circle_rounded, color: AppConstants.successColor)),
              const SizedBox(width: 12),
              Expanded(child: StatCard(label: 'غایب', value: provider.absentCount.toString(), icon: Icons.cancel_rounded, color: AppConstants.dangerColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Gradient gradient, required VoidCallback onTap}) {
    return GradientCard(
      gradient: gradient,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white, size: 34),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  // تابع نمایش پیام (که در کدهای قبلی جا افتاده بود)
  void _showSnack(BuildContext context, String msg, Color color) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _pickFiles(BuildContext context) async {
  final provider = context.read<AppProvider>();

  // ۱. گرفتن مجوز دسترسی به فایل‌ها (برای اندروید ۱۳ و ۱۴)
  var status = await Permission.manageExternalStorage.status;
  if (!status.isGranted) {
    status = await Permission.manageExternalStorage.request();
    
    // اگر باز هم اجازه نداد، مجوز قدیمی‌تر (storage) را چک می‌کنیم
    if (!status.isGranted) {
      var storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        storageStatus = await Permission.storage.request();
      }
      
      // اگر هیچ‌کدام اجازه ندادند، پیام می‌دهیم و به تنظیمات می‌فرستیم
      if (!storageStatus.isGranted) {
        if (context.mounted) {
          _showSnack(context, 'برای خواندن فایل‌ها، باید به برنامه اجازه دسترسی به حافظه بدهید.', AppConstants.dangerColor);
          await openAppSettings(); // باز کردن تنظیمات گوشی
        }
        return;
      }
    }
  }

  // ۲. باز کردن پنجره انتخاب فایل
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) return;

    File? classFile;
    File? scheduleFile;

    for (final f in result.files) {
      if (f.path == null) continue;
      final name = f.name.toLowerCase();
      
      // فایل کلاس‌ها
      if (name.contains('class')) {
        classFile = File(f.path!);
      } 
      // فایل برنامه (all-class)
      else if (name.contains('all-class') || name.contains('1405') || name.contains('all')) {
        scheduleFile = File(f.path!);
      } else {
        if (classFile == null) {
          classFile = File(f.path!);
        } else {
          scheduleFile = File(f.path!);
        }
      }
    }

    if (classFile == null || scheduleFile == null) {
      if (context.mounted) {
        _showSnack(context, 'لطفاً فایل اول را با نام class و فایل دوم را با نام all-class انتخاب کنید.', AppConstants.dangerColor);
      }
      return;
    }

    await provider.importFiles(classFile: classFile, scheduleFile: scheduleFile);

    if (context.mounted) {
      _showSnack(context, provider.statusMessage, AppConstants.successColor);
    }
  } catch (e) {
    if (context.mounted) {
      _showSnack(context, 'خطا: $e', AppConstants.dangerColor);
    }
  }
}
