class TimerEntity {
  int totalTime;
  int remainingTime;
  bool isRunning;
  double progress;

  TimerEntity({required this.totalTime, required this.remainingTime, this.isRunning = false, this.progress = 1.0});
}
