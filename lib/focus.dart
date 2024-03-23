import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ManualFocus extends StatefulWidget {
  const ManualFocus({super.key});

  @override
  State<ManualFocus> createState() => _ManualFocusState();
}

class _ManualFocusState extends State<ManualFocus> {
  late CameraController controller;
  bool isAutoFocus = true;
  late double x, y;
  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return GestureDetector(
        onTapUp: (details) {
          _onTap(details);
        },
        child: Stack(
          children: [
            Center(child: CameraPreview(controller)),
            if (!isAutoFocus)
              Positioned(
                  top: y - 20,
                  left: x - 20,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5)),
                  ))
          ],
        ));
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (controller.value.isInitialized) {
      isAutoFocus = false;
      x = details.localPosition.dx;
      y = details.localPosition.dy;

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * controller.value.aspectRatio;

      double xp = x / fullWidth;
      double yp = y / cameraHeight;

      Offset point = Offset(xp, yp);
      print("point : $point");

      await controller.setFocusPoint(point);
      controller.setExposurePoint(point);

      setState(() {
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            isAutoFocus = true;
          });
        });
      });
    }
  }
}
