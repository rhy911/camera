import 'package:Camera/features/camera/provider/camera_state.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlipCameraButton extends StatefulWidget {
  final CameraController controller;

  final Function(CameraController) onCameraFlip;

  const FlipCameraButton({
    super.key,
    required this.controller,
    required this.onCameraFlip,
  });

  @override
  State<FlipCameraButton> createState() => _FlipCameraButtonState();
}

class _FlipCameraButtonState extends State<FlipCameraButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final newController =
            await Provider.of<CameraProvider>(context, listen: false)
                .flipCamera();
        widget.onCameraFlip(newController);
      },
      icon: const Icon(Icons.flip_camera_ios_outlined,
          size: 50, color: Colors.white),
      padding: const EdgeInsets.all(10),
    );
  }
}
