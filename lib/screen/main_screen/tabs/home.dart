import 'dart:async';

import 'package:Camera/model/model.dart';
import 'package:Camera/repository/repository.dart';
import 'package:Camera/screen/main_screen/tabs/gallery.dart';
import 'package:Camera/themes/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Repository repo = Repository();
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  List<Images> imagesList = [];
  int pageNumber = 1;
  int _currentPage = 0;
  late Timer _timer;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < 5) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.ease,
      );
    });

    fetchImages();

    // Adding the scroll listener
    scrollController.addListener(() {
      if (scrollController.position.extentAfter < 500 && !isLoadingMore) {
        fetchImages();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchImages() async {
    setState(() {
      isLoadingMore = true;
    });
    List<Images> newImages = await repo.getImagesList(pageNumber: pageNumber);
    setState(() {
      imagesList.addAll(newImages);
      pageNumber++;
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            toolbarHeight: 80.0,
            title: const Text(' D I S C O V E R Y'),
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Text(
                  "Today's Special",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: AppColor.vibrantColor),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        controller: pageController,
                        onPageChanged: (int page) {
                          _currentPageNotifier.value = page;
                        },
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: Image.asset('assets/images/$index.jpeg')
                                    .image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: CirclePageIndicator(
                          currentPageNotifier: _currentPageNotifier,
                          itemCount: 5,
                          size: 5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Trending",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: AppColor.vibrantColor),
                ),
                imagesList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: MasonryGridView.count(
                              itemCount: imagesList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              crossAxisCount: 2,
                              itemBuilder: (context, index) {
                                double height = (index % 10 + 1) * 100;
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageView(
                                          imageUrls: [
                                            imagesList[index].imagePotraitPath,
                                          ],
                                          initialIndex: index,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      height: height > 300 ? 300 : height,
                                      imageUrl:
                                          imagesList[index].imagePotraitPath,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (isLoadingMore)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
