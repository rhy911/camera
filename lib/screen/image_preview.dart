import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview(this.file, this.as, this.isRearCamera, {super.key});
  final XFile file;
  final double as;
  final bool isRearCamera;

  @override
  Widget build(BuildContext context) {
    File picture = File(file.path);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Preview"),
      ),
      body: Center(
        child: AspectRatio(
            aspectRatio: as,
            child: Transform.flip(
              flipX: isRearCamera ? false : true,
              child: Image.file(
                picture,
                fit: BoxFit.cover,
              ),
            )),
      ),
    );
  }
}
