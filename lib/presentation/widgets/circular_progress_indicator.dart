import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/timer_provider.dart';
import 'clock_dial_painter.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final String? selectedTaskId;
  final TaskProvider? taskProvider;
  const CustomCircularProgressIndicator({super.key, this.selectedTaskId, this.taskProvider});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: (){timerProvider.toggleTimer(selectedTaskId,taskProvider);},
      onLongPress: timerProvider.cancelTimer,
      child: StreamBuilder<double>(
          stream: timerProvider.progressStream,
          initialData: 1.0,
        builder: (context, snapshot) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: width / 1.5,
                height: width / 1.5,
                child: CustomPaint(
                  painter: ClockDialPainter(), // Рисуем риски
                ),
              ),
              SizedBox(
                width: width / 1.5,
                height: width / 1.5,
                child: Transform.scale(
                  scaleX: -1, // Чтобы индикатор уходил по часовой
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    value: snapshot.data,
                    backgroundColor: Colors.transparent,
                    color: Colors.white,
                  ),
                )
              ),
              // Time display
              Text(
                timerProvider.getFormattedTime(),
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
              // Play/Pause icon
              Padding(
                padding: EdgeInsets.only(top: width / 3),
                child: Icon(
                  timerProvider.repository.isRunning ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}



