import 'package:flutter_test/flutter_test.dart';
import 'package:mini_taskhub/models/task_model.dart';

void main() {
  group('Task Model Tests', () {
    final taskMap = {
      'id': '1',
      'title': 'Test Task',
      'is_completed': false,
      'description': 'Test Description',
      'category': 'work',
      'priority': 'High',
      'start_time': '10:00 AM',
      'end_time': '11:00 AM',
      'date': '2023-10-01T00:00:00.000',
      'user_id': 'user123',
      'created_at': '2023-10-01T10:00:00.000Z',
    };

    test('should correctly parse Task from JSON', () {
      final task = Task.fromJson(taskMap);

      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.isCompleted, false);
      expect(task.description, 'Test Description');
      expect(task.category, 'work');
      expect(task.priority, 'High');
      expect(task.startTime, '10:00 AM');
      expect(task.endTime, '11:00 AM');
      expect(task.date, '2023-10-01T00:00:00.000');
      expect(task.userId, 'user123');
      expect(task.createdAt, isA<DateTime>());
    });

    test('should correctly convert Task to JSON', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        isCompleted: false,
        description: 'Test Description',
        category: 'work',
        priority: 'High',
        startTime: '10:00 AM',
        endTime: '11:00 AM',
        date: '2023-10-01T00:00:00.000',
        userId: 'user123',
        createdAt: DateTime.now(),
      );

      final result = task.toJson();

      expect(result['id'], '1');
      expect(result['title'], 'Test Task');
      expect(result['is_completed'], false);
      expect(result['description'], 'Test Description');
      expect(result['category'], 'work');
      expect(result['priority'], 'High');
      expect(result['start_time'], '10:00 AM');
      expect(result['end_time'], '11:00 AM');
      expect(result['date'], '2023-10-01T00:00:00.000');
      expect(result['user_id'], 'user123');
    });

    test('should handle nullable fields in fromJson', () {
      final minimalTaskMap = {
        'id': '2',
        'title': 'Minimal Task',
        'is_completed': true,
        'user_id': 'user456',
        'created_at': DateTime.now().toIso8601String(),
      };

      final task = Task.fromJson(minimalTaskMap);

      expect(task.id, '2');
      expect(task.title, 'Minimal Task');
      expect(task.isCompleted, true);
      expect(task.description, isNull);
      expect(task.category, isNull);
    });
  });
}
