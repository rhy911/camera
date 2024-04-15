import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
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
  List<AssetEntity> assets = [];
  List<Uint8List> thumbnailsData = [];
  int currentPage = 0;
  final itemsPerPage = 100;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  Future<void> _fetchAssets() async {
    PhotoManager.requestPermissionExtend().then((PermissionState state) async {
      if (state.isAuth) {
        setState(() {
          _isLoading = true;
        });
        final List<AssetEntity> assetList =
            await PhotoManager.getAssetListPaged(
                page: currentPage, pageCount: itemsPerPage);
        final List<AssetEntity> imageAssets =
            assetList.where((asset) => asset.type == AssetType.image).toList();
        final List<Uint8List> thumbnails = await Future.wait(imageAssets
            .map((asset) => asset.thumbnailData.then((value) => value!)));
        setState(() {
          assets.addAll(imageAssets);
          thumbnailsData.addAll(thumbnails);
          currentPage++;
          _isLoading = false;
        });
      }
    });
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
    _fetchAssets();
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          const SliverAppBar(
            backgroundColor: Color.fromARGB(120, 101, 56, 172),
            toolbarHeight: 80.0,
            title: Text(
              'Galery',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 40),
            ),
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final bytes = thumbnailsData[index];
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
                              imageFile: assets,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      child: Stack(children: [
                        Positioned.fill(
                            child: Image.memory(bytes, fit: BoxFit.cover))
                      ])),
                );
              },
              childCount: assets.length,
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
    );
  }
}

class ImageView extends StatelessWidget {
  const ImageView(
      {super.key, required this.imageFile, required this.initialIndex});
  final List<AssetEntity> imageFile;
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
          child: FutureBuilder<File>(
              future: imageFile[index].file.then((value) => value!),
              builder: (context, snapshot) {
                final file = snapshot.data;
                if (file == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return PhotoView(
                    imageProvider: FileImage(file),
                  );
                }
              }),
          minScale: PhotoViewComputedScale.covered,
        ),
        pageController: PageController(initialPage: initialIndex),
        enableRotation: true,
      ),
    );
  }
}
