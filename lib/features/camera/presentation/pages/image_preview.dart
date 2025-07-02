import 'package:camera_app/config/themes/app_color.dart';
import 'package:camera_app/core/data/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:camera_app/core/utils/components/download_image.dart';
import 'package:camera_app/features/camera/provider/camera_state.dart';
import 'package:provider/provider.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({super.key});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  Future<ImageProvider> _loadImage() async {
    final file = Provider.of<CameraProvider>(context).capturedImage;
    final bytes = await file!.readAsBytes();
    return MemoryImage(bytes);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ImagePreview');
    return Consumer<CameraProvider>(
      builder: (context, cameraProvider, child) {
        return Scaffold(
          backgroundColor: AppColor.black,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    if (cameraProvider.capturedImage != null) {
                      final apiService = ApiService();
                      apiService.uploadImage(
                          context, cameraProvider.capturedImage!, '', '');
                    }
                  },
                  icon: const Icon(Icons.share_rounded)),
              IconButton(
                onPressed: () {
                  saveImageToGallery(
                      context, cameraProvider.capturedImage!.path);
                },
                icon: const Icon(Icons.save_alt_rounded),
              ),
              const SizedBox(width: 5),
            ],
          ),
          body: FutureBuilder<ImageProvider>(
            future: _loadImage(),
            builder:
                (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
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
      },
    );
  }
}
