import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:excel/excel.dart' as xl;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../providers/app_provider.dart';
import '../utils/constants.dart';

class TeacherStatsScreen extends StatelessWidget {
  const TeacherStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('آمار دروس اساتید'),
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Consumer<AppProvider>(
          builder: (context, provider, _) {
            final teachers = provider.getAllTeachers();
            if (teachers.isEmpty) {
              return const Center(child: Text('داده‌ای برای نمایش وجود ندارد.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: teachers.length,
              itemBuilder: (context, i) {
                final t = teachers[i];
                final records = provider.getByTeacher(t);
                final totalCourses = records.length;
                int totalUnits = 0;
                for (var r in records) {
                  totalUnits += (int.tryParse(r.group) ?? 1); // محاسبه تقریبی واحدها
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppConstants.primaryColor,
                      child: Text(t[0], style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('تعداد دروس: $totalCourses | تعداد واحد: $totalUnits'),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final provider = context.read<AppProvider>();
            final excel = xl.Excel.createExcel();
            final sheet = excel['آمار اساتید'];
            sheet.appendRow([xl.TextCellValue('نام استاد'), xl.TextCellValue('تعداد دروس'), xl.TextCellValue('تعداد واحد')]);
            
            for (var t in provider.getAllTeachers()) {
              final records = provider.getByTeacher(t);
              int totalUnits = 0;
              for (var r in records) {
                totalUnits += (int.tryParse(r.group) ?? 1);
              }
              sheet.appendRow([xl.TextCellValue(t), xl.TextCellValue(records.length.toString()), xl.TextCellValue(totalUnits.toString())]);
            }
            
            final dir = await getApplicationDocumentsDirectory();
            final path = '${dir.path}/TeacherStats.xlsx';
            final file = File(path);
            final bytes = excel.encode();
            if (bytes != null) {
              await file.writeAsBytes(bytes);
              await Share.shareXFiles([XFile(path)], text: 'آمار اساتید');
            }
          },
          backgroundColor: AppConstants.successColor,
          icon: const Icon(Icons.file_download),
          label: const Text('خروجی اکسل'),
        ),
      ),
    );
  }
}
