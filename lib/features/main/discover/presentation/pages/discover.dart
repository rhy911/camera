import 'dart:async';

import 'package:Camera/core/data/service/api_service.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;
import 'package:Camera/models/image_models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  provider.ImageProvider imageProvider = provider.ImageProvider();
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> _fetchImages() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final apiService = ApiService();
      final data =
          await apiService.fetchImages(imageProvider.globalLastDocument);
      final imageData = data['images'] as List<ImageModel>;

      if (data.isNotEmpty) {
        final List<String> newImages = imageData.map((imageModel) {
          return imageModel.imageUrl;
        }).toList();
        final List<String> newFromUser = imageData.map((doc) {
          return doc.fromUser;
        }).toList();

        imageProvider.loadGlobalImageList(newImages);
        imageProvider.loadUser(newFromUser);
        imageProvider.globalLastDocument =
            data['lastDocument'] as DocumentSnapshot<Object?>?;
      }
    } catch (e) {
      debugPrint('Error fetching images: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading) {
      _fetchImages();
    }
  }

  @override
  void initState() {
    _fetchImages();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 80),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: RefreshIndicator(
          onRefresh: () async {
            imageProvider.disposeGlobalImageList();
            await _fetchImages();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            cacheExtent: 9999, // Keep items in memory for a longer duration
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                toolbarHeight: 80.0,
                title: const Text('D I S C O V E R Y'),
                floating: true,
                snap: true,
              ),
              SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childCount: imageProvider.globalImageUrls.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                            onTap: () {
                              imageProvider.globalCurrentIndex = index;
                              Navigator.pushNamed(context, '/Discovery View',
                                  arguments: imageProvider);
                            },
                            child: CachedNetworkImage(
                                imageUrl: imageProvider.globalImageUrls[index],
                                fit: BoxFit.cover)),
                      ));
                },
              ),
              SliverToBoxAdapter(
                child: isLoading
                    ? const SizedBox(
                        height: 60.0,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
