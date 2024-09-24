import 'package:flutter/material.dart';
import 'package:pomodoro/presentation/providers/task_provider.dart';
import '../../domain/repositories/timer_repository.dart';

class TimerProvider with ChangeNotifier {
  final TimerRepository repository;

  TimerProvider(this.repository);
  bool isRunning = false;

  Stream<double> get progressStream => repository.progressStream;

  void toggleTimer(String? selectedTaskId,TaskProvider? taskProvider) {
    repository.toggleTimer(selectedTaskId,taskProvider);
    notifyListeners();
  }

  void startTimer(String? selectedTaskId,TaskProvider? taskProvider) {
    repository.startTimer(selectedTaskId,taskProvider);
    notifyListeners();
  }

  void pauseTimer() {
    repository.pauseTimer();
    notifyListeners();
  }

  void cancelTimer(){
    repository.cancelTimer();
    notifyListeners();
  }

  String getFormattedTime() {
    return repository.getFormattedTime();
  }
}
