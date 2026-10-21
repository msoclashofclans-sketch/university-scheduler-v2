class AttendanceRecord {
  final int? id;
  final String recordKey;
  final String status;
  final String registeredAt;
  final String day;
  final String timeSlot;
  final String courseName;
  final String teacher;
  final String classroom;
  final String group;

  AttendanceRecord({
    this.id,
    required this.recordKey,
    required this.status,
    required this.registeredAt,
    required this.day,
    required this.timeSlot,
    required this.courseName,
    required this.teacher,
    required this.classroom,
    required this.group,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'record_key': recordKey,
        'status': status,
        'registered_at': registeredAt,
        'day': day,
        'time_slot': timeSlot,
        'course_name': courseName,
        'teacher': teacher,
        'classroom': classroom,
        'group_name': group,
      };

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) =>
      AttendanceRecord(
        id: map['id'] as int?,
        recordKey: (map['record_key'] as String?) ?? '',
        status: (map['status'] as String?) ?? 'ثبت نشده',
        registeredAt: (map['registered_at'] as String?) ?? '',
        day: (map['day'] as String?) ?? '',
        timeSlot: (map['time_slot'] as String?) ?? '',
        courseName: (map['course_name'] as String?) ?? '',
        teacher: (map['teacher'] as String?) ?? '',
        classroom: (map['classroom'] as String?) ?? '',
        group: (map['group_name'] as String?) ?? '',
      );
}