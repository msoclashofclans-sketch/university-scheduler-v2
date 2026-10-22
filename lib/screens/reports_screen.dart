import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_provider.dart';
import '../services/excel_writer_service.dart';
import '../utils/constants.dart';
import '../widgets/gradient_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_overlay.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _writer = ExcelWriterService();
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('گزارش‌ها و خروجی Excel')),
        body: Consumer<AppProvider>(
          builder: (context, provider, _) {
            if (!provider.hasData) {
              return const EmptyState(icon: Icons.analytics_outlined, title: 'هنوز اطلاعاتی وارد نشده', subtitle: 'برای ساخت گزارش، ابتدا فایل‌ها را وارد کنید');
            }

            return Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _reportCard(title: 'برنامه هفتگی کلاس‌ها', subtitle: 'یک فایل با ۵ شیت برای روزهای هفته', icon: Icons.calendar_month_rounded, gradient: AppConstants.primaryGradient, onTap: () => _exportMainSchedule(provider)).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 12),
                    _reportCard(title: 'برنامه اساتید', subtitle: 'یک فایل با شیت مجزا برای هر روز', icon: Icons.person_rounded, gradient: AppConstants.dangerGradient, onTap: () => _exportTeacherSchedule(provider)).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 12),
                    _reportCard(title: 'حضور و غیاب یک سانس', subtitle: 'خروجی Excel برای سانس انتخابی', icon: Icons.fact_check_rounded, gradient: AppConstants.successGradient, onTap: () => _exportAttendance(provider)).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 24),
                    _buildStatsCard(provider),
                  ],
                ),
                LoadingOverlay(isLoading: _busy),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _reportCard({required String title, required String subtitle, required IconData icon, required Gradient gradient, required VoidCallback onTap}) {
    return GradientCard(
      gradient: gradient,
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 38),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12))])),
          const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 16),
        ],
      ),
    );
  }

  Widget _buildStatsCard(AppProvider provider) {
    final stats = provider.getAttendanceStats();
    final total = stats['total'] ?? 0;
    final present = stats['present'] ?? 0;
    final absent = stats['absent'] ?? 0;
    final pending = stats['pending'] ?? 0;

    final presentRate = total == 0 ? 0.0 : (present * 100 / total).toDouble();
    final absentRate = total == 0 ? 0.0 : (absent * 100 / total).toDouble();
    final pendingRate = total == 0 ? 0.0 : (pending * 100 / total).toDouble();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1A2330) : Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('آمار کلی حضور و غیاب', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _progressRow('حاضر', present, presentRate, AppConstants.successColor),
          const SizedBox(height: 12),
          _progressRow('غایب', absent, absentRate, AppConstants.dangerColor),
          const SizedBox(height: 12),
          _progressRow('ثبت نشده', pending, pendingRate, AppConstants.warningColor),
        ],
      ),
    );
  }

  Widget _progressRow(String label, int count, double rate, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Text(label, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.bold)), const Spacer(), Text('$count (${rate.toStringAsFixed(0)}%)', style: TextStyle(fontSize: 12, color: color))]),
        const SizedBox(height: 6),
        ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: rate / 100, minHeight: 6, backgroundColor: color.withValues(alpha: 0.15), valueColor: AlwaysStoppedAnimation(color))),
      ],
    );
  }

  Future<Directory> _getOutputDir() async {
    Directory dir;
    if (Platform.isAndroid) {
      final external = await getExternalStorageDirectory();
      dir = Directory('${external!.path}/UniversityScheduler');
    } else {
      final docs = await getApplicationDocumentsDirectory();
      dir = Directory('${docs.path}/UniversityScheduler');
    }
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<void> _exportMainSchedule(AppProvider provider) async {
    setState(() => _busy = true);
    try {
      final dir = await _getOutputDir();
      final path = '${dir.path}/14051all.xlsx';
      await _writer.writeMainSchedule(outputPath: path, records: provider.courseRecords, classrooms: provider.classrooms);
      if (mounted) _showFileActions(path, 'برنامه هفتگی کلاس‌ها');
    } catch (e) {
      _showSnack('خطا: $e', AppConstants.dangerColor);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportTeacherSchedule(AppProvider provider) async {
    setState(() => _busy = true);
    try {
      final dir = await _getOutputDir();
      final path = '${dir.path}/برنامه_اساتید.xlsx';
      await _writer.writeTeacherSchedule(outputPath: path, records: provider.courseRecords);
      if (mounted) _showFileActions(path, 'برنامه اساتید');
    } catch (e) {
      _showSnack('خطا: $e', AppConstants.dangerColor);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportAttendance(AppProvider provider) async {
    final day = await _pickDay();
    if (day == null) return;
    if (!mounted) return;
    final time = await _pickTime();
    if (time == null) return;

    setState(() => _busy = true);
    try {
      final records = provider.getByDayAndTime(day, time);
      final dir = await _getOutputDir();
      final safeTime = time.replaceAll(':', '_').replaceAll(' ', '');
      final path = '${dir.path}/حضور_${day}_$safeTime.xlsx';

      await _writer.writeAttendanceFile(outputPath: path, day: day, timeSlot: time, records: records, attendanceMap: provider.attendanceMap);
      if (mounted) _showFileActions(path, 'حضور و غیاب $day - $time');
    } catch (e) {
      _showSnack('خطا: $e', AppConstants.dangerColor);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<String?> _pickDay() {
    return showDialog<String>(context: context, builder: (_) => SimpleDialog(title: const Text('انتخاب روز'), children: AppConstants.days.map((d) => SimpleDialogOption(onPressed: () => Navigator.pop(context, d), child: Padding(padding: const EdgeInsets.all(8), child: Text(d)))).toList()));
  }

  Future<String?> _pickTime() {
    return showDialog<String>(context: context, builder: (_) => SimpleDialog(title: const Text('انتخاب سانس'), children: AppConstants.timeSlots.map((t) => SimpleDialogOption(onPressed: () => Navigator.pop(context, t), child: Padding(padding: const EdgeInsets.all(8), child: Text(t)))).toList()));
  }

  void _showFileActions(String path, String title) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('$title ذخیره شد', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(path, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: ElevatedButton.icon(onPressed: () async { Navigator.pop(context); await OpenFile.open(path); }, icon: const Icon(Icons.open_in_new_rounded), label: const Text('باز کردن'), style: ElevatedButton.styleFrom(backgroundColor: AppConstants.successColor, foregroundColor: Colors.white))),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton.icon(onPressed: () async { Navigator.pop(context); await Share.shareXFiles([XFile(path)]); }, icon: const Icon(Icons.share_rounded), label: const Text('اشتراک'), style: ElevatedButton.styleFrom(backgroundColor: AppConstants.primaryColor, foregroundColor: Colors.white))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), margin: const EdgeInsets.all(16)));
  }
}
