import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel {
  final String imageUrl;
  final String fromUser;
  final String description;
  final String topics;

  ImageModel(
      {required this.fromUser,
      required this.imageUrl,
      required this.description,
      required this.topics});

  factory ImageModel.fromDocument(DocumentSnapshot doc) {
    return ImageModel(
      imageUrl: (doc.data() as Map<String, dynamic>)['image'] as String,
      fromUser: (doc.data() as Map<String, dynamic>)['fromUser'] as String,
      description:
          (doc.data() as Map<String, dynamic>)['description'] as String,
      topics: (doc.data() as Map<String, dynamic>)['topics'] as String,
    );
  }
}
