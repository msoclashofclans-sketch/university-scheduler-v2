class Classroom {
  final int? id;
  final String name;
  final int capacity;

  Classroom({
    this.id,
    required this.name,
    required this.capacity,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'capacity': capacity,
      };

  factory Classroom.fromMap(Map<String, dynamic> map) => Classroom(
        id: map['id'] as int?,
        name: (map['name'] as String?) ?? '',
        capacity: (map['capacity'] as int?) ?? 0,
      );

  /// نام نرمال‌شده برای مقایسه (حذف فاصله، تبدیل ي/ك)
  String get normalizedName {
    var n = name
        .replaceAll('ي', 'ی')
        .replaceAll('ك', 'ک')
        .replaceAll('خيام', 'خیام')
        .replaceAll('خوارزمي', 'خوارزمی')
        .replaceAll('ابوريحان', 'ابوریحان')
        .replaceAll('فارابي', 'فارابی')
        .replaceAll(RegExp(r'\([^)]*\)'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return n.replaceAll(' ', '');
  }

  @override
  String toString() => 'Classroom($name, capacity: $capacity)';
}