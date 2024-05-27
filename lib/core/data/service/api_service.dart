import 'dart:io';

import 'package:Camera/core/utils/helper/loading_dialog.dart';
import 'package:Camera/models/image_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ApiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>> fetchImages(
      DocumentSnapshot? lastDocument) async {
    Query query = _firestore
        .collection('imports')
        .orderBy('timestamp', descending: true)
        .limit(20);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final querySnapshot = await query.get();

    return {
      'images': querySnapshot.docs.map((doc) {
        return ImageModel.fromDocument(doc);
      }).toList(),
      'lastDocument': querySnapshot.docs.last,
    };
  }

  Future<Map<String, dynamic>> fetchImagesByUser(
      DocumentSnapshot? lastDocument) async {
    Query query = _firestore
        .collection('imports')
        .where('fromUser', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .orderBy('timestamp', descending: true)
        .limit(20);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final querySnapshot = await query.get();

    return {
      'images': querySnapshot.docs.map((doc) {
        return ImageModel.fromDocument(doc);
      }).toList(),
      'lastDocument': querySnapshot.docs.last,
    };
  }

  Future<void> shareImageToFireBase(BuildContext context, File file) async {
    showLoadingDialog('Sharing to My Gallery', context);
    _storage
        .ref()
        .child('user: ${FirebaseAuth.instance.currentUser!.email}')
        .child('imported images')
        .child('${DateTime.now().toIso8601String()}.jpg')
        .putFile(file)
        .then((TaskSnapshot taskSnapshot) {
      taskSnapshot.ref.getDownloadURL().then((String url) async {
        await _firestore.collection('imports').add({
          'image': url,
          'timestamp': FieldValue.serverTimestamp(),
          'fromUser': FirebaseAuth.instance.currentUser!.email,
        });
        if (context.mounted) {
          hideLoadingDialog(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Uploaded to My Gallery !'),
              duration:
                  Duration(seconds: 2), // Change this to your desired duration
            ),
          );
        }
      });
    });
  }
}
