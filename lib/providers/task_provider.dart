import 'dart:async';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'package:mini_taskhub/dashboard/task_model.dart';

/// The brain of the app's data management.
/// It listens to the Supabase stream and notifies the UI whenever things change.
class TaskProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<Task> _tasks = [];
  bool _isLoading = false;
  StreamSubscription<List<Task>>? _subscription;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  /// Starts the engine by listening to live data for a specific user.
  void initializeRealtime(String userId) {
    _isLoading = true;
    notifyListeners();

    // Kill any old connections before starting a new one
    _subscription?.cancel();
    _subscription = _supabaseService
        .getTasksStream(userId)
        .listen(
          (updatedTasks) {
            _tasks = updatedTasks;
            _isLoading = false;
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Realtime Error: $error');
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  /// Tells Supabase to create a task. The stream will handle the UI update automatically.
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
  }

  Future<void> deleteTask(String taskId, String userId) async {
    // Optimistic UI: Remove it locally first so the user sees it disappear instantly
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();

    try {
      await _supabaseService.deleteTask(taskId);
    } catch (e) {
      // If it fails, the next stream update will restore it, or we could handle it here.
      debugPrint('Delete failed: $e');
      rethrow;
    }
  }

  Future<void> updateTask(
    String taskId,
    String userId, {
    String? title,
    String? description,
    String? category,
    String? priority,
    String? startTime,
    String? endTime,
    String? date,
  }) async {
    await _supabaseService.updateTask(
      taskId,
      title: title,
      description: description,
      category: category,
      priority: priority,
      startTime: startTime,
      endTime: endTime,
      date: date,
    );
  }

  Future<void> toggleTask(
    String taskId,
    bool isCompleted,
    String userId,
  ) async {
    await _supabaseService.toggleTask(taskId, isCompleted);
  }

  /// Clean up when logging out or closing the app.
  void signOut() {
    _subscription?.cancel();
    _subscription = null;
    _tasks = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
