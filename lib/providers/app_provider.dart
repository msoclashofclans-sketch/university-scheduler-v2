import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/classroom.dart';
import '../models/course_record.dart';
import '../models/attendance_record.dart';
import '../services/database_service.dart';
import '../services/excel_reader_service.dart';
import '../utils/constants.dart';

class AppProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final ExcelReaderService _reader = ExcelReaderService();

  List<Classroom> _classrooms = [];
  List<CourseRecord> _courseRecords = [];
  Map<String, AttendanceRecord> _attendanceMap = {};

  bool _isLoading = false;
  String _statusMessage = '';
  double _loadingProgress = 0.0;

  List<Classroom> get classrooms => _classrooms;
  List<CourseRecord> get courseRecords => _courseRecords;
  Map<String, AttendanceRecord> get attendanceMap => _attendanceMap;
  bool get isLoading => _isLoading;
  String get statusMessage => _statusMessage;
  double get loadingProgress => _loadingProgress;
  bool get hasData => _courseRecords.isNotEmpty;

  int get totalClassrooms => _classrooms.length;
  int get totalCourses => _courseRecords.length;
  int get totalTeachers => getAllTeachers().length;

  int get presentCount => _attendanceMap.values.where((a) => a.status == AppConstants.statusPresent).length;
  int get absentCount => _attendanceMap.values.where((a) => a.status == AppConstants.statusAbsent).length;

  Future<void> loadAll() async {
    _setLoading(true, 'در حال بارگذاری...');
    try {
      _classrooms = await _db.getAllClassrooms();
      _courseRecords = await _db.getAllCourseRecords();
      final attList = await _db.getAllAttendance();
      _attendanceMap = {for (final a in attList) a.recordKey: a};
      _setStatus('آماده');
    } catch (e) {
      _setStatus('خطا در بارگذاری: $e');
    } finally {
      _setLoading(false, '');
    }
  }

  Future<void> importFiles({
    required File classFile,
    required File scheduleFile,
  }) async {
    _setLoading(true, 'در حال خواندن فایل کلاس‌ها...');
    _setProgress(0.1);

    try {
      final classrooms = await _reader.readClassrooms(classFile);
      _setStatus('${classrooms.length} کلاس خوانده شد');
      _setProgress(0.3);

      _setStatus('در حال خواندن برنامه درسی...');
      final records = await _reader.readCourseRecords(scheduleFile);
      _setStatus('${records.length} جلسه خوانده شد');
      _setProgress(0.6);

      _setStatus('در حال ذخیره در دیتابیس...');
      await _db.clearClassrooms();
      await _db.clearCourseRecords();
      await _db.insertClassrooms(classrooms);
      _setProgress(0.8);
      await _db.insertCourseRecords(records);
      _setProgress(1.0);

      _classrooms = classrooms;
      _courseRecords = records;

      _setStatus('✅ ${records.length} جلسه از ${classrooms.length} کلاس وارد شد');
      notifyListeners();
    } catch (e) {
      _setStatus('❌ خطا: $e');
    } finally {
      _setLoading(false, _statusMessage);
    }
  }

  Future<void> setAttendance({required CourseRecord record, required String status}) async {
    final key = record.uniqueKey;
    final now = DateTime.now();
    final timestamp = '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final att = AttendanceRecord(
      recordKey: key,
      status: status,
      registeredAt: timestamp,
      day: record.day,
      timeSlot: record.timeSlot,
      courseName: record.courseName,
      teacher: record.teacher,
      classroom: record.classroom,
      group: record.group,
    );

    await _db.upsertAttendance(att);
    _attendanceMap[key] = att;
    notifyListeners();
  }

  AttendanceRecord? getAttendance(CourseRecord record) => _attendanceMap[record.uniqueKey];

  List<CourseRecord> getByDayAndTime(String day, String timeSlot) => _courseRecords.where((r) => r.day == day && r.timeSlot == timeSlot).toList();
  List<CourseRecord> getByClassroom(String classroom) => _courseRecords.where((r) => r.classroom == classroom).toList();
  List<CourseRecord> getByTeacher(String teacher) => _courseRecords.where((r) => r.teacher == teacher).toList();

  List<String> getAllTeachers() {
    final set = _courseRecords.map((r) => r.teacher).where((t) => t.isNotEmpty).toSet().toList()..sort();
    return set;
  }

  Map<String, int> getAttendanceStats() {
    int present = 0;
    int absent = 0;
    int pending = 0;

    for (final r in _courseRecords) {
      final att = _attendanceMap[r.uniqueKey];
      if (att == null) {
        pending++;
      } else if (att.status == AppConstants.statusPresent) {
        present++;
      } else {
        absent++;
      }
    }

    return {
      'present': present,
      'absent': absent,
      'pending': pending,
      'total': _courseRecords.length,
    };
  }

  Future<void> clearAll() async {
    await _db.deleteAllData();
    _classrooms = [];
    _courseRecords = [];
    _attendanceMap = {};
    _setStatus('همه داده‌ها پاک شد');
    notifyListeners();
  }

  void _setLoading(bool value, String message) {
    _isLoading = value;
    _statusMessage = message;
    if (!value) _loadingProgress = 0.0;
    notifyListeners();
  }

  void _setStatus(String message) {
    _statusMessage = message;
    notifyListeners();
  }

  void _setProgress(double value) {
    _loadingProgress = value;
    notifyListeners();
  }

  void clearStatus() {
    _statusMessage = '';
    notifyListeners();
  }
}
