import 'package:flutter/material.dart';
import 'package:pomodoro/domain/entities/task_entity.dart';
import 'package:pomodoro/presentation/pages/task_info.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskTile extends StatelessWidget {
  final void Function() onTap;
  final TaskEntity task;
  const TaskTile(
      {super.key,
      required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.6), width: 1.25),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8.0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.taskName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  task.taskFolderName,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 3.0),
                Text(
                  'Проведено помидоров: ${task.tomatoes}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            Checkbox(
              activeColor: Colors.green,
              value: task.completed,
              onChanged: (value) {
                taskProvider.changeCompletedStatus(task);
              },
            )
          ],
        ),
      ),
    );
  }
}
