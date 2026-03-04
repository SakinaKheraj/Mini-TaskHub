class Task {
  final String? id;
  final String title;
  final String? description;
  final String? category;
  final String? priority;
  final String? startTime;
  final String? endTime;
  final String? date;
  final bool isCompleted;
  final String userId;
  final DateTime createdAt;

  Task({
    this.id,
    required this.title,
    this.description,
    this.category,
    this.priority,
    this.startTime,
    this.endTime,
    this.date,
    this.isCompleted = false,
    required this.userId,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    category: json['category'],
    priority: json['priority'],
    startTime: json['start_time'],
    endTime: json['end_time'],
    date: json['date'],
    isCompleted: json['is_completed'] ?? false,
    userId: json['user_id'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'priority': priority,
    'start_time': startTime,
    'end_time': endTime,
    'date': date,
    'is_completed': isCompleted,
    'user_id': userId,
    'created_at': createdAt.toIso8601String(),
  };
}
