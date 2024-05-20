import 'package:Camera/components/image_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Library extends StatelessWidget {
  const Library({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ImageGrid());
  }
}

class ImageGrid extends StatefulWidget {
  const ImageGrid({super.key});

  @override
  State<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  final List<String> imageUrls = [];
  final List<String> documentIds = [];
  final itemsPerPage = 5;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;

  Future<void> _fetchAssets() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final userEmail = FirebaseAuth.instance.currentUser!.email;
      debugPrint('Current user email: $userEmail');

      Query query = FirebaseFirestore.instance
          .collection('imports')
          .where('fromUser', isEqualTo: userEmail)
          .orderBy('timestamp', descending: true)
          .limit(itemsPerPage);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        final List<String> newImageUrls = querySnapshot.docs
            .map((doc) =>
                (doc.data() as Map<String, dynamic>)['image'] as String)
            .toList();
        final List<String> newDocumentIds =
            querySnapshot.docs.map((doc) => doc.id).toList();

        print('Fetched ${newImageUrls.length} image URLs from Firestore');

        setState(() {
          imageUrls.addAll(newImageUrls);
          documentIds.addAll(newDocumentIds);
          _isLoading = false;
          _lastDocument = querySnapshot.docs.last;
        });

        if (newImageUrls.length == itemsPerPage) {
          _fetchAssets();
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching assets: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleImageDeleted(int index) {
    setState(() {
      imageUrls.removeAt(index);
      documentIds.removeAt(index);
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
              title: const Text(
                ' G A L L E R Y',
              ),
              floating: true,
              snap: true,
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ImageTap(
                    imageUrl: imageUrls[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageGaleryView(
                            imageUrls: imageUrls,
                            initialIndex: index,
                            documentIds: documentIds,
                            onImageDeleted: _handleImageDeleted,
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: imageUrls.length,
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

class ImageTap extends StatelessWidget {
  const ImageTap({super.key, required this.imageUrl, required this.onTap});
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).scaffoldBackgroundColor, width: 1.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ));
  }
}
