import 'package:Camera/core/utils/helper/confirmation_dialog.dart';
import 'package:Camera/features/editor/presentation/pages/widget/icon_button_with_title.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
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
                  onPressed: () {},
                  icon: const Icon(Icons.cloud_upload_rounded),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.ios_share),
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
                    iconButtonWithTitle(onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/Cropper',
                        arguments: imageProvider,
                      ) as Image?;
                      if (result != null) {
                        imageProvider.currentImage = result;
                      }
                    }, Icons.crop, 'Crop'),
                    iconButtonWithTitle(onPressed: () {
                      Navigator.pushNamed(context, '/Filters',
                          arguments: imageProvider);
                    }, Icons.filter, 'Filter'),
                    iconButtonWithTitle(
                        onPressed: () {}, Icons.text_fields, 'Text'),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: PhotoView(
                    imageProvider: imageProvider.currentImage.image,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
