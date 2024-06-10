import 'package:Camera/features/editor/presentation/widget/icon_button_with_title.dart';
import 'package:Camera/features/editor/presentation/widget/slider.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:painter/painter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class DrawPage extends StatefulWidget {
  const DrawPage({super.key});

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  ScreenshotController screenshotController = ScreenshotController();
  final PainterController painterController = PainterController();
  Color pickerColor = Colors.white;

  @override
  void initState() {
    super.initState();
    painterController.backgroundColor = Colors.transparent;
    painterController.drawColor = Colors.white;
    painterController.thickness = 5.0;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<provider.ImageProvider>(
      builder: (BuildContext context, imageProvider, Widget? child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Draw',
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
                  final image = await screenshotController.capture();
                  imageProvider.currentImagePath = image;
                  imageProvider.currentImage = Image.memory(image!);
                  if (context.mounted) Navigator.pop(context);
                },
                icon: const Icon(Icons.done))
          ],
        ),
        bottomNavigationBar: BottomAppBar(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            imageIconButtonWithTitle(
              Image.asset('assets/icons/pencil.png'),
              'Pencil',
              onPressed: () {
                setState(() {
                  painterController.eraseMode = false;
                });
              },
            ),
            imageIconButtonWithTitle(
              Image.asset('assets/icons/eraser.png'),
              'Eraser',
              onPressed: () {
                setState(() {
                  painterController.eraseMode = true;
                });
              },
            ),
            iconButtonWithTitle(Icons.color_lens_outlined, 'Color',
                onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Pick a color!'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: pickerColor,
                            onColorChanged: (color) {
                              setState(() {
                                pickerColor = color;
                                painterController.drawColor = pickerColor;
                              });
                            },
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Done'))
                        ],
                      ));
            }),
            iconButtonWithTitle(Icons.undo, 'Undo', onPressed: () {
              painterController.undo();
            })
          ],
        )),
        body: Stack(
          children: [
            Center(
              child: Screenshot(
                  controller: screenshotController,
                  child: Stack(children: [
                    PhotoView(imageProvider: imageProvider.currentImage.image),
                    Painter(painterController),
                  ])),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: painterController.drawColor,
                          size: painterController.thickness + 5,
                        ),
                        Expanded(
                          child: drawSlider(
                              value: painterController.thickness,
                              onChanged: (value) {
                                setState(() {
                                  painterController.thickness = value;
                                });
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
