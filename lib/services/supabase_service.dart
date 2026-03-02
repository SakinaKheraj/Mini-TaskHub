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

  Future<void> createTask(String userId, String title) async {
    await supabase.from('tasks').insert({
      'user_id': userId,
      'title': title,
    });
  }

  Future<void> deleteTask(String taskId) async {
    await supabase.from('tasks').delete().eq('id', taskId);
  }

  Future<void> toggleTask(String taskId, bool isCompleted) async {
    await supabase.from('tasks')
        .update({'is_completed': isCompleted})
        .eq('id', taskId);
  }
}
