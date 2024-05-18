import 'dart:io';

import 'package:Camera/core/utils/helper/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

void shareImageToFireBase(BuildContext context, File file) {
  showLoadingDialog('Sharing to Gallery', context);
  FirebaseStorage.instance
      .ref()
      .child('user: ${FirebaseAuth.instance.currentUser!.email}')
      .child('imported images')
      .child('${DateTime.now().toIso8601String()}.jpg')
      .putFile(file)
      .then((TaskSnapshot taskSnapshot) {
    taskSnapshot.ref.getDownloadURL().then((String url) async {
      await FirebaseFirestore.instance.collection('imports').add({
        'image': url,
        'timestamp': FieldValue.serverTimestamp(),
        'fromUser': FirebaseAuth.instance.currentUser!.email,
      });
      if (context.mounted) {
        hideLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Uploaded to Gallery !'),
            duration:
                Duration(seconds: 2), // Change this to your desired duration
          ),
        );
      }
    });
  });
}
