import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageProvider extends ChangeNotifier {
  final List<String> _imageUrls = [];
  final List<String> _documentIds = [];
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;
  int _currentIndex = 0;
  Image? _currentImage;

  List<String> get imageUrls => _imageUrls;
  List<String> get documentIds => _documentIds;
  bool get isLoading => _isLoading;
  int get currentIndex => _currentIndex;
  Image get currentImage =>
      _currentImage ??
      Image(image: CachedNetworkImageProvider(_imageUrls[_currentIndex]));

  void _setLoading(bool loading) {
    _isLoading = loading;
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

  Future<void> fetchInitialAssets(String? userEmail) async {
    if (_isLoading) return;
    _setLoading(true);

    try {
      var test = FirebaseFirestore.instance.collection('imports');
      print('test: $test');

      Query query = FirebaseFirestore.instance
          .collection('imports')
          .where('fromUser', isEqualTo: userEmail)
          .orderBy('timestamp', descending: true)
          .limit(25);

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        final List<String> newImageUrls = querySnapshot.docs
            .map((doc) =>
                (doc.data() as Map<String, dynamic>)['image'] as String)
            .toList();
        final List<String> newDocumentIds =
            querySnapshot.docs.map((doc) => doc.id).toList();

        _imageUrls.addAll(newImageUrls);
        _documentIds.addAll(newDocumentIds);
        _lastDocument = querySnapshot.docs.last;
      }
    } catch (e) {
      debugPrint('Error fetching assets: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchMoreAssets(String? userEmail) async {
    if (_isLoading || _lastDocument == null) return;
    _setLoading(true);

    try {
      Query query = FirebaseFirestore.instance
          .collection('imports')
          .where('fromUser', isEqualTo: userEmail)
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastDocument!)
          .limit(25);

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        final List<String> newImageUrls = querySnapshot.docs
            .map((doc) =>
                (doc.data() as Map<String, dynamic>)['image'] as String)
            .toList();
        final List<String> newDocumentIds =
            querySnapshot.docs.map((doc) => doc.id).toList();

        _imageUrls.addAll(newImageUrls);
        _documentIds.addAll(newDocumentIds);
        _lastDocument = querySnapshot.docs.last;
      }
    } catch (e) {
      debugPrint('Error fetching assets: $e');
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  Future<void> handleImageDeleted(int index) async {
    try {
      String documentId = _documentIds[index];
      await FirebaseFirestore.instance
          .collection('imports')
          .doc(documentId)
          .delete();
      await FirebaseStorage.instance.refFromURL(_imageUrls[index]).delete();
      _imageUrls.removeAt(index);
      _documentIds.removeAt(index);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }
}
