import 'package:flutter/material.dart';
class WhiteNoisePage extends StatefulWidget {
  const WhiteNoisePage({Key? key}) : super(key: key);

  @override
  State<WhiteNoisePage> createState() => _WhiteNoisePageState();
}

class _WhiteNoisePageState extends State<WhiteNoisePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('RumoreBianco'),),
    );
  }
}
