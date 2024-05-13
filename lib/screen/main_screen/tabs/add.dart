import 'dart:io';

import 'package:Camera/provider/camera_state.dart';
import 'package:Camera/screen/camera/camera_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Camera/helper/helper_function.dart';
import 'package:provider/provider.dart';

class AddWidget extends StatefulWidget {
  const AddWidget({super.key});

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  Future<void> _importImages() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (mounted) showLoadingDialog('Uploading', context);

      // Upload the picked image to Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('user: ${FirebaseAuth.instance.currentUser!.email}')
          .child('imported images')
          .child('${DateTime.now().toIso8601String()}.jpg');
      await ref.putFile(File(pickedFile.path));

      // Get the URL of the uploaded image
      final url = await ref.getDownloadURL();

      // Store the URL in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('imports')
          .add({
        'image': url,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        hideLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Imported successfully, check your Gallery'),
          duration: Duration(seconds: 2),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: const Text(
              '  C R E A T E',
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 50, left: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                    create: (BuildContext context) =>
                                        CameraState(),
                                    child: const CameraApp())));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_enhance_rounded,
                              color: Colors.white, size: 50),
                          SizedBox(width: 5),
                          Text(
                            'Take Picture',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      )),
                ),
                const SizedBox(width: 50),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ElevatedButton(
                      onPressed: () {
                        _importImages();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 50),
                          Text(
                            'Import',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          )),
    );
  }
}