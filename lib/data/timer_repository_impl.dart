import 'dart:async';

import 'package:pomodoro/presentation/providers/task_provider.dart';

import '../domain/entities/timer_entity.dart';
import '../domain/repositories/timer_repository.dart';

class TimerRepositoryImpl implements TimerRepository {
  bool _isRunning = false;
  TimerEntity timerEntity;
  Timer? _timer;
  final StreamController<double> _progressController = StreamController.broadcast();

  TimerRepositoryImpl(this.timerEntity);

  @override
  void startTimer(String? selectedTaskId,TaskProvider? taskProvider) {
    _isRunning = true;
    timerEntity.isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerEntity.remainingTime > 0) {
        timerEntity.remainingTime--;
        timerEntity.progress = timerEntity.remainingTime / timerEntity.totalTime;
        _progressController.add(timerEntity.progress);
      } else {
        if (timerEntity.totalTime == 25 * 60) {
          timerEntity.totalTime = 5 * 60;
          timerEntity.remainingTime = 5 * 60;
          if (selectedTaskId != null) {
            final selectedTask = taskProvider!.tasks.firstWhere((task) => task.taskId == selectedTaskId);
            taskProvider.incrementTomato(selectedTask);
          }
        } else if (timerEntity.totalTime == 5 * 60) {
          timerEntity.totalTime = 25 * 60;
          timerEntity.remainingTime = 25 * 60;
        }

        timerEntity.progress = timerEntity.remainingTime / timerEntity.totalTime;
        _progressController.add(timerEntity.progress);
        _isRunning = false;
        pauseTimer();
      }
    });
  }

  @override
  void pauseTimer() {
    _isRunning = false;
    _timer?.cancel();
    timerEntity.isRunning = false;
  }


  @override
  void cancelTimer() {
    pauseTimer();
    timerEntity.remainingTime = timerEntity.totalTime;
    timerEntity.progress = timerEntity.remainingTime / timerEntity.totalTime;
    _progressController.add(timerEntity.progress);
  }

  @override
  void toggleTimer(String? selectedTaskId,TaskProvider? taskProvider) {
    if (_isRunning) {
      pauseTimer();
    } else {
      startTimer(selectedTaskId,taskProvider);
    }
  }

  @override
  String getFormattedTime() {
    int minutes = timerEntity.remainingTime ~/ 60;
    int seconds = timerEntity.remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  @override
  Stream<double> get progressStream => _progressController.stream;

  @override
  bool get isRunning => _isRunning;  // Implement the isRunning getter
}
