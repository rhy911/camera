import 'dart:io';

import 'package:Camera/core/utils/components/download_image.dart';
import 'package:Camera/core/data/service/api_service.dart';
import 'package:Camera/features/main/discover/provider/discovery_provider.dart';
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
    final provider = Provider.of<DiscoveryProvider>(context, listen: false);
    _pageController = PageController(
      initialPage: provider.globalCurrentIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoveryProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        debugPrint('index: ${provider.globalCurrentIndex}');
        debugPrint('Total: ${provider.globalImageUrls.length}');

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
                  itemCount: provider.globalImageUrls.length,
                  builder: (context, index) =>
                      PhotoViewGalleryPageOptions.customChild(
                    child: PhotoView(
                      imageProvider: CachedNetworkImageProvider(
                        provider.globalImageUrls[index],
                      ),
                      minScale: PhotoViewComputedScale.contained,
                    ),
                  ),
                  pageController: _pageController,
                  enableRotation: true,
                  onPageChanged: (index) {
                    provider.globalCurrentIndex = index;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(provider.imageDescription[provider.globalCurrentIndex],
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              Text(
                'From: ${provider.fromUser[provider.globalCurrentIndex]}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      File imageFile = await urlToFile(
                        provider.globalImageUrls[provider.globalCurrentIndex],
                      );
                      if (context.mounted) {
                        apiService.uploadImage(context, imageFile, '', '');
                      }
                    },
                    child: const Text('Save'),
                  ),
                  TextButton(
                    onPressed: () async {
                      File imageFile = await urlToFile(
                        provider.globalImageUrls[provider.globalCurrentIndex],
                      );
                      if (context.mounted) {
                        saveImageToGallery(context, imageFile.path);
                      }
                    },
                    child: const Text('Download'),
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
