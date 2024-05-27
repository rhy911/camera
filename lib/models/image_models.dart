import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel {
  final String imageUrl;
  final String fromUser;

  ImageModel({required this.fromUser, required this.imageUrl});

  factory ImageModel.fromDocument(DocumentSnapshot doc) {
    return ImageModel(
      imageUrl: (doc.data() as Map<String, dynamic>)['image'] as String,
      fromUser: (doc.data() as Map<String, dynamic>)['fromUser'] as String,
    );
  }
}
