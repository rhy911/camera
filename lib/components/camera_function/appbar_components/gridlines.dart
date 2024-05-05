import 'package:Camera/provider/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridLinesButton extends StatefulWidget {
  const GridLinesButton({super.key});

  @override
  State<GridLinesButton> createState() => _GridButtonState();
}

class _GridButtonState extends State<GridLinesButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(10),
      onPressed: () {
        Provider.of<CameraState>(context, listen: false).toggleGrid();
      },
      icon: Provider.of<CameraState>(context).onGrid
          ? const Icon(Icons.grid_on_sharp)
          : const Icon(Icons.grid_off_sharp),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0;

    int gridCount = 3;

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
