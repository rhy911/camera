import 'package:Camera/core/data/service/api_service.dart';
import 'package:Camera/models/image_models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImageGrid();
  }
}

class ImageGrid extends StatefulWidget {
  const ImageGrid({super.key});

  @override
  State<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  final apiService = ApiService();
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  provider.ImageProvider imageProvider = provider.ImageProvider();

  @override
  void initState() {
    super.initState();
    imageProvider = Provider.of<provider.ImageProvider>(context, listen: false);
    if (imageProvider.lastDocument == null) {
      _fetchImages();
    }
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchImages() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final data =
          await apiService.fetchImagesByUser(imageProvider.lastDocument);
      final imageData = data['images'] as List<ImageModel>;
      if (mounted) {
        if (data.isNotEmpty) {
          final List<String> newImageUrls = imageData.map((imageModel) {
            return imageModel.imageUrl;
          }).toList();

          imageProvider.loadImageList(newImageUrls);
          imageProvider.lastDocument =
              data['lastDocument'] as DocumentSnapshot<Object?>?;
        }
        debugPrint('Number image fetched: ${imageProvider.imageUrls.length}');
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
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 3, right: 3, bottom: 80),
        child: RefreshIndicator(
          onRefresh: () async {
            imageProvider.disposeImageList();
            await _fetchImages();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                toolbarHeight: 80.0,
                title: const Text(' G A L L E R Y'),
                floating: true,
                snap: true,
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 1.0),
                      ),
                      child: InkWell(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CachedNetworkImage(
                                imageUrl: imageProvider.imageUrls[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          imageProvider.currentIndex = index;
                          debugPrint('${imageProvider.currentIndex}');
                          Navigator.pushNamed(context, '/Gallery View')
                              .then((value) {
                            setState(() {});
                          });
                        },
                      ),
                    );
                  },
                  childCount: imageProvider.imageUrls.length,
                ),
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
