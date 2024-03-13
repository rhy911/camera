import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0;

    int gridCount =
        3; // Change this number to increase or decrease the number of grid lines

    double stepSizeWidth = size.width / gridCount;
    double stepSizeHeight = size.height / gridCount;

    for (int i = 1; i < gridCount; i++) {
      canvas.drawLine(Offset(0, stepSizeHeight * i),
          Offset(size.width, stepSizeHeight * i), paint);
      canvas.drawLine(Offset(stepSizeWidth * i, 0),
          Offset(stepSizeWidth * i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
