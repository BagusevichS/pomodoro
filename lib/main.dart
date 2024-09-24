import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro/presentation/pomodoro_app.dart';

void main() {
  runApp(const PomodoroApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
}
