import 'package:Camera/features/camera/domain/entities/appbar_components/aspect_ratio.dart';
import 'package:Camera/features/camera/domain/entities/appbar_components/flash.dart';
import 'package:Camera/features/camera/domain/entities/body_components/flip_camera.dart';
import 'package:Camera/features/camera/domain/entities/body_components/gestures.dart';
import 'package:Camera/features/camera/domain/entities/appbar_components/gridlines.dart';
import 'package:Camera/features/camera/domain/entities/appbar_components/timer.dart';
import 'package:Camera/features/camera/domain/entities/body_components/take_picture.dart';
import 'package:Camera/features/camera/domain/crop_to_aspect_ratio.dart';
import 'package:Camera/features/camera/provider/camera_state.dart';
import 'package:Camera/config/themes/app_color.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:Camera/main.dart';
import 'package:provider/provider.dart';

//TODO: Flash turn off before done capturing
//TODO: Optimize capturing speed
//TODO: Try to use camera plugin instead of camera package

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> with WidgetsBindingObserver {
  late CameraController _controller;

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
    return Consumer<CameraProvider>(
      builder: (context, cameraProvider, child) {
        final int timerDuration = cameraProvider.timerDuration;
        return Scaffold(
          backgroundColor: AppColor.black,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close)),
              const SizedBox(width: 10),
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const AspectRatioButton(),
                FlashButton(controller: _controller),
                const GridLinesButton(),
                const TimerButton()
              ],
            ),
          ),
          body: Stack(children: [
            Gestures(
              controller: _controller,
              child: AspectRatio(
                aspectRatio: cameraProvider.aspectRatio,
                child: ClipRect(
                  child: CustomPaint(
                    foregroundPainter:
                        cameraProvider.onGrid ? GridPainter() : null,
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
              child: TakePictureButton(
                controller: _controller,
                onPictureTaken: (file) async {
                  debugPrint("done take picture");
                  var newFile = await cropToAspectRatio(context, file);
                  cameraProvider.capturedImage = newFile;
                  if (context.mounted) {
                    Navigator.pushNamed(context, '/Image Preview',
                        arguments: cameraProvider);
                  }
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsetsDirectional.only(end: 40, bottom: 90),
              child: FlipCameraButton(
                controller: _controller,
                onCameraFlip: (newController) {
                  setState(() {
                    _controller = newController;
                  });
                },
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 150),
                Center(
                  child: timerDuration != 0
                      ? Text('$timerDuration',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 80))
                      : Container(),
                ),
              ],
            ),
          ]),
        );
      },
    );
  }
}
