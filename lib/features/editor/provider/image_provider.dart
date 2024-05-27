import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageProvider extends ChangeNotifier {
  final List<String> _imageUrls = [];
  DocumentSnapshot? _lastDocument;
  int _currentIndex = 0;
  Image? _currentImage;

  final List<String> _globalImageUrls = [];
  final List<String> _fromUser = [];
  DocumentSnapshot? _globalLastDocument;
  int _globalCurrentIndex = 0;
  Image? _globalCurrentImage;

  List<String> get imageUrls => _imageUrls;
  DocumentSnapshot? get lastDocument => _lastDocument;
  int get currentIndex => _currentIndex;
  Image get currentImage =>
      _currentImage ??
      Image(image: CachedNetworkImageProvider(_imageUrls[_currentIndex]));

  List<String> get globalImageUrls => _globalImageUrls;
  DocumentSnapshot? get globalLastDocument => _globalLastDocument;
  List<String> get fromUser => _fromUser;
  int get globalCurrentIndex => _globalCurrentIndex;
  Image get globalCurrentImage =>
      _globalCurrentImage ??
      Image(
          image: CachedNetworkImageProvider(
              _globalImageUrls[_globalCurrentIndex]));
  String get fromUserImage => _fromUser[_globalCurrentIndex];

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

  void loadGlobalImageList(List<String> urls) {
    _globalImageUrls.addAll(urls);
    notifyListeners();
  }

  void loadUser(List<String> user) {
    _fromUser.addAll(user);
    notifyListeners();
  }

  void disposeGlobalImageList() {
    _globalImageUrls.clear();
    _globalLastDocument = null;
    notifyListeners();
  }

  set globalLastDocument(DocumentSnapshot? document) {
    _globalLastDocument = document;
    notifyListeners();
  }

  set globalCurrentIndex(int index) {
    _globalCurrentIndex = index;
    notifyListeners();
  }

  set globalCurrentImage(Image? image) {
    _globalCurrentImage = image;
    notifyListeners();
  }

  Future<void> handleImageDeleted(int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('imports')
          .where('image', isEqualTo: _imageUrls[index])
          .get()
          .then((snapshot) {
        snapshot.docs.first.reference.delete();
      });
      await FirebaseStorage.instance.refFromURL(_imageUrls[index]).delete();
      _imageUrls.removeAt(index);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }
}
