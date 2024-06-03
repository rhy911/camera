import 'package:Camera/features/editor/presentation/pages/widget/icon_button_with_title.dart';
import 'package:Camera/features/editor/presentation/pages/widget/slider.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;
import 'package:colorfilter_generator/addons.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class AdjustPage extends StatefulWidget {
  const AdjustPage({super.key});

  @override
  State<AdjustPage> createState() => _AdjustPageState();
}

class _AdjustPageState extends State<AdjustPage> {
  final ScreenshotController _screenshotController = ScreenshotController();

  double brightness = 0.0;
  double contrast = 0.0;
  double saturation = 0.0;
  double hue = 0.0;

  bool showBrightness = true;
  bool showContrast = false;
  bool showSaturation = false;
  bool showHue = false;

  late ColorFilterGenerator _colorFilterGenerator;

  adjust({b, c, s, h}) {
    _colorFilterGenerator = ColorFilterGenerator(name: 'Adjust', filters: [
      ColorFilterAddons.brightness(b ?? brightness),
      ColorFilterAddons.contrast(c ?? contrast),
      ColorFilterAddons.saturation(s ?? saturation),
      ColorFilterAddons.hue(h ?? hue)
    ]);
  }

  void selectAdjustment(
      bool brightness, bool contrast, bool saturation, bool hue) {
    setState(() {
      showBrightness = brightness;
      showContrast = contrast;
      showSaturation = saturation;
      showHue = hue;
    });
  }

  @override
  void initState() {
    super.initState();
    adjust();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<provider.ImageProvider>(
        builder: (BuildContext context, imageProvider, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Adjust'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                if (brightness != 0.0 ||
                    contrast != 0.0 ||
                    saturation != 0.0 ||
                    hue != 0.0) {
                  _screenshotController.capture().then((capturedImage) {
                    imageProvider.currentImage = Image.memory(capturedImage!);
                  });
                }
                Navigator.pop(context);
              },
              icon: const Icon(Icons.done),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Transform.translate(
                offset: Offset(0, showBrightness ? -10 : 0),
                child: iconButtonWithTitle(
                  Icons.brightness_medium_rounded,
                  'Brightness',
                  onPressed: () => selectAdjustment(true, false, false, false),
                ),
              ),
              Transform.translate(
                offset: Offset(0, showContrast ? -10 : 0),
                child: iconButtonWithTitle(
                  Icons.contrast_rounded,
                  'Contrast',
                  onPressed: () => selectAdjustment(false, true, false, false),
                ),
              ),
              Transform.translate(
                offset: Offset(0, showSaturation ? -10 : 0),
                child: imageIconButtonWithTitle(
                    Image.asset('assets/icons/saturation.png'), 'Saturation',
                    onPressed: () =>
                        selectAdjustment(false, false, true, false)),
              ),
              Transform.translate(
                  offset: Offset(0, showHue ? -10 : 0),
                  child: imageIconButtonWithTitle(
                    Image.asset('assets/icons/hue.png'),
                    'Hue',
                    onPressed: () =>
                        selectAdjustment(false, false, false, true),
                  ))
            ],
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: Screenshot(
                controller: _screenshotController,
                child: ColorFiltered(
                    colorFilter:
                        ColorFilter.matrix(_colorFilterGenerator.matrix),
                    child: imageProvider.currentImage),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (showBrightness) {
                            brightness = 0.0;
                            adjust(b: brightness);
                          }
                          if (showContrast) {
                            contrast = 0.0;
                            adjust(c: contrast);
                          }
                          if (showSaturation) {
                            saturation = 0.0;
                            adjust(s: saturation);
                          }
                          if (showHue) {
                            hue = 0.0;
                            adjust(h: hue);
                          }
                        });
                      },
                      child: const Text('Reset',
                          style: TextStyle(color: Colors.white))),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: showBrightness,
                          child: slider(
                            value: brightness,
                            onChanged: (value) {
                              setState(() {
                                brightness = value;
                                adjust(b: brightness);
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: showContrast,
                          child: slider(
                            value: contrast,
                            onChanged: (value) {
                              setState(() {
                                contrast = value;
                                adjust(b: contrast);
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: showSaturation,
                          child: slider(
                            value: saturation,
                            onChanged: (value) {
                              setState(() {
                                saturation = value;
                                adjust(s: saturation);
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: showHue,
                          child: slider(
                            value: hue,
                            onChanged: (value) {
                              setState(() {
                                hue = value;
                                adjust(h: hue);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
