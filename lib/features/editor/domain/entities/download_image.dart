import 'dart:io';

import 'package:Camera/core/utils/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

void saveImageToGallery(BuildContext context, String file) {
  PhotoManager.requestPermissionExtend().then((PermissionState state) async {
    if (state == PermissionState.authorized) {
      // Save the cropped image to the gallery
      showLoadingDialog('Saving', context);
      await ImageGallerySaver.saveFile(file);

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

Future<File> urlToFile(String imageUrl) async {
  var response = await http.get(Uri.parse(imageUrl));

  var documentDirectory = await getApplicationDocumentsDirectory();

  var file = File('${documentDirectory.path}/my_image.jpg');

  file.writeAsBytesSync(response.bodyBytes);

  return file;
}
