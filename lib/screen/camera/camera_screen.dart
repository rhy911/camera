import 'package:Camera/components/camera_function/aspect_ratio.dart';
import 'package:Camera/components/camera_function/gestures.dart';
import 'package:Camera/components/camera_function/gridlines.dart';
import 'package:Camera/components/camera_function/timer.dart';
import 'package:Camera/screen/camera/image_preview.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:Camera/main.dart';

enum Flashmode { auto, off, on }

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> with WidgetsBindingObserver {
  late CameraController _controller;
  bool _isRearCameraSelected = true;

  Flashmode _flashmode = Flashmode.auto;
  double _aspectRatio = 9 / 16;
  bool _onGrid = false;
  int _timerDuration = 0;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            debugPrint("Camera Access Denied");
            break;
          default:
            debugPrint(e.description);
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = _controller;

    if (!cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          Padding(
            //Aspect ratio button
            padding: const EdgeInsets.all(10.0),
            child: MyButton(
              _aspectRatio,
              (newAspectRatio) {
                setState(() {
                  _aspectRatio = newAspectRatio;
                });
              },
            ),
          ),
          IconButton(
            //Flash button
            padding: const EdgeInsets.all(10),
            onPressed: () {
              setState(() {
                _flashmode = Flashmode
                    .values[(_flashmode.index + 1) % Flashmode.values.length];
              });
            },
            icon: _flashmode == Flashmode.on
                ? const Icon(Icons.flash_on_rounded)
                : _flashmode == Flashmode.off
                    ? const Icon(Icons.flash_off_rounded)
                    : const Icon(Icons.flash_auto_rounded),
          ),
          IconButton(
            //Grid button
            padding: const EdgeInsets.all(10),
            onPressed: () {
              setState(() {
                _onGrid = !_onGrid;
              });
            },
            icon: _onGrid
                ? const Icon(Icons.grid_on_sharp)
                : const Icon(Icons.grid_off_sharp),
          ),
          Padding(
            //Timer button
            padding: const EdgeInsets.all(20.0),
            child: TimerButton(onDurationChanged: (int duration) {
              setState(() {
                _timerDuration = duration;
              });
            }),
          )
        ],
      ),
      body: Stack(children: [
        Gestures(
          controller: _controller,
          child: AspectRatio(
            aspectRatio: _aspectRatio,
            child: ClipRect(
              child: CustomPaint(
                foregroundPainter: _onGrid ? GridPainter() : null,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.previewSize?.height,
                    height: _controller.value.previewSize?.width,
                    child: CameraPreview(_controller),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsetsDirectional.only(bottom: 80),
          child: IconButton(
            onPressed: () async {
              if (!_controller.value.isInitialized) {
                return;
              }
              if (_controller.value.isTakingPicture) {
                return;
              }
              try {
                await _controller.setFlashMode(
                  _flashmode == Flashmode.on
                      ? FlashMode.always
                      : _flashmode == Flashmode.off
                          ? FlashMode.off
                          : FlashMode.auto,
                );
                XFile? file;

                int initialTimer = _timerDuration;
                await startTimer(_timerDuration, (remainingTime) {
                  setState(() {
                    _timerDuration = remainingTime;
                  });
                });
                if (_timerDuration == 0) {
                  file = await _controller.takePicture();
                  setState(() {
                    _timerDuration = initialTimer; // Reset the timer
                  });
                }
                if (context.mounted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImagePreview(
                              file!, _aspectRatio, _isRearCameraSelected)));
                }
              } on CameraException catch (e) {
                debugPrint("Error occured while taking photo : $e");
                return;
              }
            },
            iconSize: 85,
            icon: const Icon(Icons.circle_outlined),
          ),
        ),
        Container(
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsetsDirectional.only(start: 40, bottom: 90),
          child: IconButton(
            onPressed: () async {
              if (_controller.value.isInitialized) {
                await _controller.dispose();
              }

              setState(() {
                _isRearCameraSelected = !_isRearCameraSelected;
              });

              CameraDescription selectedCamera =
                  _isRearCameraSelected ? cameras[0] : cameras[1];
              _controller = CameraController(
                selectedCamera,
                ResolutionPreset.max,
              );
              try {
                await _controller.initialize();
              } catch (e) {
                debugPrint('Error initializing camera: $e');
                // Handle the error as appropriate for your app.
              }

              if (mounted) {
                setState(() {});
              }
            },
            icon: const Icon(Icons.flip_camera_ios_outlined, size: 50),
            padding: const EdgeInsets.all(10),
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: _timerDuration != 0
              ? Text('$_timerDuration',
                  style: Theme.of(context).primaryTextTheme.bodyMedium)
              : Container(),
        ),
      ]),
    );
  }
}
