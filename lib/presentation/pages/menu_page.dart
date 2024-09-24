import 'package:flutter/material.dart';
import 'package:pomodoro/presentation/pages/task_info.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_provider.dart';
import '../providers/timer_provider.dart';
import '../widgets/task_tile.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          Navigator.of(context).pushNamed('/addTask');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: Navigator.of(context).pop,
                    child: Container(
                      width: width / 4,
                      height: width / 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.deepOrange,
                      ),
                      child: StreamBuilder<double>(
                        stream: timerProvider.progressStream,
                        builder: (context, snapshot) {
                          return Center(
                            child: Text(
                              timerProvider.getFormattedTime(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'DSEG',
                                  fontSize: 18),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // Добавим промежуток
              Expanded(
                child: Consumer<TaskProvider>(
                  builder: (context, taskProvider, child) {
                    final tasks = taskProvider.tasks;
                    if (tasks.isEmpty) {
                      return Center(
                        child: Text('Нет задач'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[tasks.length - 1 - index];
                          return Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Dismissible(
                              key: Key(task.taskId.toString()), // Уникальный ключ для каждого элемента
                              direction: DismissDirection.endToStart, // Смахивание влево
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12)
                                ),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                // Удаляем задачу из провайдера
                                taskProvider.deleteTask(task.taskId);

                                // Показываем сообщение после удаления
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Задача ${task.taskName} удалена')),
                                );
                              },
                              child: Column(
                                children: [
                                  TaskTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TaskInfo(task: task),
                                        ),
                                      );
                                    },
                                    task: task,
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
