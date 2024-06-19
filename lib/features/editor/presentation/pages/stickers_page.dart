import 'package:Camera/core/data/service/api_service.dart';
import 'package:Camera/features/editor/presentation/widget/sticker.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;
import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:provider/provider.dart';

class StickersPage extends StatefulWidget {
  const StickersPage({super.key});

  @override
  State<StickersPage> createState() => _StickersPageState();
}

class _StickersPageState extends State<StickersPage> {
  LindiController controller = LindiController();
  Future<List<String>> stickers = ApiService().fetchStickers();
  @override
  Widget build(BuildContext context) {
    return Consumer<provider.ImageProvider>(
      builder: (BuildContext context, imageProvider, Widget? child) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Stickers',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  final image = await controller.saveAsUint8List();
                  imageProvider.currentImagePath = image;
                  imageProvider.currentImage = Image.memory(image!);
                  if (context.mounted) Navigator.pop(context);
                },
                icon: const Icon(Icons.done))
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white30,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder(
              future: stickers,
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  snapshot.data!.shuffle();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < snapshot.data!.length; i++)
                        sticker(Image.network(snapshot.data![i]),
                            onPressed: () {
                          controller.addWidget(
                              Image.network(snapshot.data![i], width: 50));
                        })
                    ],
                  );
                }
              },
            ),
          ),
        ),
        body: LindiStickerWidget(
          controller: controller,
          child: Center(
            child: imageProvider.currentImage,
          ),
        ),
      ),
    );
  }
}
