import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> loadTasks(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _supabaseService.getTasks(userId);
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(
    String userId,
    String title, {
    String? description,
    String? category,
    String? priority,
    String? startTime,
    String? endTime,
    String? date,
  }) async {
    await _supabaseService.createTask(
      userId,
      title,
      description: description,
      category: category,
      priority: priority,
      startTime: startTime,
      endTime: endTime,
      date: date,
    );
    await loadTasks(userId);
  }

  Future<void> deleteTask(String taskId, String userId) async {
    await _supabaseService.deleteTask(taskId);
    await loadTasks(userId);
  }

  Future<void> toggleTask(
    String taskId,
    bool isCompleted,
    String userId,
  ) async {
    await _supabaseService.toggleTask(taskId, isCompleted);
    await loadTasks(userId);
  }
}
