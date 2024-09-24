import 'package:flutter/material.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository repository;

  // Храним список задач
  List<TaskEntity> _tasks = [];

  // Геттер для списка задач
  List<TaskEntity> get tasks => _tasks;

  TaskProvider({required this.repository}) {
    _loadTasks();
  }

  // Метод для загрузки задач
  Future<void> _loadTasks() async {
    _tasks = await repository.getTasks();
    notifyListeners();
  }

  Future<void> updateTask(TaskEntity task) async {
    int taskIndex = _tasks.indexWhere((t) => t.taskId == task.taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = TaskEntity(
        taskName: task.taskName,
        taskFolderName: task.taskFolderName,
        tomatoes: task.tomatoes,
        taskText: task.taskText,
        taskDate: task.taskDate,
        completed: task.completed,
        taskId: task.taskId,
      );
      await repository.updateTask(task);
      notifyListeners();
    }
  }

  Future<void> incrementTomato(TaskEntity task) async {
    task.tomatoes += 1;
    await repository.updateTask(task); // Обновляем задачу в хранилище
    notifyListeners();
  }

  Future<void> changeCompletedStatus(TaskEntity task) async {
    int taskIndex = _tasks.indexWhere((t) => t.taskId == task.taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = TaskEntity(
        taskName: task.taskName,
        taskFolderName: task.taskFolderName,
        tomatoes: task.tomatoes,
        taskText: task.taskText,
        taskDate: task.taskDate,
        completed: !task.completed,
        taskId: task.taskId,
      );
      await repository.changeCompletedStatus(task);
      notifyListeners();
    }
  }

  // Добавление задачи
  Future<void> addTask(String taskName, String? taskFolderName, String taskText, DateTime? taskDate) async {
    TaskEntity task = TaskEntity(
      taskId: DateTime.now().millisecondsSinceEpoch,
      taskName: taskName,
      taskFolderName: taskFolderName ?? 'Сегодня',
      tomatoes: 0,
      taskText: taskText,
      taskDate: taskDate ?? DateTime.now(),
      completed: false,
    );
    await repository.addTask(task);
    _tasks.add(task); // Добавляем задачу в список
    notifyListeners(); // Уведомляем слушателей об изменениях
  }

  // Получение задач по имени папки
  Future<List<TaskEntity>> getTasksByFolderName(String taskFolderName) async {
    return await repository.getTasksByFolderName(taskFolderName);
  }

  // Удаление задачи
  Future<void> deleteTask(int taskId) async {
    _tasks.removeWhere((task) => task.taskId == taskId);
    await repository.deleteTask(taskId);
    notifyListeners();
  }
}
