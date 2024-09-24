import 'package:flutter/material.dart';
import 'package:pomodoro/domain/entities/task_entity.dart';

class TaskInfo extends StatelessWidget {
  final TaskEntity task;
  const TaskInfo({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final TextEditingController _controller =
        TextEditingController(text: task.taskText);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          task.taskName,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.orange),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                readOnly: true,
                maxLines: null,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none, // убираем рамки для текста
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
