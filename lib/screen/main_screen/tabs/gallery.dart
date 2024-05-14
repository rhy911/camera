import 'package:Camera/screen/editing/editing_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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

    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('imports')
        .orderBy('timestamp', descending: true)
        .limit(itemsPerPage);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }
    final querySnapshot = await query.get();

    final List<String> newImageUrls = querySnapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['image'] as String)
        .toList();
    final List<String> newDocumentIds =
        querySnapshot.docs.map((doc) => doc.id).toList();

    debugPrint('Fetched ${newImageUrls.length} image URLs from Firestore');

    setState(() {
      imageUrls.addAll(newImageUrls);
      documentIds.addAll(newDocumentIds);
      _isLoading = false;
    });

    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
      if (newImageUrls.length == itemsPerPage) {
        _fetchAssets();
      }
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
        padding: const EdgeInsets.only(bottom: 80),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
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
                          builder: (context) => ImageView(
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
          border: Border.all(color: Colors.white, width: 1.0),
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

class ImageView extends StatelessWidget {
  const ImageView(
      {super.key,
      required this.imageUrls,
      required this.initialIndex,
      required this.documentIds,
      required this.onImageDeleted});
  final List<String> imageUrls;
  final List<String> documentIds;
  final int initialIndex;
  final Function(int) onImageDeleted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditingScreen(
                    image: Image.network(imageUrls[initialIndex]),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final bool? delete = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Image'),
                    content: const Text(
                        'Are you sure you want to delete this image?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              if (delete == true) {
                await deleteImage(
                    imageUrls[initialIndex], documentIds[initialIndex]);
                onImageDeleted(initialIndex);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: PhotoViewGallery.builder(
        itemCount: imageUrls.length,
        builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
          child: imageUrls[index].isEmpty
              ? const Center(child: CircularProgressIndicator())
              : PhotoView(
                  imageProvider: CachedNetworkImageProvider(imageUrls[index]),
                  minScale: PhotoViewComputedScale.contained,
                ),
        ),
        pageController: PageController(initialPage: initialIndex),
        enableRotation: true,
      ),
    );
  }
}

Future<void> deleteImage(String imageUrl, String documentId) async {
  // Create a reference to the file to delete
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.refFromURL(imageUrl);

  // Delete the file
  await ref.delete();

  // Delete the URL from Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference docRef = firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .collection('imports')
      .doc(documentId);

  await docRef.delete();
}
