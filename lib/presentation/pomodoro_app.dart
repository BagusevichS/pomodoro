import 'package:flutter/material.dart';
import 'package:pomodoro/presentation/pages/add_task_page.dart';
import 'package:pomodoro/presentation/pages/full_screen_page.dart';
import 'package:pomodoro/presentation/pages/strict_mode_page.dart';
import 'package:pomodoro/presentation/pages/task_info.dart';
import 'package:pomodoro/presentation/pages/white_noise_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro/data/task_repository_impl.dart'; // Импорт TaskRepositoryImpl
import 'package:pomodoro/domain/entities/timer_entity.dart';
import 'package:pomodoro/presentation/pages/main_page.dart';
import 'package:pomodoro/presentation/providers/task_provider.dart';
import 'package:pomodoro/presentation/providers/timer_provider.dart';
import 'package:pomodoro/data/timer_repository_impl.dart';

void main() {
  runApp(PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({Key? key}) : super(key: key);

  Future<SharedPreferences> _initSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _initSharedPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Ошибка инициализации')),
            ),
          );
        } else {
          final sharedPreferences = snapshot.data!;

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => TimerProvider(
                  TimerRepositoryImpl(
                    TimerEntity(totalTime: 25 * 60, remainingTime: 25 * 60),
                  ),
                ),
              ),
              ChangeNotifierProvider(
                create: (_) => TaskProvider(
                  repository: TaskRepositoryImpl(sharedPreferences: sharedPreferences),
                ),
              ),
            ],
            child: MaterialApp(
              routes: {
                '/strictMode': (context) => StrictModePage(),
                '/whiteNoise': (context) => WhiteNoisePage(),
                '/fullScreen': (context) => FullScreenPage(),
                '/addTask' : (context) => AddTaskPage(),
              },
              theme: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                appBarTheme: const AppBarTheme(
                  color: Colors.transparent,
                  elevation: 0,
                  foregroundColor: Colors.white,
                  iconTheme: IconThemeData(size: 30, color: Colors.white),
                ),
                scaffoldBackgroundColor: Colors.deepOrange,
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  enableFeedback: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedLabelStyle: TextStyle(color: Colors.white, fontSize: 14),
                  unselectedLabelStyle: TextStyle(color: Colors.white, fontSize: 14),
                  selectedIconTheme: IconThemeData(size: 30),
                  unselectedIconTheme: IconThemeData(size: 30),
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white,
                ),
              ),
              home: MainPage(),
            ),
          );
        }
      },
    );
  }
}
