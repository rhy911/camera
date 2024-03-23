// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:test_project/aspect_ratio.dart';
import 'package:test_project/camera_screen.dart';
import 'package:test_project/gridlines.dart';
import 'package:test_project/timer.dart';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: []); //Fullscreen
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
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
  late int _timerDuration = 0;
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 90.0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        elevation: 0,
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
                _onFlash = !_onFlash;
              });
            },
            icon: _onFlash
                ? const Icon(Icons.flash_on_sharp)
                : const Icon(Icons.flash_off_sharp),
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
                await _controller
                    .setFlashMode(_onFlash ? FlashMode.always : FlashMode.off);
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ImagePreview(file!, _aspectRatio)));
              } on CameraException catch (e) {
                debugPrint("Error occured while taking photo : $e");
                return;
              }
            },
            iconSize: 85,
            color: Colors.white,
            icon: const Icon(Icons.circle_outlined),
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: _timerDuration != 0
              ? Text('$_timerDuration',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 70,
                    fontWeight: FontWeight.w200,
                  ))
              : Container(),
        ),
      ]),
    );
  }
}
