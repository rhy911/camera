import 'package:Camera/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

enum SetFlashmode { auto, off, on }

class CameraState with ChangeNotifier {
  bool isRearCameraSelected = true;
  SetFlashmode _flashmode = SetFlashmode.auto;
  double _aspectRatio = 9 / 16;
  bool _onGrid = false;
  int _timerDuration = 0;

  SetFlashmode get flashmode => _flashmode;
  double get aspectRatio => _aspectRatio;
  bool get onGrid => _onGrid;
  int get timerDuration => _timerDuration;

  void setAspectRatio(double aspectRatio) {
    _aspectRatio = aspectRatio;
    notifyListeners();
  }

  void changeFlashMode(CameraController controller) {
    _flashmode = SetFlashmode
        .values[(_flashmode.index + 1) % SetFlashmode.values.length];

    switch (_flashmode) {
      case SetFlashmode.auto:
        controller.setFlashMode(FlashMode.auto);
        debugPrint("Flash mode set to auto");
        break;
      case SetFlashmode.on:
        controller.setFlashMode(FlashMode.always);
        debugPrint("Flash mode set to on");
        break;
      case SetFlashmode.off:
        controller.setFlashMode(FlashMode.off);
        debugPrint("Flash mode set to off");
        break;
    }
    notifyListeners();
  }

  void toggleGrid() {
    _onGrid = !_onGrid;
    notifyListeners();
  }

  void setTimer(int index) {
    _timerDuration = index;
    notifyListeners();
  }

  Future<CameraController> flipCamera() async {
    isRearCameraSelected = !isRearCameraSelected;
    final newController = CameraController(
      isRearCameraSelected ? cameras[0] : cameras[1],
      ResolutionPreset.max,
    );
    await newController.initialize();
    notifyListeners();
    return newController;
  }
}
