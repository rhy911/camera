import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview(this.file, this.as, this.isRearCamera, {super.key});
  final XFile file;
  final double as;
  final bool isRearCamera;

   Future<void> _saveImageToGallery() async {
    final PermissionStatus status = await Permission.photos.request();
    if (status.isGranted) {
      await ImageGallerySaver.saveFile(file.path);
      
    } else {
      debugPrint('Permission to access gallery is denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    File picture = File(file.path);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Preview"),
        actions: [
          IconButton(
            onPressed: () {
              _saveImageToGallery();
            },
            icon: const Icon(Icons.save_alt_rounded),
          )
        ],
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
