import 'package:Camera/core/utils/helper/confirmation_dialog.dart';
import 'package:Camera/features/editor/presentation/pages/crop_page.dart';
import 'package:Camera/features/editor/presentation/pages/filters_page.dart';
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
    final imageProvider = Provider.of<provider.ImageProvider>(context);
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
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                          value: imageProvider, child: CropPage()),
                    ),
                  );
                  if (result != null) {
                    imageProvider.currentImage = result;
                  }
                }, Icons.crop, 'Crop'),
                iconButtonWithTitle(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChangeNotifierProvider.value(
                        value: imageProvider, child: const FiltersPage());
                  }));
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
  }
}
