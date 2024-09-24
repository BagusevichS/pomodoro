class TaskEntity {
  int taskId;
  String taskName;
  String taskFolderName;
  int tomatoes;
  String taskText;
  DateTime taskDate;
  bool completed;

  TaskEntity({
    required this.taskId,
    required this.taskName,
    required this.taskFolderName,
    required this.tomatoes,
    required this.taskText,
    required this.taskDate,
    required this.completed
  });
}
