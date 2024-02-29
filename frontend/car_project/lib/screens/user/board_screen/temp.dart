import 'package:flutter/material.dart';

class BoundingBoxPainter extends CustomPainter {
  final double xMin;
  final double xMax;
  final double yMin;
  final double yMax;

  BoundingBoxPainter(this.xMin, this.xMax, this.yMin, this.yMax);

  @override
  void paint(Canvas canvas, Size size) {
    Paint outlinePaint = Paint()
      ..color = Colors.red // 선의 색상을 빨간색으로 설정
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke; // 선으로 설정

    Paint fillPaint = Paint()
      ..color = Color.fromRGBO(255, 255, 255, 0.5) // 내부의 색상을 흰색으로 설정하고 투명도를 조절
      ..style = PaintingStyle.fill; // 내부를 채우는 스타일로 변경

    double width = xMax - xMin;
    double height = yMax - yMin;

    // 내부를 채우는 사각형 그리기
    canvas.drawRect(
      Rect.fromLTRB(xMin, yMin, xMax, yMax),
      fillPaint,
    );

    // 외곽선을 그리는 사각형 그리기
    canvas.drawRect(
      Rect.fromLTRB(xMin, yMin, xMax, yMax),
      outlinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}