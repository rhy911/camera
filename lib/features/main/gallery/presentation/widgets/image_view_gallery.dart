import 'package:Camera/core/utils/helper/confirmation_dialog.dart';
import 'package:Camera/features/editor/presentation/editing_screen.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class ImageGaleryView extends StatefulWidget {
  const ImageGaleryView({super.key});

  @override
  State<ImageGaleryView> createState() => _ImageGaleryViewState();
}

class _ImageGaleryViewState extends State<ImageGaleryView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final imageProvider =
        Provider.of<provider.ImageProvider>(context, listen: false);
    _pageController = PageController(initialPage: imageProvider.currentIndex);

    _pageController.addListener(() {
      int currentPage = _pageController.page!.round();
      if (currentPage != imageProvider.currentIndex) {
        imageProvider.currentIndex = currentPage;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<provider.ImageProvider>(context);
    final imageUrls = imageProvider.imageUrls;
    final initialIndex = imageProvider.currentIndex;

    debugPrint('initialIndex: $initialIndex');
    debugPrint('imageUrls: ${imageUrls.length}');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: imageProvider,
                    child: const EditingScreen(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showConfirmationDialog(context,
                      title: 'Delete Image',
                      description:
                          'Are you sure you want to delete this image?',
                      leftText: 'Cancel',
                      rightText: 'Delete')
                  .then((value) async {
                if (value == true) {
                  await imageProvider.handleImageDeleted(initialIndex);
                  if (context.mounted) Navigator.pop(context);
                }
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: PhotoViewGallery.builder(
        itemCount: imageUrls.length,
        builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
          child: imageUrls[index].isEmpty
              ? const Center(child: CircularProgressIndicator())
              : PhotoView(
                  imageProvider: CachedNetworkImageProvider(imageUrls[index]),
                  minScale: PhotoViewComputedScale.contained,
                ),
        ),
        pageController: _pageController,
        enableRotation: true,
      ),
    );
  }
}