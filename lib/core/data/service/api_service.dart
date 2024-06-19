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

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await _firestore.collection('users').doc(userCredential.user!.email).set({
        'email': userCredential.user!.email,
        'uid': userCredential.user!.uid,
      });
    }
  }

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

  Future<void> uploadImage(BuildContext context, File file, String description,
      String topics) async {
    showLoadingDialog('Uploading', context);
    final ref = _storage
        .ref()
        .child('user: ${FirebaseAuth.instance.currentUser!.email}')
        .child('imported images')
        .child('${DateTime.now().toIso8601String()}.jpg');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();
    await _firestore.collection('imports').add({
      'image': url,
      'timestamp': FieldValue.serverTimestamp(),
      'fromUser': FirebaseAuth.instance.currentUser!.email,
      'description': description,
      'topics': topics,
    });

    if (context.mounted) {
      hideLoadingDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Imported successfully, check your Gallery'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      await _firestore
          .collection('imports')
          .where('image', isEqualTo: imageUrl)
          .get()
          .then((snapshot) {
        snapshot.docs.first.reference.delete();
      });
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }

  Future<List<String>> fetchStickers() {
    return _storage.ref().child('stickers').listAll().then((value) async {
      return Future.wait(value.items.map((e) => e.getDownloadURL()));
    });
  }
}
