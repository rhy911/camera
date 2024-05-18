import 'dart:io';

import 'package:Camera/features/editor/domain/entities/delete_image.dart';
import 'package:Camera/features/editor/domain/entities/download_image.dart';
import 'package:Camera/features/editor/domain/entities/share_to_firebase.dart';
import 'package:Camera/features/editor/presentation/pages/editing_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatefulWidget {
  const ImageView({
    super.key,
    required this.image,
    required this.initialIndex,
    required this.user,
  });

  final List<Widget> image;
  final List<String> user;
  final int initialIndex;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex)
      ..addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    setState(() {
      _currentIndex = _pageController.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: PhotoViewGallery.builder(
              itemCount: widget.image.length,
              builder: (context, index) =>
                  PhotoViewGalleryPageOptions.customChild(
                child: PhotoView(
                  imageProvider: CachedNetworkImageProvider(
                    (widget.image[index] as CachedNetworkImage).imageUrl,
                  ),
                  minScale: PhotoViewComputedScale.contained,
                ),
              ),
              pageController: _pageController,
              enableRotation: true,
            ),
          ),
          const SizedBox(height: 10),
          Text('From: ${widget.user[_currentIndex]}',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge), // Update the user text dynamically
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () async {
                    File imageFile = await urlToFile(
                        (widget.image[_currentIndex] as CachedNetworkImage)
                            .imageUrl);
                    shareImageToFireBase(context, imageFile);
                  },
                  child: const Text('Pin')),
              TextButton(
                  onPressed: () async {
                    File imageFile = await urlToFile(
                        (widget.image[_currentIndex] as CachedNetworkImage)
                            .imageUrl);
                    saveImageToGallery(context, imageFile.path);
                  },
                  child: const Text('Save')),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageGaleryView extends StatelessWidget {
  const ImageGaleryView(
      {super.key,
      required this.imageUrls,
      required this.initialIndex,
      this.documentIds,
      this.onImageDeleted});
  final List<String> imageUrls;
  final List<String>? documentIds;
  final int initialIndex;
  final Function(int)? onImageDeleted;

  @override
  Widget build(BuildContext context) {
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
                  builder: (context) => EditingScreen(
                    image: Image.network(imageUrls[initialIndex]),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final bool? delete = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Image'),
                    content: const Text(
                        'Are you sure you want to delete this image?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              if (delete == true) {
                await deleteImage(
                    imageUrls[initialIndex], documentIds![initialIndex]);
                onImageDeleted!(initialIndex);
                if (context.mounted) Navigator.pop(context);
              }
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
        pageController: PageController(initialPage: initialIndex),
        enableRotation: true,
      ),
    );
  }
}
