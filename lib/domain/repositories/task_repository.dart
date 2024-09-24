import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<void> addTask(TaskEntity task);
  Future<List<TaskEntity>> getTasks();
  Future<List<TaskEntity>> getTasksByFolderName(String taskFolderName);
  Future<void> deleteTask(int taskId);
  Future<void> changeCompletedStatus(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
}
