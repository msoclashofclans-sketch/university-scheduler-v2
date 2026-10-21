import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/empty_state.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _selectedDay = AppConstants.days.first;
  String _selectedTime = AppConstants.timeSlots.first;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('حضور و غیاب اساتید'),
        ),
        body: Consumer<AppProvider>(
          builder: (context, provider, _) {
            if (!provider.hasData) {
              return const EmptyState(
                icon: Icons.fact_check_outlined,
                title: 'هنوز اطلاعاتی وارد نشده',
                subtitle: 'ابتدا از صفحه اصلی فایل‌ها را وارد کنید',
              );
            }

            final records =
                provider.getByDayAndTime(_selectedDay, _selectedTime);

            return Column(
              children: [
                _buildFilters(),
                _buildStats(records, provider),
                Expanded(
                  child: records.isEmpty
                      ? const EmptyState(
                          icon: Icons.event_busy_rounded,
                          title: 'برای این سانس کلاسی وجود ندارد',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: records.length,
                          itemBuilder: (context, i) {
                            final r = records[i];
                            final att = provider.getAttendance(r);
                            return _buildCard(
                              r,
                              att,
                              provider,
                              i,
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ==================== فیلترها ====================
  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: _selectedDay,
              decoration: const InputDecoration(
                labelText: 'روز',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: AppConstants.days
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedDay = v);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: _selectedTime,
              decoration: const InputDecoration(
                labelText: 'سانس',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: AppConstants.timeSlots
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedTime = v);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==================== آمار سانس ====================
  Widget _buildStats(records, AppProvider provider) {
    int present = 0;
    int absent = 0;
    int pending = 0;

    for (final r in records) {
      final att = provider.getAttendance(r);
      if (att == null) {
        pending++;
      } else if (att.status == AppConstants.statusPresent) {
        present++;
      } else {
        absent++;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          _statChip('حاضر', present, AppConstants.successColor),
          const SizedBox(width: 8),
          _statChip('غایب', absent, AppConstants.dangerColor),
          const SizedBox(width: 8),
          _statChip('ثبت نشده', pending, AppConstants.warningColor),
        ],
      ),
    );
  }

  Widget _statChip(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== کارت حضور ====================
  Widget _buildCard(r, att, AppProvider provider, int index) {
    Color bgColor = AppConstants.pendingColor;
    Color textColor = AppConstants.pendingTextColor;
    String status = 'ثبت نشده';
    IconData statusIcon = Icons.hourglass_empty_rounded;

    if (att != null) {
      if (att.status == AppConstants.statusPresent) {
        bgColor = AppConstants.presentColor;
        textColor = AppConstants.presentTextColor;
        status = 'حاضر';
        statusIcon = Icons.check_circle_rounded;
      } else {
        bgColor = AppConstants.absentColor;
        textColor = AppConstants.absentTextColor;
        status = 'غایب';
        statusIcon = Icons.cancel_rounded;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: textColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: textColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.courseName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${r.teacher} • ${r.classroom}',
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: textColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => provider.setAttendance(
                    record: r,
                    status: AppConstants.statusPresent,
                  ),
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('حاضر'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.successColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => provider.setAttendance(
                    record: r,
                    status: AppConstants.statusAbsent,
                  ),
                  icon: const Icon(Icons.close_rounded, size: 18),
                  label: const Text('غایب'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.dangerColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (att != null && att.registeredAt.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 12,
                  color: textColor.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  'ثبت: ${att.registeredAt}',
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (index * 50).ms, duration: 300.ms)
        .slideY(begin: 0.1, end: 0);
  }
}