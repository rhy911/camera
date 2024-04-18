import 'dart:io';

import 'package:Camera/screen/camera/camera_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddWidget extends StatefulWidget {
  const AddWidget({super.key});

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Uploading...'),
            ],
          ),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 240,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        final picker = ImagePicker();
                        XFile? pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          _showLoadingDialog();
                          // Upload the picked image to Firebase Storage
                          final ref = FirebaseStorage.instance
                              .ref()
                              .child('imported images')
                              .child('${DateTime.now().toIso8601String()}.jpg');
                          await ref.putFile(File(pickedFile.path));

                          // Get the URL of the uploaded image
                          final url = await ref.getDownloadURL();

                          // Store the URL in Firestore
                          await FirebaseFirestore.instance
                              .collection('imports')
                              .add({
                            'image': url,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                          _hideLoadingDialog();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  'Imported successfully, check your Gallery'),
                              duration: Duration(seconds: 2),
                            ));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 200, 20, 230),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 30),
                          SizedBox(width: 20),
                          Text(
                            'Import',
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 240,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CameraApp()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 200, 20, 230),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.camera_enhance_rounded,
                              color: Colors.white, size: 30),
                          SizedBox(width: 20),
                          Text(
                            'Take Picture',
                            style: TextStyle(fontSize: 25, color: Colors.white),
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
