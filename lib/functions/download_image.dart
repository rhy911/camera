import 'dart:js';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';

Future<void> _downloadImage(image) async {
  try {
    var imageId = await ImageDownloader.downloadImage(
      (image as CachedNetworkImage).imageUrl,
    );
    if (imageId == null) {
      return;
    }

    var path = await ImageDownloader.findPath(imageId);
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(content: Text('Saved image to $path')),
    );
  } on PlatformException catch (error) {
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(content: Text('Failed to save image: $error')),
    );
  }
}
