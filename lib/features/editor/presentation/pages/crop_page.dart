import 'package:Camera/config/themes/app_color.dart';
import 'package:Camera/features/editor/presentation/pages/widget/icon_button_with_title.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;

class CropPage extends StatelessWidget {
  final _cropController = CropController(
    aspectRatio: null,
    defaultCrop: const Rect.fromLTRB(0, 0, 1, 1),
  );

  CropPage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<provider.ImageProvider>(context);
    final Image image = imageProvider.currentImage;
    debugPrint(
        'Image URL: ${imageProvider.imageUrls.length}, index: ${imageProvider.currentIndex}');
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        title: const Text('Crop'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context,
                  _cropController.croppedImage(quality: FilterQuality.high));
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Center(
        child: CropImage(
          image: image,
          controller: _cropController,
          paddingSize: 25,
          alwaysMove: true,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColor.black,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              iconButtonWithTitle(Icons.rotate_left, 'Rotate', onPressed: () {
                _cropController.rotateLeft();
              }),
              Container(height: 30, width: 2, color: Colors.white),
              iconButtonWithTitle(Icons.crop_free_outlined, 'Free',
                  onPressed: () {
                _cropController.aspectRatio = null;
              }),
              iconButtonWithTitle(Icons.crop_square_outlined, '1:1',
                  onPressed: () {
                _cropController.aspectRatio = 1;
              }),
              iconButtonWithTitle(Icons.crop_7_5_outlined, '4:3',
                  onPressed: () {
                _cropController.aspectRatio = 4 / 3;
              }),
              iconButtonWithTitle(Icons.crop_16_9_outlined, '16:9',
                  onPressed: () {
                _cropController.aspectRatio = 16 / 9;
              }),
              rotatedIconButtonWithTitle(Icons.crop_7_5_outlined, '3:4',
                  onPressed: () {
                _cropController.aspectRatio = 3 / 4;
              }),
              rotatedIconButtonWithTitle(Icons.crop_16_9_outlined, '9:16',
                  onPressed: () {
                _cropController.aspectRatio = 9 / 16;
              })
            ],
          ),
        ),
      ),
    );
  }
}
