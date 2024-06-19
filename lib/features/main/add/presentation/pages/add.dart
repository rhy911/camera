import 'dart:io';

import 'package:Camera/config/themes/app_color.dart';
import 'package:Camera/core/data/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddWidget extends StatefulWidget {
  const AddWidget({super.key});

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  final picker = ImagePicker();
  XFile? pickedFile;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController topicsController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    topicsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: const Text(
            '  C R E A T E',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColor.darkPurple,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/Camera Screen',
                          );
                        },
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 30)),
                  ),
                  const SizedBox(width: 50),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColor.darkPurple,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: InkWell(
                        onTap: () async {
                          XFile? xfile = await picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            pickedFile = xfile;
                          });
                        },
                        child: const Icon(Icons.library_add,
                            color: Colors.white, size: 30)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              if (pickedFile == null)
                const Text('No image selected.')
              else
                Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Image.file(File(pickedFile!.path))),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                pickedFile = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: TextField(
                        controller: descriptionController,
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        decoration: const InputDecoration(
                            labelText: 'Description',
                            hintText: 'Tell everyone what this is about',
                            labelStyle: TextStyle(fontSize: 15),
                            hintStyle: TextStyle(fontSize: 15)),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: TextField(
                        controller: topicsController,
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        decoration: const InputDecoration(
                            labelText: 'Topics',
                            hintText: 'Tag related topics',
                            labelStyle: TextStyle(fontSize: 15),
                            hintStyle: TextStyle(fontSize: 15)),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                        onTap: () {
                          ApiService().uploadImage(
                              context,
                              File(pickedFile!.path),
                              descriptionController.text,
                              topicsController.text);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColor.darkPurple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'Upload',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
            ],
          ),
        ));
  }
}
