// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  ImagePreview(this.file, this.as, {super.key});
  XFile file;
  double as = 9 / 16;

  @override
  Widget build(BuildContext context) {
    File picture = File(file.path);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Image Preview"),
        ),
        body: Center(
          child: AspectRatio(
              aspectRatio: as,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.file(picture),
                ),
              )),
        ));
  }
}
