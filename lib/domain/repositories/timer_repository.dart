import '../../presentation/providers/task_provider.dart';

abstract class TimerRepository {
  void startTimer(String? selectedTaskId,TaskProvider? taskProvider);
  void pauseTimer();
  void cancelTimer();
  void toggleTimer(String? selectedTaskId, TaskProvider? taskProvider);
  String getFormattedTime();
  Stream<double> get progressStream;
  bool get isRunning;
}
