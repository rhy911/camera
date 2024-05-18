import 'package:Camera/features/camera/presentation/provider/camera_state.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashButton extends StatefulWidget {
  const FlashButton({super.key, required this.controller});
  final CameraController controller;

  @override
  State<FlashButton> createState() => _FlashButtonState();
}

class _FlashButtonState extends State<FlashButton> {
  @override
  Widget build(BuildContext context) {
    SetFlashmode flashmode = Provider.of<CameraState>(context).flashmode;
    return IconButton(
      onPressed: () {
        Provider.of<CameraState>(context, listen: false)
            .changeFlashMode(widget.controller);
      },
      icon: flashmode == SetFlashmode.on
          ? const Icon(Icons.flash_on_rounded)
          : flashmode == SetFlashmode.off
              ? const Icon(Icons.flash_off_rounded)
              : const Icon(Icons.flash_auto_rounded),
    );
  }
}
