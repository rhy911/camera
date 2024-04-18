import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview(this.file, this.as, this.isRearCamera, {super.key});
  final XFile file;
  final double as;
  final bool isRearCamera;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late File newFile;

  @override
  void initState() {
    super.initState();
    cropImage();
  }

  void cropImage() {
    // Read the image from the file
    img.Image? image =
        img.decodeImage(File(widget.file.path).readAsBytesSync());

    if (image != null) {
      // Flip the image horizontally if isRearCamera is false
      if (!widget.isRearCamera) {
        image = img.flipHorizontal(image);
      }
      // Calculate the target width and height based on the aspect ratio
      int targetWidth = image.width;
      int targetHeight = (targetWidth / widget.as).round();

      // Calculate the top left coordinates of the crop rectangle
      int x = 0;
      int y = (image.height - targetHeight) ~/ 2;

      // Crop the image
      img.Image croppedImage = img.copyCrop(image,
          x: x, y: y, width: targetWidth, height: targetHeight);

      // Save the image to a new file
      newFile = File(widget.file.path);
      newFile.writeAsBytesSync(img.encodeJpg(croppedImage));
    }
  }

  void _saveImageToGallery(BuildContext context) {
    PhotoManager.requestPermissionExtend().then((PermissionState state) async {
      if (state == PermissionState.authorized) {
        // Save the cropped image to the gallery
        await ImageGallerySaver.saveFile(newFile.path);

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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text("  I M A G E  P R E V I E W",
            style: TextStyle(color: Colors.white, fontSize: 25)),
        actions: [
          IconButton(
            onPressed: () {
              _saveImageToGallery(context);
            },
            icon: const Icon(Icons.save_alt_rounded),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: Center(
        child: PhotoView(
          imageProvider: FileImage(File(newFile.path)),
          minScale: PhotoViewComputedScale.contained,
        ),
      ),
    );
  }
}
