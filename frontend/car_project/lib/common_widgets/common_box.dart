import 'package:flutter/material.dart';

class BoundingBoxPainter extends CustomPainter {
  final double xMin;
  final double xMax;
  final double yMin;
  final double yMax;

  BoundingBoxPainter(this.xMin, this.xMax, this.yMin, this.yMax);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    double width = xMax - xMin;
    double height = yMax - yMin;

    canvas.drawRect(
      Rect.fromLTRB(xMin, yMin, xMax, yMax),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}