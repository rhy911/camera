import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Gestures extends StatefulWidget {
  const Gestures({
    super.key,
    required this.controller,
    required this.child,
  });
  final CameraController controller;
  final Widget child;

  @override
  State<Gestures> createState() => _GesturesState();
}

class _GesturesState extends State<Gestures> {
  bool isAutoFocus = true;
  late double x, y;
  double scale = 1.0;
  double previousScale = 1.0;
  bool isScailing = false;
  double zoom = 1.0;
  double minZoom = 0.0;
  double maxZoom = 10.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.value.isInitialized) {
      resetZoom();
      return Container();
    }

    return GestureDetector(
        onScaleStart: (details) {
          previousScale = zoom;
          isScailing = true;
        },
        onScaleUpdate: (details) {
          double newScale = previousScale * details.scale;
          if ((newScale - scale).abs() > 0.1) {
            setState(() {
              scale = newScale;
              zoom = scale.clamp(1.0, 10.0);
              widget.controller.setZoomLevel(zoom);
            });
          }
        },
        onScaleEnd: (details) {
          isScailing = false;
        },
        onTapUp: (details) {
          if (!isScailing) {
            _onTap(details);
          }
        },
        child: Stack(
          children: [
            widget.child,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Zoom: ${zoom.toStringAsFixed(1)}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0)),
                  ),
                ),
              ],
            ),
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

  void resetZoom() {
    setState(() {
      zoom = 1.0;
      scale = 1.0;
      previousScale = 1.0;
    });
  }
}
