import 'dart:io';
import 'package:Camera/components/share_to_firebase.dart';
import 'package:Camera/config/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:Camera/components/download_image.dart';

//TODO: Image Quality is not good, need to fix it
//TODO: Implement another way to delete in grid view

class ImagePreview extends StatefulWidget {
  const ImagePreview(this.file, this.aspectRatio, this.isRearCamera,
      {super.key});
  final File file;
  final double aspectRatio;
  final bool isRearCamera;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  Future<ImageProvider> _loadImage() async {
    final bytes = await widget.file.readAsBytes();
    return MemoryImage(bytes);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ImagePreview');
    return Scaffold(
      backgroundColor: AppColor.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                shareImageToFireBase(context, widget.file);
              },
              icon: const Icon(Icons.share_rounded)),
          IconButton(
            onPressed: () {
              saveImageToGallery(context, widget.file.path);
            },
            icon: const Icon(Icons.save_alt_rounded),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: FutureBuilder<ImageProvider>(
        future: _loadImage(),
        builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.error != null) {
            // Handle error
            return Text('Error: ${snapshot.error}');
          } else {
            return PhotoView(
              imageProvider: snapshot.data,
              minScale: PhotoViewComputedScale.contained,
            );
          }
        },
      ),
    );
  }
}
