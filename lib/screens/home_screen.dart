import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
                      SliverToBoxAdapter(child: _buildHeader(context, provider, themeProvider)),
                      SliverToBoxAdapter(child: _buildStats(provider)),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                PageTransitions.slideFromRight(
                                  const ScheduleScreen(),
                                ),
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
                                PageTransitions.slideFromRight(
                                  const ClassScreen(),
                                ),
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
                                PageTransitions.slideFromRight(
                                  const TeacherScreen(),
                                ),
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
                                PageTransitions.slideFromRight(
                                  const AttendanceScreen(),
                                ),
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
                                PageTransitions.slideFromRight(
                                  const ReportsScreen(),
                                ),
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
                                PageTransitions.slideFromRight(
                                  const SettingsScreen(),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 30)),
                    ],
                  ),
                ),
                LoadingOverlay(
                  isLoading: provider.isLoading,
                  message: provider.statusMessage,
                  progress: provider.loadingProgress > 0
                      ? provider.loadingProgress
                      : null,
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

  // ==================== هدر ====================
  Widget _buildHeader(
    BuildContext context,
    AppProvider provider,
    ThemeProvider themeProvider,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
      decoration: const BoxDecoration(
        gradient: AppConstants.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سامانه مدیریت کلاس‌ها',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'حضور و غیاب اساتید',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: themeProvider.toggleTheme,
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: Colors.white,
                ),
                tooltip: themeProvider.isDarkMode
                    ? 'حالت روشن'
                    : 'حالت تاریک',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== کارت‌های آماری ====================
  Widget _buildStats(AppProvider provider) {
    final stats = provider.getAttendanceStats();
    final present = stats['present'] ?? 0;
    final absent = stats['absent'] ?? 0;
    final total = stats['total'] ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'کلاس‌ها',
                  value: provider.totalClassrooms.toString(),
                  icon: Icons.meeting_room_rounded,
                  color: AppConstants.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: 'دروس',
                  value: total.toString(),
                  icon: Icons.book_rounded,
                  color: AppConstants.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'حاضر',
                  value: present.toString(),
                  icon: Icons.check_circle_rounded,
                  color: AppConstants.successColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: 'غایب',
                  value: absent.toString(),
                  icon: Icons.cancel_rounded,
                  color: AppConstants.dangerColor,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0);
  }

  // ==================== کارت منو ====================
  Widget _menuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
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
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== انتخاب فایل ====================
  Future<void> _pickFiles(BuildContext context) async {
    final provider = context.read<AppProvider>();

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
        if (name.contains('class')) {
          classFile = File(f.path!);
        } else if (name.contains('1405') || name.contains('all')) {
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
          _showSnack(
            context,
            'لطفاً دو فایل انتخاب کنید: class.xlsx و 14051.xlsx',
            AppConstants.dangerColor,
          );
        }
        return;
      }

      await provider.importFiles(
        classFile: classFile,
        scheduleFile: scheduleFile,
      );

      if (context.mounted) {
        _showSnack(
          context,
          provider.statusMessage,
          AppConstants.successColor,
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showSnack(
          context,
          'خطا: $e',
          AppConstants.dangerColor,
        );
      }
    }
  }

  void _showSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}