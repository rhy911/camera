import 'package:cloud_firestore/cloud_firestore.dart';

class ImageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchImages() async {
    List<String> imageUrls = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('imports')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();
      final List<String> newImageUrls = querySnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['image'] as String)
          .toList();
      imageUrls.addAll(newImageUrls);
      return imageUrls;
    } catch (e) {
      print('Error fetching images: $e');
      return [];
    }
  }
}
