import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiscoveryProvider extends ChangeNotifier {
  final List<String> _globalImageUrls = [];
  final List<String> _fromUser = [];
  DocumentSnapshot? _globalLastDocument;
  int _globalCurrentIndex = 0;
  Image? _globalCurrentImage;
  final List<String> _imageDescription = [];

  List<String> get globalImageUrls => _globalImageUrls;
  DocumentSnapshot? get globalLastDocument => _globalLastDocument;
  List<String> get fromUser => _fromUser;
  List<String> get imageDescription => _imageDescription;
  int get globalCurrentIndex => _globalCurrentIndex;
  Image get globalCurrentImage =>
      _globalCurrentImage ??
      Image(
          image: CachedNetworkImageProvider(
              _globalImageUrls[_globalCurrentIndex]));
  String get fromUserImage => _fromUser[_globalCurrentIndex];
  String get imageDescriptionText => _imageDescription[_globalCurrentIndex];

  void reset() {
    _globalImageUrls.clear();
    _fromUser.clear();
    _globalLastDocument = null;
    _globalCurrentIndex = 0;
    _globalCurrentImage = null;
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

  void loadImageDescription(List<String> description) {
    _imageDescription.addAll(description);
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
}
