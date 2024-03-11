// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  ImagePreview(this.file, this.as, {super.key});
  XFile file;
  double as;

  @override
  Widget build(BuildContext context) {
    File picture = File(file.path);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Preview"),
      ),
      body: AspectRatio(
        aspectRatio: as,
        child: Center(
          child: Image.file(picture),
        ),
      ),
    );
  }
}
