import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
class CountdownTimer extends StatefulWidget {
  const CountdownTimer({Key? key}) : super(key: key);


  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.height;
    final timerProvider = Provider.of<TimerProvider>(context);
    return StreamBuilder(stream: timerProvider.progressStream, builder: (context, snapshot){
      return Center(
        child: Text(timerProvider.getFormattedTime(),style: TextStyle(
          fontSize: width/3,
          color: Colors.white,
          fontFamily: 'DSEG'
        ),),
      );
    });
  }
}
