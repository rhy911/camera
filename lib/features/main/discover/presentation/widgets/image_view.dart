import 'dart:io';

import 'package:Camera/components/download_image.dart';
import 'package:Camera/components/share_to_firebase.dart';
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
