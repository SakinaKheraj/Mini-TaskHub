import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<Task>> getTasks(String userId) async {
    final response = await supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return response.map((json) => Task.fromJson(json)).toList();
  }

  Future<void> createTask(
    String userId,
    String title, {
    String? description,
    String? category,
    String? priority,
    String? startTime,
    String? endTime,
    String? date,
  }) async {
    await supabase.from('tasks').insert({
      'user_id': userId,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'start_time': startTime,
      'end_time': endTime,
      'date': date,
    });
  }

  Future<void> deleteTask(String taskId) async {
    await supabase.from('tasks').delete().eq('id', taskId);
  }

  Future<void> updateTask(
    String taskId, {
    String? title,
    String? description,
    String? category,
    String? priority,
    String? startTime,
    String? endTime,
    String? date,
  }) async {
    await supabase
        .from('tasks')
        .update({
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (category != null) 'category': category,
          if (priority != null) 'priority': priority,
          if (startTime != null) 'start_time': startTime,
          if (endTime != null) 'end_time': endTime,
          if (date != null) 'date': date,
        })
        .eq('id', taskId);
  }

  Future<void> toggleTask(String taskId, bool isCompleted) async {
    await supabase
        .from('tasks')
        .update({'is_completed': isCompleted})
        .eq('id', taskId);
  }
}
