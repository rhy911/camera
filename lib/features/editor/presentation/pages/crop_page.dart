import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';

class CropPage extends StatefulWidget {
  const CropPage({super.key});

  @override
  State<CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  final _cropController = CropController(
    aspectRatio: 1.0,
    defaultCrop: const Rect.fromLTRB(0, 0, 1, 1),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: const Center(child: Text('crop')),
    );
  }
}
