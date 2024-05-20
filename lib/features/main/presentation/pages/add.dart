import 'dart:io';

import 'package:Camera/config/themes/app_color.dart';
import 'package:Camera/core/utils/helper/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
      await FirebaseFirestore.instance.collection('imports').add({
        'image': url,
        'timestamp': FieldValue.serverTimestamp(),
        'fromUser': FirebaseAuth.instance.currentUser!.email,
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
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
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
                      Navigator.pushNamed(
                        context,
                        '/camera',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.midColor,
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
                      backgroundColor: AppColor.midColor,
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
        ));
  }
}
