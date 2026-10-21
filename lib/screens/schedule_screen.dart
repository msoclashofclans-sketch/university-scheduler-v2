import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../models/course_record.dart';
import '../widgets/empty_state.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppConstants.days.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('برنامه هفتگی کلاس‌ها'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            tabs: AppConstants.days.map((d) => Tab(text: d)).toList(),
          ),
        ),
        body: Consumer<AppProvider>(
          builder: (context, provider, _) {
            if (!provider.hasData) {
              return const EmptyState(
                icon: Icons.event_busy_rounded,
                title: 'هنوز اطلاعاتی وارد نشده',
                subtitle: 'از دکمه ورود اطلاعات در صفحه اصلی استفاده کنید',
              );
            }

            return TabBarView(
              controller: _tabController,
              children: AppConstants.days
                  .map((day) => _buildDayView(day, provider))
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDayView(String day, AppProvider provider) {
    final hasAny = AppConstants.timeSlots.any((t) =>
        provider.getByDayAndTime(day, t).isNotEmpty);

    if (!hasAny) {
      return const EmptyState(
        icon: Icons.event_note_rounded,
        title: 'برای این روز کلاسی ثبت نشده',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: AppConstants.timeSlots.length,
      itemBuilder: (context, index) {
        final timeSlot = AppConstants.timeSlots[index];
        final records = provider.getByDayAndTime(day, timeSlot);

        if (records.isEmpty) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  gradient: AppConstants.primaryGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeSlot,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${records.length} درس',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...records.map((r) => _buildRecordTile(r)),
            ],
          ),
        ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildRecordTile(CourseRecord r) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey.shade800 : const Color(0xFFEEEEEE),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 55,
            decoration: BoxDecoration(
              color: AppConstants.accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.courseName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    if (r.teacher.isNotEmpty)
                      _infoChip(Icons.person, r.teacher),
                    if (r.classroom.isNotEmpty)
                      _infoChip(Icons.room, r.classroom),
                    if (r.group.isNotEmpty)
                      _infoChip(Icons.group, 'گروه ${r.group}'),
                  ],
                ),
              ],
            ),
          ),
          if (r.weekType != AppConstants.weekNormal)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppConstants.warningColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                r.weekType,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppConstants.pendingTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}