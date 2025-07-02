import 'dart:io';

import 'package:camera_app/core/utils/helper/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<void> saveImageToGallery(BuildContext context, String file) async {
  if (!context.mounted) return;

  final PermissionState state = await PhotoManager.requestPermissionExtend();
  if (!context.mounted) return;

  if (state == PermissionState.authorized) {
    // Save the cropped image to the gallery
    showLoadingDialog('Saving', context);
    try {
      await Gal.putImage(file);
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
    } catch (e) {
      if (context.mounted) {
        hideLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  } else {
    debugPrint('Permission to access gallery is denied');
  }
}

Future<File> urlToFile(String imageUrl) async {
  var response = await http.get(Uri.parse(imageUrl));

  var documentDirectory = await getApplicationDocumentsDirectory();

  var file = File('${documentDirectory.path}/my_image.jpg');

  file.writeAsBytesSync(response.bodyBytes);

  return file;
}
