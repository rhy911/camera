import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> deleteImage(String imageUrl, String documentId) async {
  // Create a reference to the file to delete
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.refFromURL(imageUrl);

  // Delete the file
  await ref.delete();

  // Delete the URL from Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference docRef = firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .collection('imports')
      .doc(documentId);

  await docRef.delete();
}
