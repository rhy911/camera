import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Gestures extends StatefulWidget {
  const Gestures({super.key, required this.controller, required this.child});
  final CameraController controller;
  final Widget child;
  @override
  State<Gestures> createState() => _GesturesState();
}

class _GesturesState extends State<Gestures> {
  bool isAutoFocus = true;
  late double x, y;
  late double scale;
  double zoom = 1.0;
  double minZoom = 0.0;
  double maxZoom = 10.0;

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.value.isInitialized) {
      return Container();
    }
    return GestureDetector(
        onScaleUpdate: (details) {
          scale = details.scale;
          if (scale != 1) {
            zoom = scale.clamp(0.0, 10.0);
            widget.controller.setZoomLevel(zoom);
          }
        },
        onTapUp: (details) {
          if (scale == 1) {
            _onTap(details);
          }
        },
        child: Stack(
          children: [
            widget.child,
            if (!isAutoFocus)
              Positioned(
                  top: y - 30,
                  left: x - 30,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.white, width: 1.5)),
                  ))
          ],
        ));
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (widget.controller.value.isInitialized) {
      isAutoFocus = false;
      x = details.localPosition.dx;
      y = details.localPosition.dy;

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * widget.controller.value.aspectRatio;

      double xp = x / fullWidth;
      double yp = y / cameraHeight;

      Offset point = Offset(xp, yp);

      await widget.controller.setFocusPoint(point);
      widget.controller.setExposurePoint(point);

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
