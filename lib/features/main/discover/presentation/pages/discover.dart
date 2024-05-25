import 'dart:async';

import 'package:Camera/features/main/discover/presentation/widgets/image_view.dart';
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
  List<Widget> images = [];
  List<String> fromUser = [];
  bool isLoadingMore = false;
  DocumentSnapshot? _lastDocument;
  final itemsPerPage = 50;
  final ScrollController _scrollController = ScrollController();

  Future<void> fetchImages() async {
    if (isLoadingMore) return;
    setState(() {
      isLoadingMore = true;
    });

    try {
      Query query = FirebaseFirestore.instance
          .collection('imports')
          .orderBy('timestamp', descending: true)
          .limit(itemsPerPage);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        final List<Widget> newImages = querySnapshot.docs.map((doc) {
          String imageUrl =
              (doc.data() as Map<String, dynamic>)['image'] as String;
          return CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
        }).toList();
        final List<String> newFromUser = querySnapshot.docs.map((doc) {
          String newFromUser =
              (doc.data() as Map<String, dynamic>)['fromUser'] as String;
          return newFromUser;
        }).toList();

        setState(() {
          images.addAll(newImages);
          fromUser.addAll(newFromUser);
          _lastDocument = querySnapshot.docs.last;
        });
      }
    } catch (e) {
      debugPrint('Error fetching images: $e');
    }

    setState(() {
      isLoadingMore = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore) {
      fetchImages();
    }
  }

  @override
  void initState() {
    fetchImages();
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
        body: CustomScrollView(
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
              childCount: images.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImageView(
                                        image: images,
                                        initialIndex: index,
                                        user: fromUser)));
                          },
                          child: images[index])),
                );
              },
            ),
            SliverToBoxAdapter(
              child: isLoadingMore
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
