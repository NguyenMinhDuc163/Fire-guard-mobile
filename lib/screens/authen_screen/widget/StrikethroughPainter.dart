import 'dart:math';

import 'package:flutter/material.dart';

class StrikethroughPainter extends CustomPainter {
  final String captchaText;
  final List<Offset> _lineOffsets;

  StrikethroughPainter(this.captchaText) : _lineOffsets = _generateLineOffsets();

  static List<Offset> _generateLineOffsets() {
    Random random = Random();
    List<Offset> offsets = [];


    double widthLimit = 80;
    double heightLimit = 40;

    for (int i = 0; i < 5; i++) {
      double startX = random.nextDouble() * widthLimit;
      double startY = random.nextDouble() * heightLimit;
      double endX = random.nextDouble() * widthLimit;
      double endY = random.nextDouble() * heightLimit;
      offsets.add(Offset(startX, startY));
      offsets.add(Offset(endX, endY));
    }
    return offsets;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red.withOpacity(0.6)
      ..strokeWidth = 2;


    for (int i = 0; i < _lineOffsets.length; i += 2) {
      if (i + 1 < _lineOffsets.length) {
        canvas.drawLine(_lineOffsets[i], _lineOffsets[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
