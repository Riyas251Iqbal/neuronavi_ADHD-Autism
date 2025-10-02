import 'package:flutter/material.dart';
import 'package:neuronavi/data/models/task_model.dart';
import 'package:neuronavi/data/models/user_model.dart';
import 'package:neuronavi/data/services/firestore_service.dart';

class TaskProvider with ChangeNotifier {
  final UserModel? _userModel;
  final FirestoreService _firestoreService;
  
  List<TaskModel> _tasks = [];
  bool _isLoading = false;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;

  TaskProvider(this._userModel, this._firestoreService) {
    if (_userModel != null) {
      fetchTasks();
    }
  }

  void fetchTasks() {
    _isLoading = true;
    notifyListeners();
    _firestoreService.getTasksForUser(_userModel!.uid, _userModel!.role).listen((tasks) {
      _tasks = tasks;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addTask(TaskModel task) async {
    await _firestoreService.createTask(task);
    // The stream will update the list automatically
  }

  Future<void> updateTask(TaskModel task) async {
    await _firestoreService.updateTask(task);
    // The stream will update the list automatically
  }

  Future<void> toggleSubtaskCompletion(String taskId, String subtaskId) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      final subtaskIndex = task.subtasks.indexWhere((s) => s.id == subtaskId);
      if (subtaskIndex != -1) {
        task.subtasks[subtaskIndex].isCompleted = !task.subtasks[subtaskIndex].isCompleted;
        await updateTask(task);
      }
    }
  }
}