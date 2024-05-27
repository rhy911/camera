import 'dart:io';

import 'package:Camera/core/utils/components/download_image.dart';
import 'package:Camera/core/data/service/api_service.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class ImageDiscoveryView extends StatefulWidget {
  const ImageDiscoveryView({super.key});

  @override
  State<ImageDiscoveryView> createState() => _ImageDiscoveryViewState();
}

class _ImageDiscoveryViewState extends State<ImageDiscoveryView> {
  late final PageController _pageController;
  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: Provider.of<provider.ImageProvider>(context, listen: false)
          .globalCurrentIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<provider.ImageProvider>(
      builder: (BuildContext context, imageProvider, Widget? child) {
        debugPrint('index: ${imageProvider.globalCurrentIndex}');
        debugPrint('Total: ${imageProvider.globalImageUrls.length}');

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
                  itemCount: imageProvider.globalImageUrls.length,
                  builder: (context, index) =>
                      PhotoViewGalleryPageOptions.customChild(
                    child: PhotoView(
                      imageProvider: CachedNetworkImageProvider(
                        imageProvider.globalImageUrls[index],
                      ),
                      minScale: PhotoViewComputedScale.contained,
                    ),
                  ),
                  pageController: _pageController,
                  enableRotation: true,
                  onPageChanged: (index) {
                    imageProvider.globalCurrentIndex = index;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'From: ${imageProvider.fromUser[imageProvider.globalCurrentIndex]}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      File imageFile = await urlToFile(
                        imageProvider
                            .globalImageUrls[imageProvider.globalCurrentIndex],
                      );
                      if (context.mounted) {
                        apiService.shareImageToFireBase(context, imageFile);
                      }
                    },
                    child: const Text('Pin'),
                  ),
                  TextButton(
                    onPressed: () async {
                      File imageFile = await urlToFile(
                        imageProvider
                            .globalImageUrls[imageProvider.globalCurrentIndex],
                      );
                      if (context.mounted) {
                        saveImageToGallery(context, imageFile.path);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
