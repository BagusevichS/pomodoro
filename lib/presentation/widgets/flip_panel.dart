import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlipPanel extends StatelessWidget {
  final String value; // Значение для отображения (например, "1234")
  final Color digitColor; // Цвет цифр
  final Color backgroundColor; // Цвет фона
  final double digitSize; // Размер цифр
  final double height; // Высота панели
  final double width; // Ширина панели

  FlipPanel({
    Key? key,
    required this.value,
    required this.digitColor,
    required this.backgroundColor,
    this.digitSize = 48.0,
    this.height = 100.0,
    this.width = 60.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: value.replaceAll(':', '').split('').map((char) { // Убираем ':'
        return _buildFlipDigit(char);
      }).toList(),
    );
  }

  Widget _buildFlipDigit(String digit) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 450),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final flipAnimation = Tween(begin: 0.0, end: math.pi).animate(animation);
          return AnimatedBuilder(
            animation: flipAnimation,
            builder: (context, child) {
              final isUnder = (flipAnimation.value > math.pi / 2);
              final tilt = isUnder ? math.pi : 0.0;
              final transform = Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(flipAnimation.value + tilt);
              return Transform(
                transform: transform,
                alignment: Alignment.center,
                child: child,
              );
            },
            child: child,
          );
        },
        child: Container(
          key: ValueKey(digit), // Используем digit как ключ для анимации
          alignment: Alignment.center,
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0), // Закругленные края
          ),
          child: Text(
            digit,
            style: TextStyle(
              fontSize: digitSize,
              fontWeight: FontWeight.bold,
              color: digitColor,
            ),
          ),
        ),
      ),
    );
  }
}
