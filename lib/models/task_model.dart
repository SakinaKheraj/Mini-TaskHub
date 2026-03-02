class Task {
  final String? id;
  final String title;
  final bool isCompleted;
  final String userId;
  final DateTime createdAt;

  Task({
    this.id,
    required this.title,
    this.isCompleted = false,
    required this.userId,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    isCompleted: json['is_completed'] ?? false,
    userId: json['user_id'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'is_completed': isCompleted,
    'user_id': userId,
  };
}
