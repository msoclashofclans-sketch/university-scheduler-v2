class CourseRecord {
  final int? id;
  final String day;
  final String timeSlot;
  final String classroom;
  final String weekType;
  final String courseName;
  final String teacher;
  final String studentCount;
  final String group;
  final String courseCode;
  final String field;
  final String semester;
  final int sourceRow;

  CourseRecord({
    this.id,
    required this.day,
    required this.timeSlot,
    required this.classroom,
    required this.weekType,
    required this.courseName,
    required this.teacher,
    required this.studentCount,
    required this.group,
    required this.courseCode,
    required this.field,
    required this.semester,
    required this.sourceRow,
  });

  String get displayText {
    final parts = <String>[courseName];
    if (teacher.isNotEmpty) parts.add(teacher);
    if (studentCount.isNotEmpty) parts.add('ثبت‌نامی: $studentCount');
    if (weekType != 'عادی') parts.add(weekType);
    return parts.join(' | ');
  }

  String get shortText => '$courseName\n$teacher';

  Map<String, dynamic> toMap() => {
        'id': id,
        'day': day,
        'time_slot': timeSlot,
        'classroom': classroom,
        'week_type': weekType,
        'course_name': courseName,
        'teacher': teacher,
        'student_count': studentCount,
        'group_name': group,
        'course_code': courseCode,
        'field': field,
        'semester': semester,
        'source_row': sourceRow,
      };

  // 🚨 این بخش امن شده است تا دیتابیس به هیچ وجه Null برنگرداند
  factory CourseRecord.fromMap(Map<String, dynamic> map) => CourseRecord(
        id: map['id'] as int?,
        day: (map['day'] as String?) ?? '',
        timeSlot: (map['time_slot'] as String?) ?? '',
        classroom: (map['classroom'] as String?) ?? '',
        weekType: (map['week_type'] as String?) ?? 'عادی',
        courseName: (map['course_name'] as String?) ?? '',
        teacher: (map['teacher'] as String?) ?? '',
        studentCount: (map['student_count'] as String?) ?? '',
        group: (map['group_name'] as String?) ?? '',
        courseCode: (map['course_code'] as String?) ?? '',
        field: (map['field'] as String?) ?? '',
        semester: (map['semester'] as String?) ?? '',
        sourceRow: (map['source_row'] as int?) ?? 0,
      );

  String get uniqueKey =>
      '$day|$timeSlot|$courseName|$teacher|$classroom|$group|$weekType|$sourceRow';
}
