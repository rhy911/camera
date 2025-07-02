import 'package:camera/camera.dart';

class CameraConfig {
  static late List<CameraDescription> cameras;

  static Future<void> initialize() async {
    try {
      cameras = await availableCameras();
      print(
          'Cameras initialized successfully: ${cameras.length} cameras found');
    } catch (e) {
      print('Camera initialization error: $e');
      cameras = [];
    }
  }
}
