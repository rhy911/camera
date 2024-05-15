import 'dart:convert';
import 'dart:io';

import 'package:Camera/model/model.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:http/http.dart' as http;

class Repository {
  final String apiKey =
      "wO72cbYhrDXH6xdENxV70u9EbPdoG8shSCQ4F02SW36l5HM5B7nB7cGm";
  final String baseURL = "https://api.pexels.com/v1/";

  Future<List<Images>> getImagesList({required int? pageNumber}) async {
    debugPrint("getImagesList");
    String url = '';

    if (pageNumber == null) {
      url = "${baseURL}curated?per_page=50";
    } else {
      url = "${baseURL}curated?per_page=50&page=$pageNumber";
    }

    List<Images> imagesList = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': apiKey,
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);

        for (final json in jsonData["photos"] as Iterable) {
          final image = Images.fromJson(json);
          debugPrint(image.imagePotraitPath);
          imagesList.add(image);
        }
      }
    } catch (_) {}

    return imagesList;
  }

  Future<Images> getImageById({required int id}) async {
    final url = "${baseURL}photos/$id";

    Images image = Images.emptyConstructor();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': apiKey,
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);

        image = Images.fromJson(jsonData);
      }
    } catch (_) {}
    return image;
  }

  Future<List<Images>> getImagesBySearch({required String query}) async {
    final url = "${baseURL}search?query=$query&per_page=50";
    List<Images> imagesList = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': apiKey,
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);

        for (final json in jsonData["photos"] as Iterable) {
          final image = Images.fromJson(json);
          imagesList.add(image);
        }
      }
    } catch (_) {}

    return imagesList;
  }

  Future<void> downloadImage(
      {required String imageUrl,
      required int imageId,
      required BuildContext context}) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final bytes = response.bodyBytes;
        final directory = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);

        final file = File("$directory/$imageId.png");
        await file.writeAsBytes(bytes);

        MediaScanner.loadMedia(path: file.path);

        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text("File's been saved at: ${file.path}"),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (_) {}
  }
}
