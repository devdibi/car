// import 'dart:math';
// import 'package:car_project/assets/h2.dart';
// import 'package:car_project/common_widgets/space_height.dart';
// import 'package:flutter/material.dart';
//
// class ContinuousProgressRing extends StatefulWidget {
//   final double radius;
//   final Color color;
//   final Color backgroundColor;
//   final double strokeWidth;
//
//   ContinuousProgressRing({
//     required this.radius,
//     required this.color,
//     this.backgroundColor = Colors.grey,
//     this.strokeWidth = 20.0,
//   });
//
//   @override
//   _ContinuousProgressRingState createState() => _ContinuousProgressRingState();
// }
//
// class _ContinuousProgressRingState extends State<ContinuousProgressRing> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1),
//     )..repeat();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size.fromRadius(widget.radius),
//       painter: _RingPainter(
//         animation: _animationController,
//         color: widget.color,
//         backgroundColor: widget.backgroundColor,
//         strokeWidth: widget.strokeWidth,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
// }
//
// class _RingPainter extends CustomPainter {
//   final Animation<double> animation;
//   final double strokeWidth;
//   final Color color;
//   final Color backgroundColor;
//
//   _RingPainter({
//     required this.animation,
//     required this.strokeWidth,
//     required this.color,
//     required this.backgroundColor,
//   }) : super(repaint: animation);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = backgroundColor
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;
//
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = min(size.width, size.height) / 2 - strokeWidth / 2;
//
//     canvas.drawCircle(center, radius, paint);
//
//     final progressPaint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;
//
//     final sweepAngle = 2 * pi * animation.value;
//
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       -pi / 2,
//       sweepAngle,
//       false,
//       progressPaint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }