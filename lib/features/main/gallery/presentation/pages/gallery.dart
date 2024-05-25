import 'package:Camera/features/main/gallery/presentation/widgets/image_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) {
          return provider.ImageProvider();
        },
        child: const ImageGrid());
  }
}

class ImageGrid extends StatefulWidget {
  const ImageGrid({super.key});

  @override
  State<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialAssets();
    });
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchInitialAssets() async {
    final imageProvider =
        Provider.of<provider.ImageProvider>(context, listen: false);
    final userEmail = FirebaseAuth.instance.currentUser!.email;
    await imageProvider.fetchInitialAssets(userEmail);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMoreAssets();
    }
  }

  Future<void> _fetchMoreAssets() async {
    final imageProvider =
        Provider.of<provider.ImageProvider>(context, listen: false);
    final userEmail = FirebaseAuth.instance.currentUser!.email;
    await imageProvider.fetchMoreAssets(userEmail);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<provider.ImageProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 3, right: 3, bottom: 80),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value(
                              value: imageProvider,
                              child: const ImageGaleryView(),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: imageProvider.imageUrls.length,
              ),
            ),
            SliverToBoxAdapter(
              child: imageProvider.isLoading
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
