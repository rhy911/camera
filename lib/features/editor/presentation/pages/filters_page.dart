import 'package:Camera/config/themes/app_color.dart';
import 'package:Camera/features/editor/model/filters.dart';
import 'package:Camera/features/editor/presentation/widget/icon_button_with_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;
import 'package:screenshot/screenshot.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  late final List<Filters> filters;
  late Filters _currentFilter;
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    filters = FilterGroup().list();
    _currentFilter = filters[0];
    _screenshotController;
  }

  void _applyFilter(Filters filter) {
    setState(() {
      _currentFilter = filter;
    });
  }

  @override
  void dispose() {
    _screenshotController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<provider.ImageProvider>(
      builder: (context, imageProvider, child) {
        final image = imageProvider.currentImage;
        return Scaffold(
          backgroundColor: AppColor.black,
          appBar: AppBar(
            title: const Text('Filters'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  if (_currentFilter != filters[0]) {
                    _screenshotController.capture().then((capturedImage) {
                      imageProvider.currentImagePath = capturedImage;
                      imageProvider.currentImage = Image.memory(capturedImage!);
                    }).then((_) {
                      Navigator.pop(context);
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.done),
              ),
            ],
          ),
          body: Center(
            child: Screenshot(
              controller: _screenshotController,
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix(_currentFilter.matrix),
                child: image,
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: AppColor.black,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: filters.map((filter) {
                  return imageIconButtonWithTitle(
                    ColorFiltered(
                      colorFilter: ColorFilter.matrix(filter.matrix),
                      child: image,
                    ),
                    filter.name,
                    onPressed: () => _applyFilter(filter),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
