import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/empty_state.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({super.key});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('کلاس‌ها'),
        ),
        body: Consumer<AppProvider>(
          builder: (context, provider, _) {
            if (provider.classrooms.isEmpty) {
              return const EmptyState(
                icon: Icons.meeting_room_outlined,
                title: 'هیچ کلاسی وارد نشده',
                subtitle: 'از صفحه اصلی، فایل class.xlsx را وارد کنید',
              );
            }

            final filtered = provider.classrooms
                .where((c) => c.name.contains(_search))
                .toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'جستجوی کلاس...',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                    onChanged: (v) => setState(() => _search = v),
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? const EmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'نتیجه‌ای یافت نشد',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filtered.length,
                          itemBuilder: (context, i) {
                            final c = filtered[i];
                            final records =
                                provider.getByClassroom(c.name);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
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
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: AppConstants.primaryGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.meeting_room_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  c.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Text(
                                  'ظرفیت: ${c.capacity} | ${records.length} جلسه',
                                  style: const TextStyle(fontSize: 11),
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
                                      '${r.day} - ${r.timeSlot} | ${r.teacher}',
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