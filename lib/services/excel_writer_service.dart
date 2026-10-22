import 'dart:io';
import 'package:excel/excel.dart';
import '../models/course_record.dart';
import '../models/classroom.dart';
import '../models/attendance_record.dart';
import '../utils/constants.dart';

class ExcelWriterService {
  Future<void> writeMainSchedule({required String outputPath, required List<CourseRecord> records, required List<Classroom> classrooms}) async {
    final excel = Excel.createExcel();
    if (excel.tables.containsKey('Sheet1')) excel.delete('Sheet1');

    for (final day in AppConstants.days) {
      final sheet = excel[day];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        ..value = TextCellValue('برنامه کلاس‌ها - $day')
        ..cellStyle = CellStyle(bold: true, fontSize: 16, backgroundColorHex: ExcelColor.fromHexString('17365D'), fontColorHex: ExcelColor.fromHexString('FFFFFF'));

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1)).value = TextCellValue('نام کلاس');
      for (int i = 0; i < AppConstants.timeSlots.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i + 1, rowIndex: 1)).value = TextCellValue(AppConstants.timeSlots[i]);
      }

      for (int r = 0; r < classrooms.length; r++) {
        final classroom = classrooms[r];
        final rowIndex = r + 2;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).value = TextCellValue('${classroom.name}\nظرفیت: ${classroom.capacity}');

        for (int c = 0; c < AppConstants.timeSlots.length; c++) {
          final timeSlot = AppConstants.timeSlots[c];
          final matching = records.where((rec) => rec.day == day && rec.timeSlot == timeSlot && rec.classroom == classroom.name);
          if (matching.isEmpty) continue;
          final text = matching.map((r) => r.displayText).toSet().join('\n');
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: c + 1, rowIndex: rowIndex)).value = TextCellValue(text);
        }
      }
    }
    final file = File(outputPath);
    final bytes = excel.encode();
    if (bytes != null) await file.writeAsBytes(bytes);
  }

  Future<void> writeAttendanceFile({required String outputPath, required String day, required String timeSlot, required List<CourseRecord> records, required Map<String, AttendanceRecord> attendanceMap}) async {
    final excel = Excel.createExcel();
    final sheet = excel['حضور و غیاب'];
    if (excel.tables.containsKey('Sheet1')) excel.delete('Sheet1');

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
      ..value = TextCellValue('حضور و غیاب - $day - $timeSlot')
      ..cellStyle = CellStyle(bold: true, fontSize: 16, backgroundColorHex: ExcelColor.fromHexString('17365D'), fontColorHex: ExcelColor.fromHexString('FFFFFF'));

    final headers = ['ردیف', 'نام درس', 'نام استاد', 'محل کلاس', 'گروه', 'وضعیت هفته', 'وضعیت حضور', 'زمان ثبت'];
    for (int c = 0; c < headers.length; c++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 2)).value = TextCellValue(headers[c]);
    }

    final sorted = List<CourseRecord>.from(records)..sort((a, b) { final t = a.teacher.compareTo(b.teacher); if (t != 0) return t; return a.courseName.compareTo(b.courseName); });

    for (int i = 0; i < sorted.length; i++) {
      final rec = sorted[i];
      final rowIndex = i + 3;
      final att = attendanceMap[rec.uniqueKey];
      final status = att?.status ?? AppConstants.statusPending;
      final registeredAt = att?.registeredAt ?? '';
      final values = [(i + 1).toString(), rec.courseName, rec.teacher, rec.classroom, rec.group, rec.weekType, status, registeredAt];
      for (int c = 0; c < values.length; c++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: rowIndex)).value = TextCellValue(values[c]);
      }
    }

    final file = File(outputPath);
    final bytes = excel.encode();
    if (bytes != null) await file.writeAsBytes(bytes);
  }

  Future<void> writeTeacherSchedule({required String outputPath, required List<CourseRecord> records}) async {
    final excel = Excel.createExcel();
    if (excel.tables.containsKey('Sheet1')) excel.delete('Sheet1');

    for (final day in AppConstants.days) {
      final sheet = excel[day];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        ..value = TextCellValue('برنامه اساتید - $day')
        ..cellStyle = CellStyle(bold: true, fontSize: 16, backgroundColorHex: ExcelColor.fromHexString('17365D'), fontColorHex: ExcelColor.fromHexString('FFFFFF'));

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1)).value = TextCellValue('نام استاد');
      for (int i = 0; i < AppConstants.timeSlots.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i + 1, rowIndex: 1)).value = TextCellValue(AppConstants.timeSlots[i]);
      }

      final teachers = records.where((r) => r.day == day && r.teacher.isNotEmpty).map((r) => r.teacher).toSet().toList()..sort();

      for (int r = 0; r < teachers.length; r++) {
        final teacher = teachers[r];
        final rowIndex = r + 2;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).value = TextCellValue(teacher);

        for (int c = 0; c < AppConstants.timeSlots.length; c++) {
          final timeSlot = AppConstants.timeSlots[c];
          final matching = records.where((rec) => rec.day == day && rec.timeSlot == timeSlot && rec.teacher == teacher);
          if (matching.isEmpty) continue;
          final text = matching.map((r) => '${r.courseName} | ${r.classroom}').toSet().join('\n');
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: c + 1, rowIndex: rowIndex)).value = TextCellValue(text);
        }
      }
    }
    final file = File(outputPath);
    final bytes = excel.encode();
    if (bytes != null) await file.writeAsBytes(bytes);
  }
}
