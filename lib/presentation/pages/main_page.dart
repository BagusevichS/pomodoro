import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro/presentation/widgets/circular_progress_indicator.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'menu_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<String> names = [/*'/strictMode',*/ '/fullScreen', '/whiteNoise'];
  String? selectedTaskId; // Используем для хранения ID выбранной задачи

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void push(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pushNamed(names[_selectedIndex]);
  }

  void _selectTask(BuildContext context) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final task = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Задачи',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/addTask');
                        },
                        child: Icon(Icons.add))
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];
                    return ListTile(
                      title: Text(task.taskName),
                      onTap: () {
                        Navigator.of(context).pop(task.taskId.toString());
                      },
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Закрыть'),
              ),
            ],
          ),
        );
      },
    );
    if (task != null) {
      setState(() {
        selectedTaskId = task; // Сохраняем ID выбранной задачи
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var heigth = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // Wrapping in a Consumer to rebuild when the task changes
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        MenuPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              icon: const Icon(Icons.keyboard_arrow_up_rounded)),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: push,
          currentIndex: _selectedIndex,
          items: const [
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.eco,
            //   ),
            //   label: 'Строгий режим',
            // ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.open_in_full,
              ),
              label: 'На весь экран',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.music_note_rounded,
              ),
              label: 'Белый шум',
            ),
          ],
        ),
        body: Consumer<TaskProvider>( // Listening for changes in TaskProvider
          builder: (context, taskProvider, child) {
            // Ищем задачу по выбранному taskId
            final selectedTask = selectedTaskId != null
                ? taskProvider.tasks
                .firstWhere((task) => task.taskId.toString() == selectedTaskId)
                : null;
            return Padding(
              padding: EdgeInsets.only(top: heigth / 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: [
                    CustomCircularProgressIndicator(
                      selectedTaskId: selectedTaskId, // Передаем выбранную задачу в индикатор
                    ),
                    SizedBox(
                      height: heigth / 10,
                    ),
                    selectedTaskId != null
                        ? GestureDetector(
                      onTap: () {
                        _selectTask(context);
                      },
                      child: Container(
                        width: width / 1.5,
                        height: width / 10,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black.withOpacity(0.7), width: 1.5),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Чекбокс для выполнения задачи
                            Checkbox(
                              activeColor: Colors.green,
                              value: selectedTask!.completed,
                              onChanged: (bool? value) {
                                taskProvider.changeCompletedStatus(selectedTask);
                              },
                            ),
                            Expanded( // Чтобы текст не перекрывался с иконкой крестика
                              child: Text(
                                selectedTask.taskName,
                                style: TextStyle(color: Colors.black, fontSize: 16),
                                overflow: TextOverflow.ellipsis, // Обрезаем текст, если он слишком длинный
                              ),
                            ),
                            // Крестик для снятия задачи
                            IconButton(
                              icon: Icon(Icons.highlight_off, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  selectedTaskId = null; // Убираем выбранную задачу
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                        : GestureDetector(
                        onTap: () {
                          _selectTask(context);
                        },
                        child: Container(
                          width: width / 1.5,
                          height: width / 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.black.withOpacity(0.2)),
                          child: Center(
                              child: Text(
                                'Выбрать задачу',
                                style: TextStyle(
                                    fontFamily: 'SansItalic',
                                    fontSize: 20,
                                    color: Colors.white.withOpacity(0.6)),
                              )),
                        ))
                  ]),
                ],
              ),
            );
          },
        ));
  }
}
