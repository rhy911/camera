import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview(this.file, this.as, this.isRearCamera, {super.key});
  final XFile file;
  final double as;
  final bool isRearCamera;

  Future<void> _saveImageToGallery(BuildContext context) async {
    PhotoManager.requestPermissionExtend().then((PermissionState state) async {
      if (state == PermissionState.authorized) {
        await ImageGallerySaver.saveFile(file.path);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saved to Gallery'),
              duration:
                  Duration(seconds: 2), // Change this to your desired duration
            ),
          );
        }
      } else {
        debugPrint('Permission to access gallery is denied');
      }
    });
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
              _saveImageToGallery(context);
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
