// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:test_project/aspect_ratio.dart';
import 'package:test_project/camera_screen.dart';
import 'package:test_project/gridlines.dart';
import 'package:test_project/timer.dart';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraApp(),
    );
  }
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController _controller;
  late bool _onFlash = false;
  late double _aspectRatio = 9 / 16;
  bool _onGrid = false;
  bool _setTimer = false;
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
            print("access was denied");
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 90.0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
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
            padding: const EdgeInsets.all(10),
            onPressed: () {
              setState(() {
                _onFlash = !_onFlash;
              });
            },
            icon: _onFlash
                ? const Icon(Icons.flash_on_sharp)
                : const Icon(Icons.flash_off_sharp),
          ),
          IconButton(
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
            padding: const EdgeInsets.all(20.0),
            child: TimerMenu(
              onTimerFinished: () {
                setState(() {
                  _setTimer = true;
                });
              },
            ),
          )
        ],
      ),
      body: Stack(children: [
        AspectRatio(
          aspectRatio: _aspectRatio,
          child: ClipRect(
            child: CustomPaint(
              foregroundPainter: _onGrid ? GridPainter() : null,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.previewSize!.height,
                  height: _controller.value.previewSize!.width,
                  child: CameraPreview(_controller),
                ),
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.all(80.0),
                child: IconButton(
                  onPressed: () async {
                    if (!_controller.value.isInitialized) {
                      return;
                    }
                    if (_controller.value.isTakingPicture) {
                      return;
                    }
                    debugPrint('Value of _setTimer: $_setTimer');
                    try {
                      await _controller.setFlashMode(
                          _onFlash ? FlashMode.always : FlashMode.off);
                      XFile? file;
                      if (_setTimer) {
                        file = await _controller.takePicture();
                      }
                      if (file != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ImagePreview(file!, _aspectRatio)));
                      }
                    } on CameraException catch (e) {
                      debugPrint("Error occured while taking photo : $e");
                      return;
                    }
                  },
                  iconSize: 80,
                  color: Colors.white,
                  icon: const Icon(Icons.circle_outlined),
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
