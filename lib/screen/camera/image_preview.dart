import 'dart:io';
import 'package:Camera/helper/helper_function.dart';
import 'package:Camera/themes/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';

//TODO: Image Quality is not good, need to fix it

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

  void _saveImageToGallery(BuildContext context) {
    PhotoManager.requestPermissionExtend().then((PermissionState state) async {
      if (state == PermissionState.authorized) {
        // Save the cropped image to the gallery
        showLoadingDialog('Saving', context);
        await ImageGallerySaver.saveFile(widget.file.path);

        if (context.mounted) {
          hideLoadingDialog(context);
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

  void _shareImageToFireBase(BuildContext context) {
    showLoadingDialog('Sharing to Gallery', context);
    FirebaseStorage.instance
        .ref()
        .child('user: ${FirebaseAuth.instance.currentUser!.email}')
        .child('imported images')
        .child('${DateTime.now().toIso8601String()}.jpg')
        .putFile(widget.file)
        .then((TaskSnapshot taskSnapshot) {
      taskSnapshot.ref.getDownloadURL().then((String url) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('imports')
            .add({
          'image': url,
          'timestamp': FieldValue.serverTimestamp(),
        });
        if (context.mounted) {
          hideLoadingDialog(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Uploaded to Gallery !'),
              duration:
                  Duration(seconds: 2), // Change this to your desired duration
            ),
          );
        }
      });
    });
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
                _shareImageToFireBase(context);
              },
              icon: const Icon(Icons.share_rounded)),
          IconButton(
            onPressed: () {
              _saveImageToGallery(context);
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
