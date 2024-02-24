import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  ImagePreview(this.file, {super.key});
  XFile file;
  @override
  Widget build(BuildContext context) {
    File picture = File(file.path);
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Preview"),
      ),
      body: AspectRatio(
        aspectRatio: 9 / 16,
        child: Center(
          child: Image.file(picture),
        ),
      ),
    );
  }
}
