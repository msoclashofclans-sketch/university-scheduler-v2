import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/empty_state.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اساتید'),
        ),
        body: Consumer<AppProvider>(
          builder: (context, provider, _) {
            if (provider.getAllTeachers().isEmpty) {
              return const EmptyState(
                icon: Icons.person_outline_rounded,
                title: 'هیچ استادی یافت نشد',
                subtitle: 'ابتدا فایل برنامه را وارد کنید',
              );
            }

            final teachers = provider
                .getAllTeachers()
                .where((t) => t.contains(_search))
                .toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'جستجوی استاد...',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                    onChanged: (v) => setState(() => _search = v),
                  ),
                ),
                Expanded(
                  child: teachers.isEmpty
                      ? const EmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'استادی یافت نشد',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: teachers.length,
                          itemBuilder: (context, i) {
                            final t = teachers[i];
                            final records = provider.getByTeacher(t);
                            final rate =
                                provider.getTeacherAttendanceRate(t);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                childrenPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  radius: 22,
                                  backgroundColor:
                                      AppConstants.primaryColor,
                                  child: Text(
                                    t.isNotEmpty ? t[0] : '?',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  t,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      '${records.length} جلسه',
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: rate > 0.7
                                            ? AppConstants.successColor
                                                .withValues(alpha: 0.15)
                                            : AppConstants.warningColor
                                                .withValues(alpha: 0.15),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'حضور: ${(rate * 100).toStringAsFixed(0)}%',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: rate > 0.7
                                              ? AppConstants.successColor
                                              : AppConstants.pendingTextColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                children: records.map((r) {
                                  return ListTile(
                                    dense: true,
                                    leading: const Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: AppConstants.accentColor,
                                    ),
                                    title: Text(
                                      r.courseName,
                                      style:
                                          const TextStyle(fontSize: 13),
                                    ),
                                    subtitle: Text(
                                      '${r.day} - ${r.timeSlot} | ${r.classroom}',
                                      style:
                                          const TextStyle(fontSize: 11),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                                .animate()
                                .fadeIn(delay: (i * 50).ms, duration: 300.ms)
                                .slideX(begin: 0.1, end: 0);
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
}