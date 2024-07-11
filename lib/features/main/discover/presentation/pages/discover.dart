import 'dart:async';

import 'package:Camera/core/data/service/api_service.dart';
import 'package:Camera/features/main/discover/provider/discovery_provider.dart';
import 'package:Camera/models/image_models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  DiscoveryProvider provider = DiscoveryProvider();
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> _fetchImages() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final data = await ApiService().fetchImages(provider.globalLastDocument);
      final imageData = data['images'] as List<ImageModel>;

      if (data.isNotEmpty) {
        final List<String> newImages = imageData.map((imageModel) {
          return imageModel.imageUrl;
        }).toList();
        final List<String> newFromUser = imageData.map((imageModel) {
          return imageModel.fromUser;
        }).toList();
        final List<String> newDescription = imageData.map((imageModel) {
          return imageModel.description;
        }).toList();

        provider.loadGlobalImageList(newImages);
        provider.loadUser(newFromUser);
        provider.loadImageDescription(newDescription);
        provider.globalLastDocument =
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
    provider = Provider.of<DiscoveryProvider>(context, listen: false);
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
            provider.disposeGlobalImageList();
            await _fetchImages();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            cacheExtent: 300, // Keep items in memory for a longer duration
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                toolbarHeight: 80.0,
                title: Text('D I S C O V E R Y',
                    style: Theme.of(context).textTheme.headlineLarge),
                floating: true,
                snap: true,
              ),
              SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childCount: provider.globalImageUrls.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                            onTap: () {
                              provider.globalCurrentIndex = index;
                              debugPrint(
                                  'index: ${provider.globalCurrentIndex}');
                              debugPrint(
                                  'Total: ${provider.globalImageUrls.length}');
                              Navigator.pushNamed(context, '/Discovery View');
                            },
                            child: CachedNetworkImage(
                                imageUrl: provider.globalImageUrls[index],
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
