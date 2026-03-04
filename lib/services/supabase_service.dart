import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mini_taskhub/dashboard/task_model.dart';

/// This service handles the bridge between our app and the Supabase database.
/// It takes care of raw SQL-like operations and converts them to Task objects.
class SupabaseService {
  final supabase = Supabase.instance.client;

  /// Fetches a one-time list of tasks. Used as a fallback or initial load.
  Future<List<Task>> getTasks(String userId) async {
    final response = await supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return response.map<Task>((json) => Task.fromJson(json)).toList();
  }

  /// The 'Magic' part: Returns a live stream of data.
  /// Any change in the 'tasks' table on the server will be pushed directly here.
  Stream<List<Task>> getTasksStream(String userId) {
    return supabase
        .from('tasks')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map<Task>((json) => Task.fromJson(json)).toList());
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
