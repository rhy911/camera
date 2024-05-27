import 'package:Camera/features/camera/domain/entities/appbar_components/timer.dart';
import 'package:Camera/features/camera/provider/camera_state.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TakePictureButton extends StatefulWidget {
  final CameraController controller;
  final Function(XFile) onPictureTaken;

  const TakePictureButton({
    super.key,
    required this.controller,
    required this.onPictureTaken,
  });

  @override
  State<TakePictureButton> createState() => _TakePictureButtonState();
}

class _TakePictureButtonState extends State<TakePictureButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        debugPrint("Take picture button pressed");
        // Get the current time when the button is pressed
        DateTime startTime = DateTime.now();
        if (!widget.controller.value.isInitialized ||
            widget.controller.value.isTakingPicture) {
          return;
        }

        try {
          final cameraProvider =
              Provider.of<CameraProvider>(context, listen: false);
          int initialTimer = cameraProvider.timerDuration;
          await startTimer(cameraProvider.timerDuration, (remainingTime) {
            cameraProvider.setTimer(remainingTime);
          });

          if (cameraProvider.timerDuration == 0) {
            widget.onPictureTaken(await widget.controller.takePicture());
            // Get the current time when the picture is taken successfully
            DateTime endTime = DateTime.now();

            // Calculate the difference
            Duration difference = endTime.difference(startTime);
            debugPrint("Picture taken");
            debugPrint("Time taken: ${difference.inMilliseconds} ms");

            cameraProvider.setTimer(initialTimer); // Reset the timer
          }
        } on CameraException catch (e) {
          debugPrint("Error occured while taking photo : $e");
          return;
        }
      },
      iconSize: 85,
      icon: const Icon(Icons.circle_outlined),
    );
  }
}
