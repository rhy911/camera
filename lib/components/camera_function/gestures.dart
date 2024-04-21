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
  bool _isAutoFocus = true;
  double _exposureLevel = 0.0;

  late double x, y;
  double _scale = 1.0;
  double _previousScale = 1.0;
  bool _isScailing = false;
  double _zoom = 1.0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (widget.controller.value.isInitialized) {
      _isAutoFocus = false;
      x = details.localPosition.dx;
      y = details.localPosition.dy;

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * widget.controller.value.aspectRatio;

      double xp = x / fullWidth;
      double yp = y / cameraHeight;

      Offset point = Offset(xp, yp);

      await widget.controller.setFocusPoint(point);
      if (_exposureLevel == 0) {
        widget.controller.setExposurePoint(point);
      }

      setState(() {
        Future.delayed(const Duration(seconds: 10)).whenComplete(() {
          setState(() {
            _isAutoFocus = true;
          });
        });
      });
    }
  }

  void reset() {
    setState(() {
      _zoom = 1.0;
      _scale = 1.0;
      _previousScale = 1.0;
      _isAutoFocus = true;
      _exposureLevel = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.value.isInitialized) {
      reset();
      return Container();
    }

    return GestureDetector(
        onScaleStart: (details) {
          _previousScale = _zoom;
          _isScailing = true;
        },
        onScaleUpdate: (details) {
          double newScale = _previousScale * details.scale;
          if ((newScale - _scale).abs() > 0.1) {
            setState(() {
              _scale = newScale;
              _zoom = _scale.clamp(1.0, 10.0);
              widget.controller.setZoomLevel(_zoom);
            });
          }
        },
        onScaleEnd: (details) {
          _isScailing = false;
        },
        onTapUp: (details) {
          if (!_isScailing) {
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
                    child: Text("Zoom: ${_zoom.toStringAsFixed(1)}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0)),
                  ),
                ),
              ],
            ),
            if (!_isAutoFocus)
              Stack(
                children: [
                  Positioned(
                      top: y - 30,
                      left: x - 30,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border:
                                Border.all(color: Colors.white, width: 1.5)),
                      )),
                  Positioned(
                    top: y - 60,
                    left: x + 20,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: SizedBox(
                        width: 120,
                        child: SliderTheme(
                          data: const SliderThemeData(
                            trackHeight: 2.0,
                            trackShape: RoundedRectSliderTrackShape(),
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 5.0),
                            thumbColor: Colors.white,
                          ),
                          child: Slider(
                            value: _exposureLevel,
                            min: -5.0,
                            max: 5.0,
                            onChanged: (newValue) {
                              setState(() {
                                _exposureLevel = newValue;
                                widget.controller
                                    .setExposureOffset(_exposureLevel);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
          ],
        ));
  }
}
