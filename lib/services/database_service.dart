import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/classroom.dart';
import '../models/course_record.dart';
import '../models/attendance_record.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'university_scheduler.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE classrooms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        capacity INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE course_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        day TEXT NOT NULL,
        time_slot TEXT NOT NULL,
        classroom TEXT NOT NULL,
        week_type TEXT DEFAULT 'عادی',
        course_name TEXT NOT NULL,
        teacher TEXT,
        student_count TEXT,
        group_name TEXT,
        course_code TEXT,
        field TEXT,
        semester TEXT,
        source_row INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE attendance_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        record_key TEXT NOT NULL UNIQUE,
        status TEXT NOT NULL,
        registered_at TEXT,
        day TEXT,
        time_slot TEXT,
        course_name TEXT,
        teacher TEXT,
        classroom TEXT,
        group_name TEXT
      )
    ''');

    await db.execute(
        'CREATE INDEX idx_course_day_time ON course_records(day, time_slot)');
    await db.execute(
        'CREATE INDEX idx_course_classroom ON course_records(classroom)');
    await db.execute(
        'CREATE INDEX idx_course_teacher ON course_records(teacher)');
    await db.execute(
        'CREATE INDEX idx_attendance_key ON attendance_records(record_key)');
  }

  // ==================== کلاس‌ها ====================
  Future<void> clearClassrooms() async {
    final db = await database;
    await db.delete('classrooms');
  }

  Future<void> insertClassrooms(List<Classroom> classrooms) async {
    final db = await database;
    final batch = db.batch();
    for (final c in classrooms) {
      batch.insert('classrooms', c.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Classroom>> getAllClassrooms() async {
    final db = await database;
    final result = await db.query('classrooms', orderBy: 'name ASC');
    return result.map((e) => Classroom.fromMap(e)).toList();
  }

  // ==================== دروس ====================
  Future<void> clearCourseRecords() async {
    final db = await database;
    await db.delete('course_records');
  }

  Future<void> insertCourseRecords(List<CourseRecord> records) async {
    final db = await database;
    final batch = db.batch();
    for (final r in records) {
      batch.insert('course_records', r.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<CourseRecord>> getAllCourseRecords() async {
    final db = await database;
    final result = await db.query('course_records');
    return result.map((e) => CourseRecord.fromMap(e)).toList();
  }

  // ==================== حضور و غیاب ====================
  Future<void> upsertAttendance(AttendanceRecord record) async {
    final db = await database;
    await db.insert(
      'attendance_records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AttendanceRecord>> getAllAttendance() async {
    final db = await database;
    final result = await db.query('attendance_records');
    return result.map((e) => AttendanceRecord.fromMap(e)).toList();
  }

  // ==================== پاک کردن همه ====================
  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('classrooms');
    await db.delete('course_records');
    await db.delete('attendance_records');
  }
}