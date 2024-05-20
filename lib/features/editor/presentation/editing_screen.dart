import 'package:Camera/core/utils/helper/confirmation_dialog.dart';
import 'package:Camera/features/editor/presentation/pages/crop_page.dart';
import 'package:Camera/features/editor/presentation/pages/widget/icon_button_with_title.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class EditingScreen extends StatelessWidget {
  const EditingScreen({super.key, required this.image});
  final Image image;

  @override
  Widget build(BuildContext context) {
    return EditPhotoLayout(image: image);
  }
}

class EditPhotoLayout extends StatefulWidget {
  const EditPhotoLayout({super.key, required this.image});
  final Image image;
  @override
  State<EditPhotoLayout> createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditPhotoLayout> {
  @override
  Widget build(BuildContext context) {
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
                      leftText: 'Cancle',
                      rightText: 'Discard')
                  .then((value) {
                if (value == true) Navigator.pop(context);
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
                iconButtonWithTitle(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CropPage(),
                    ),
                  );
                }, Icons.crop, 'Crop'),
                iconButtonWithTitle(
                    onPressed: () {}, Icons.rotate_left, 'Rotate'),
                iconButtonWithTitle(onPressed: () {}, Icons.flip, 'Flip'),
                iconButtonWithTitle(onPressed: () {}, Icons.filter, 'Filter'),
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
                imageProvider: widget.image.image,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
