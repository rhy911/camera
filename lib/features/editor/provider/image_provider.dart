import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Camera/core/data/service/api_service.dart';

class ImageProvider extends ChangeNotifier {
  final List<String> _imageUrls = [];
  DocumentSnapshot? _lastDocument;
  int _currentIndex = 0;
  Image? _currentImage;
  late Uint8List _currentImagePath;

  void reset() {
    _imageUrls.clear();
    _lastDocument = null;
    _currentIndex = 0;
    _currentImage = null;
    notifyListeners();
  }

  List<String> get imageUrls => _imageUrls;
  DocumentSnapshot? get lastDocument => _lastDocument;
  int get currentIndex => _currentIndex;
  Image get currentImage =>
      _currentImage ??
      Image(image: CachedNetworkImageProvider(_imageUrls[_currentIndex]));
  get currentImagePath => _currentImagePath;

  void loadImageList(List<String> urls) {
    _imageUrls.addAll(urls);
    notifyListeners();
  }

  void disposeImageList() {
    _imageUrls.clear();
    _lastDocument = null;
    notifyListeners();
  }

  set lastDocument(DocumentSnapshot? document) {
    _lastDocument = document;
    notifyListeners();
  }

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  set currentImage(Image? image) {
    _currentImage = image;
    notifyListeners();
  }

  set currentImagePath(var path) {
    _currentImagePath = path;
    notifyListeners();
  }

  Future<void> handleImageDeleted(int index) async {
    ApiService().deleteImage(_imageUrls[index]);
    _imageUrls.removeAt(index);
    notifyListeners();
  }
}
