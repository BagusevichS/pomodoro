import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  // Контроллеры для текстовых полей
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskTextController = TextEditingController();

  @override
  void dispose() {
    // Освобождаем контроллеры при удалении виджета
    _taskNameController.dispose();
    _taskTextController.dispose();
    super.dispose();
  }

  // Метод для сохранения задачи
  void _saveTask(BuildContext context) {
    final taskName = _taskNameController.text.trim();
    final taskText = _taskTextController.text.trim();

    if (taskName.isEmpty) {
      // Если название задачи не введено, показываем предупреждение
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, введите название задачи')),
      );
      return;
    }

    // Получаем доступ к TaskProvider и сохраняем задачу
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.addTask(taskName, null, taskText, null).then((_) {
      // После сохранения задачи возвращаемся на предыдущий экран
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.orange),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  _saveTask(context);
                },
                child: Text(
                  'Готово',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _taskNameController,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'Введите название задачи',
                hintStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              cursorColor: Colors.black,
            ),
            SizedBox(height: 20),
            // Поле для ввода описания задачи
            Expanded(
              child: TextField(
                controller:
                    _taskTextController, // Привязываем контроллер для описания задачи
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Введите описание задачи',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
