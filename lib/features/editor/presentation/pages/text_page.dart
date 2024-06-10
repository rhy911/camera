import 'package:Camera/features/editor/model/fonts.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;
import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:provider/provider.dart';
import 'package:text_editor/text_editor.dart';

class TextPage extends StatefulWidget {
  const TextPage({super.key});

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  LindiController controller = LindiController();
  bool showEditor = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<provider.ImageProvider>(
      builder: (context, imageProvider, child) {
        return Stack(
          children: [
            Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text('Text',
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
                body: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      showEditor = !showEditor;
                    });
                  },
                  child: Center(
                    child: LindiStickerWidget(
                        controller: controller,
                        child: imageProvider.currentImage),
                  ),
                )),
            if (showEditor)
              Scaffold(
                  backgroundColor: Colors.black54,
                  body: SafeArea(
                    child: TextEditor(
                      fonts: fonts,
                      textStyle: const TextStyle(color: Colors.white),
                      minFontSize: 10,
                      maxFontSize: 70,
                      onEditCompleted: (style, align, text) {
                        setState(() {
                          showEditor = false;
                          if (text.isNotEmpty) {
                            controller.addWidget(
                                Text(text, style: style, textAlign: align));
                          }
                        });
                      },
                    ),
                  ))
          ],
        );
      },
    );
  }
}
