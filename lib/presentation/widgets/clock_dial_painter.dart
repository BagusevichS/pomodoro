import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ClockDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0 // Толщина рисок
      ..strokeCap = StrokeCap.round // Закругляем концы рисок
      ..style = PaintingStyle.stroke;

    double radius = size.width / 2;
    canvas.translate(radius, radius); // Сдвигаем центр в центр холста

    // Рисуем больше рисок (например, 120 рисок по периметру)
    for (int i = 0; i < 120; i++) {
      double angle = (i * pi / 60); // 120 делений, шаг каждые 3 градуса
      final x1 = radius * cos(angle);
      final y1 = radius * sin(angle);
      final x2 = (radius - 0.0) * cos(angle); // Все риски одинаковой длины
      final y2 = (radius - 0.0) * sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}