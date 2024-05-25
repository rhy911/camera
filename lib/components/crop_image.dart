import 'dart:io';

import 'package:Camera/features/camera/provider/camera_state.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

Future<File> cropImage(context, XFile file) async {
  final cameraState = Provider.of<CameraState>(context, listen: false);
  final aspectRatio = cameraState.aspectRatio;
  final isRearCamera = cameraState.isRearCameraSelected;
  // Read the image from the file
  final imageBytes = await File(file.path).readAsBytes();
  img.Image? image = img.decodeImage(imageBytes);

  if (image != null) {
    // Flip the image horizontally if isRearCamera is false
    if (!isRearCamera) {
      image = img.flipHorizontal(image);
    }
    // Calculate the target width and height based on the aspect ratio
    int targetWidth = image.width;
    int targetHeight = (targetWidth / aspectRatio).round();

    // Calculate the top left coordinates of the crop rectangle
    int x = 0;
    int y = (image.height - targetHeight) ~/ 2;

    // Crop the image
    img.Image croppedImage = img.copyCrop(image,
        x: x, y: y, width: targetWidth, height: targetHeight);

    // Save the image to a new file
    File newFile = File(file.path);
    await newFile.writeAsBytes(img.encodeJpg(croppedImage));
    return newFile;
  } else {
    throw Exception("Error decoding image");
  }
}
