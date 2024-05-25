import 'package:Camera/config/themes/app_color.dart';
import 'package:Camera/features/editor/model/filters.dart';
import 'package:Camera/features/editor/presentation/pages/widget/icon_button_with_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  late dynamic imageProvider;
  Image? image;

  void initData(BuildContext context) {
    imageProvider = Provider.of<provider.ImageProvider>(context);
    image = imageProvider.currentImage;
  }

  late Filters _currentFilter;
  late List<Filters> filters;

  @override
  void initState() {
    super.initState();
    initData(context);
    filters = FilterGroup().list();
    _currentFilter = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'Image URL: ${imageProvider.imageUrls.length}, index: ${imageProvider.currentIndex}');
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        title: const Text('Filters'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Center(
          child: ColorFiltered(
              colorFilter: ColorFilter.matrix(_currentFilter.matrix),
              child: image)),
      bottomNavigationBar: BottomAppBar(
        color: AppColor.black,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              imageIconButtonWithTitle(
                  ColorFiltered(
                      colorFilter: ColorFilter.matrix(filters[0].matrix),
                      child: image),
                  'None', onPressed: () {
                setState(() {
                  _currentFilter = filters[0];
                });
              }),
              imageIconButtonWithTitle(
                  ColorFiltered(
                      colorFilter: ColorFilter.matrix(filters[1].matrix),
                      child: image),
                  'Black & White', onPressed: () {
                setState(() {
                  _currentFilter = filters[1];
                });
              }),
              imageIconButtonWithTitle(
                  ColorFiltered(
                      colorFilter: ColorFilter.matrix(filters[2].matrix),
                      child: image),
                  'Purple', onPressed: () {
                setState(() {
                  _currentFilter = filters[2];
                });
              }),
            ],
          ),
        ),
      ),
    );
  }
}
