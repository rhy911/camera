import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Library extends StatelessWidget {
  const Library({super.key});

  @override
  Widget build(BuildContext context) {
    return const PopScope(canPop: false, child: Scaffold(body: ImageGrid()));
  }
}

class ImageGrid extends StatefulWidget {
  const ImageGrid({super.key});

  @override
  State<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  static List<Uint8List> imageData = [];

  final itemsPerPage = 10;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  DocumentSnapshot? _lastDocument;

  Future<void> _fetchAssets() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('imports')
        .orderBy('timestamp', descending: true)
        .limit(itemsPerPage);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }
    final querySnapshot = await query.get();

    final List<String> imageUrls = querySnapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['image'] as String)
        .toList();

    debugPrint('Fetched ${imageUrls.length} image URLs from Firestore');

    for (var url in imageUrls) {
      final ref = FirebaseStorage.instance.refFromURL(url);
      final data = await ref.getData();
      setState(() {
        imageData.add(data!);
      });
    }

    setState(() {
      _isLoading = false;
    });

    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
      if (imageUrls.length == itemsPerPage) {
        _fetchAssets();
      }
    }
  }

  Future<void> _onRefresh() {
    imageData.clear();
    return _fetchAssets();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchAssets();
    }
  }

  @override
  void initState() {
    super.initState();
    if (imageData.isEmpty) {
      _fetchAssets();
    }
    _scrollController.addListener(_onScroll);
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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              toolbarHeight: 80.0,
              title: const Text(
                ' G A L L E R Y',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              automaticallyImplyLeading: false,
              floating: true,
              snap: true,
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageView(
                                imageFile: imageData,
                                initialIndex: index,
                              ),
                            ),
                          );
                        },
                        child: Stack(children: [
                          Positioned.fill(
                              child: Image.memory(imageData[index],
                                  fit: BoxFit.cover))
                        ])),
                  );
                },
                childCount: imageData.length,
              ),
            ),
            SliverToBoxAdapter(
              child: _isLoading
                  ? const SizedBox(
                      height: 60.0,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class ImageView extends StatelessWidget {
  const ImageView(
      {super.key, required this.imageFile, required this.initialIndex});
  final List<Uint8List> imageFile;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: PhotoViewGallery.builder(
        itemCount: imageFile.length,
        builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
          child: imageFile[index].isEmpty
              ? const Center(child: CircularProgressIndicator())
              : PhotoView(
                  imageProvider: MemoryImage(imageFile[index]),
                ),
          minScale: PhotoViewComputedScale.contained,
        ),
        pageController: PageController(initialPage: initialIndex),
        enableRotation: true,
      ),
    );
  }
}
