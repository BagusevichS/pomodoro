import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/task_entity.dart';
import '../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final SharedPreferences sharedPreferences;

  TaskRepositoryImpl({required this.sharedPreferences});

  @override
  Future<void> addTask(TaskEntity task) async {
    List<String> taskList = sharedPreferences.getStringList('tasks') ?? [];
    taskList.add(jsonEncode({
      'taskId' : task.taskId,
      'taskName': task.taskName,
      'taskFolderName': task.taskFolderName,
      'tomatoes': task.tomatoes,
      'taskText': task.taskText,
      'taskDate': task.taskDate.toIso8601String(),
      'completed': task.completed
    }));
    await sharedPreferences.setStringList('tasks', taskList);
  }

  @override
  Future<List<TaskEntity>> getTasks() async {
    List<String> taskList = sharedPreferences.getStringList('tasks') ?? [];
    return taskList.map((task) {
      final decodedTask = jsonDecode(task);
      return TaskEntity(
        taskId: decodedTask['taskId'],
        taskName: decodedTask['taskName'],
        taskFolderName: decodedTask['taskFolderName'],
        tomatoes: decodedTask['tomatoes'],
        taskText: decodedTask['taskText'],
        taskDate: DateTime.parse(decodedTask['taskDate']),
        completed: decodedTask['completed'],
      );
    }).toList();
  }

  @override
  Future<List<TaskEntity>> getTasksByFolderName(String folderName) async {
    List<String> taskList = sharedPreferences.getStringList('tasks') ?? [];
    return taskList
        .map((task) {
      final decodedTask = jsonDecode(task);
      return TaskEntity(
        taskId: decodedTask['taskId'],
        taskName: decodedTask['taskName'],
        taskFolderName: decodedTask['taskFolderName'],
        tomatoes: decodedTask['tomatoes'],
        taskText: decodedTask['taskText'],
        taskDate: DateTime.parse(decodedTask['taskDate']),
        completed: decodedTask['completed'],
      );
    })
        .where((task) => task.taskFolderName == folderName)
        .toList();
  }

  @override
  Future<void> changeCompletedStatus(TaskEntity task) async {
    List<String> taskList = sharedPreferences.getStringList('tasks') ?? [];
    int taskIndex = taskList.indexWhere((t) {
      final decodedTask = jsonDecode(t);
      return decodedTask['taskId'] == task.taskId;
    });

    if (taskIndex != -1) {
      final updatedTask = jsonEncode({
        'taskName': task.taskName,
        'taskFolderName': task.taskFolderName,
        'tomatoes': task.tomatoes,
        'taskText': task.taskText,
        'taskDate': task.taskDate.toIso8601String(),
        'completed': !task.completed, // Меняем статус выполнения
      });

      taskList[taskIndex] = updatedTask;
      await sharedPreferences.setStringList('tasks', taskList);
    }
  }
  @override
  Future<void> updateTask(TaskEntity task) async {
    List<String> taskList = sharedPreferences.getStringList('tasks') ?? [];
    int taskIndex = taskList.indexWhere((t) {
      final decodedTask = jsonDecode(t);
      return decodedTask['taskId'] == task.taskId;
    });

    if (taskIndex != -1) {
      final updatedTask = jsonEncode({
        'taskName': task.taskName,
        'taskFolderName': task.taskFolderName,
        'tomatoes': task.tomatoes,
        'taskText': task.taskText,
        'taskDate': task.taskDate.toIso8601String(),
        'completed': task.completed,
      });

      taskList[taskIndex] = updatedTask;
      await sharedPreferences.setStringList('tasks', taskList);
    }
  }

  @override
  Future<void> deleteTask(int taskId) async {
    List<String> taskList = sharedPreferences.getStringList('tasks') ?? [];
    taskList.removeWhere((task) {
      final decodedTask = jsonDecode(task);
      return decodedTask['taskId'] == taskId;
    });
    await sharedPreferences.setStringList('tasks', taskList);
  }
}
