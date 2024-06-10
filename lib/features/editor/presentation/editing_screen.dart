import 'dart:io';
import 'dart:typed_data';

import 'package:Camera/core/data/service/api_service.dart';
import 'package:Camera/core/utils/helper/confirmation_dialog.dart';
import 'package:Camera/features/editor/presentation/widget/icon_button_with_title.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;

class EditingScreen extends StatelessWidget {
  const EditingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<provider.ImageProvider>(
      builder: (BuildContext context, imageProvider, Widget? child) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Editing Screen',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  showConfirmationDialog(context,
                          title: 'Discard Changes',
                          description:
                              'Are you sure you want to discard the changes?',
                          leftText: 'Cancel',
                          rightText: 'Discard')
                      .then((value) {
                    if (value == true) {
                      imageProvider.currentImage = null;
                      Navigator.pop(context);
                    }
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showConfirmationDialog(context,
                            title: 'Save to: ',
                            leftText: 'My Galery',
                            rightText: 'This Device')
                        .then((value) {
                      if (value == true) {
                        convertMemoryImageToFile(imageProvider.currentImagePath)
                            .then((file) {
                          ApiService().uploadImage(context, file);
                        }).then((_) {
                          imageProvider.currentImage = null;
                          Navigator.pop(context);
                        });
                      } else {
                        // Share to This Device
                      }
                    });
                  },
                  icon: const Icon(Icons.share),
                ),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    iconButtonWithTitle(onPressed: () {
                      Navigator.pushNamed(context, '/Cropper');
                    }, Icons.crop, 'Crop'),
                    iconButtonWithTitle(onPressed: () {
                      Navigator.pushNamed(context, '/Filters');
                    }, Icons.filter, 'Filter'),
                    iconButtonWithTitle(Icons.tune, 'Adjust', onPressed: () {
                      Navigator.pushNamed(context, '/Adjust');
                    }),
                    iconButtonWithTitle(onPressed: () {
                      Navigator.pushNamed(context, '/Text');
                    }, Icons.text_fields, 'Text'),
                    iconButtonWithTitle(Icons.emoji_emotions, 'Stickers',
                        onPressed: () {
                      Navigator.pushNamed(context, '/Stickers');
                    }),
                    iconButtonWithTitle(Icons.draw, 'Draw', onPressed: () {
                      Navigator.pushNamed(context, '/Draw');
                    })
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: Center(
                child: imageProvider.currentImage,
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<File> convertMemoryImageToFile(Uint8List data) async {
  // Get the temporary directory of the device
  final tempDir = await getTemporaryDirectory();

  // Create a new file in the temporary directory
  final file = File('${tempDir.path}/image.jpg');

  // Write the Uint8List data to the file
  await file.writeAsBytes(data);

  return file;
}
