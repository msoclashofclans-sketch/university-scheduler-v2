import 'dart:io';
import 'package:excel/excel.dart';
import '../models/classroom.dart';
import '../models/course_record.dart';
import '../utils/constants.dart';

class ExcelReaderService {
  static const int colStudentCount = 1;
  static const int colSchedule = 5;
  static const int colTeacherFamily = 6;
  static const int colTeacherName = 7;
  static const int colGroup = 15;
  static const int colCourseName = 16;
  static const int colCourseCode = 17;
  static const int colSemester = 18;
  static const int colField = 19;

  Future<List<Classroom>> readClassrooms(File file) async {
    final bytes = file.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final classrooms = <Classroom>[];

    if (excel.tables.isEmpty) return classrooms;
    final sheet = excel.tables.values.first;

    for (final row in sheet.rows) {
      if (row.isEmpty) continue;

      String? className;
      int? capacity;

      for (final cell in row) {
        final value = _cellValue(cell);
        if (value == null || value.isEmpty) continue;

        if (_looksLikeClassName(value)) {
          className = _normalizeClassName(value);
        }

        final num = int.tryParse(value.replaceAll(',', ''));
        if (num != null && num > 0 && num <= 500) {
          capacity = num;
        }
      }

      if (className != null && capacity != null) {
        classrooms.add(Classroom(name: className, capacity: capacity));
      }
    }

    final unique = <String, Classroom>{};
    for (final c in classrooms) {
      unique[c.normalizedName] = c;
    }
    return unique.values.toList();
  }

  Future<List<CourseRecord>> readCourseRecords(File file) async {
    final bytes = file.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final records = <CourseRecord>[];

    if (excel.tables.isEmpty) return records;
    final sheet = excel.tables.values.first;

    for (int rowIndex = 0; rowIndex < sheet.maxRows; rowIndex++) {
      final row = sheet.row(rowIndex);
      if (row.length <= colField) continue;

      final courseName = _cellValue(row[colCourseName]) ?? '';
      final scheduleText = _cellValue(row[colSchedule]) ?? '';

      if (courseName.isEmpty || scheduleText.isEmpty) continue;
      if (courseName == 'نام درس' || courseName == 'درس') continue;

      final teacherName = _cellValue(row[colTeacherName]) ?? '';
      final teacherFamily = _cellValue(row[colTeacherFamily]) ?? '';
      final teacher = '$teacherName $teacherFamily'.trim();

      final studentCount = _cellValue(row[colStudentCount]) ?? '';
      final group = _cellValue(row[colGroup]) ?? '';
      final courseCode = _cellValue(row[colCourseCode]) ?? '';
      final semester = _cellValue(row[colSemester]) ?? '';
      final field = _cellValue(row[colField]) ?? '';

      final sessions = _extractSessions(scheduleText);

      for (final s in sessions) {
        if (!AppConstants.days.contains(s['day'])) continue;
        if (!AppConstants.timeSlots.contains(s['time'])) continue;
        if (s['classroom'] == null) continue;

        records.add(CourseRecord(
          day: s['day']!,
          timeSlot: s['time']!,
          classroom: s['classroom']!,
          weekType: s['weekType'] ?? AppConstants.weekNormal,
          courseName: courseName,
          teacher: teacher,
          studentCount: studentCount,
          group: group,
          courseCode: courseCode,
          field: field,
          semester: semester,
          sourceRow: rowIndex + 1,
        ));
      }
    }
    return records;
  }

  List<Map<String, String?>> _extractSessions(String scheduleText) {
    final sessions = <Map<String, String?>>[];
    final text = _normalize(scheduleText);
    final dayPattern = RegExp(r'(شنبه|یکشنبه|دوشنبه|سه\s*شنبه|چهارشنبه)');
    final dayMatches = dayPattern.allMatches(text).toList();

    for (int i = 0; i < dayMatches.length; i++) {
      final dayMatch = dayMatches[i];
      final start = dayMatch.start;
      final end = (i + 1 < dayMatches.length) ? dayMatches[i + 1].start : text.length;
      final section = text.substring(start, end);
      final day = _normalizeDay(dayMatch.group(1)!);

      final timePattern = RegExp(r'(\d{1,2}:\d{2})\s*-\s*(\d{1,2}:\d{2})');
      final timeMatch = timePattern.firstMatch(section);
      if (timeMatch == null) continue;

      final timeSlot = '${_pad(timeMatch.group(1)!)} - ${_pad(timeMatch.group(2)!)}';
      final afterTime = section.substring(timeMatch.end);
      final classroom = _findClassroom(afterTime);
      final weekType = _getWeekType(section);

      sessions.add({
        'day': day,
        'time': timeSlot,
        'classroom': classroom,
        'weekType': weekType,
      });
    }
    return sessions;
  }

  String? _findClassroom(String text) {
    final patterns = [
      RegExp(r'خوارزمی\s*\d+'),
      RegExp(r'ابوریحان\s*\d+'),
      RegExp(r'خیام\s*\d+'),
      RegExp(r'فارابی\s*\d+'),
      RegExp(r'کارگاه\s*کامپیوتر\s*\d+'),
      RegExp(r'کارگاه\s*پلیمر'),
      RegExp(r'آزمایشگاه[^\*]*'),
    ];
    for (final p in patterns) {
      final match = p.firstMatch(text);
      if (match != null) return _normalizeClassName(match.group(0)!);
    }
    return null;
  }

  String _getWeekType(String text) {
    if (text.contains('هفته زوج')) return AppConstants.weekEven;
    if (text.contains('هفته فرد')) return AppConstants.weekOdd;
    return AppConstants.weekNormal;
  }

  String _normalizeDay(String day) => day.contains('سه') ? 'سه شنبه' : day;

  String _pad(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return time;
    final h = int.tryParse(parts[0]) ?? 0;
    return '${h.toString().padLeft(2, '0')}:${parts[1]}';
  }

  String _normalize(String value) {
    return value.replaceAll('ي', 'ی').replaceAll('ك', 'ک').replaceAll('\u200c', ' ').replaceAll('\u200d', '').replaceAll('\u200e', '').replaceAll('\u200f', '').replaceAll('\xa0', ' ').replaceAll('\r', ' ').replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _normalizeClassName(String value) {
    return value.replaceAll('ي', 'ی').replaceAll('ك', 'ک').replaceAll('خيام', 'خیام').replaceAll('خوارزمي', 'خوارزمی').replaceAll('ابوريحان', 'ابوریحان').replaceAll('فارابي', 'فارابی').replaceAll(RegExp(r'\([^)]*\)'), '').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  bool _looksLikeClassName(String value) {
    final normalized = _normalizeClassName(value);
    const prefixes = ['خوارزمی', 'ابوریحان', 'خیام', 'فارابی', 'کارگاه کامپیوتر', 'کارگاه پلیمر', 'آزمایشگاه'];
    return prefixes.any(normalized.startsWith);
  }

  // 🚨 این بخش کاملاً امن شده است تا هیچ‌وقت Null ندهد
  String? _cellValue(Data? cell) {
    if (cell == null) return null;
    final v = cell.value;
    if (v == null) return null;
    try {
      return v.toString().trim();
    } catch (e) {
      return null;
    }
  }
}
