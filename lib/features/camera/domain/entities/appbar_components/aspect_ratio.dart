import 'package:Camera/features/camera/provider/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AspectRatioButton extends StatefulWidget {
  const AspectRatioButton({super.key});

  @override
  State<AspectRatioButton> createState() => _AspectRatioButtonState();
}

class _AspectRatioButtonState extends State<AspectRatioButton> {
  @override
  Widget build(BuildContext context) {
    final aspectRatio = Provider.of<CameraState>(context).aspectRatio;
    return PopupMenuButton<double>(
      position: PopupMenuPosition.under,
      child: Row(
        children: [
          const Icon(Icons.aspect_ratio_rounded),
          const SizedBox(width: 5),
          Text(doubleToString(aspectRatio),
              style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
      onSelected: (double result) {
        Provider.of<CameraState>(context, listen: false).setAspectRatio(result);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<double>>[
        const PopupMenuItem<double>(
          value: 9 / 16,
          child:
              Text('9:16', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        const PopupMenuItem<double>(
          value: 3 / 4,
          child:
              Text('3:4', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        const PopupMenuItem<double>(
          value: 1 / 1,
          child:
              Text('1:1', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ],
    );
  }
}

Map<double, String> aspectRatios = {
  9 / 16: '9:16',
  3 / 4: '3:4',
  1 / 1: '1:1',
};

String doubleToString(double aspectRatio) {
  return aspectRatios[aspectRatio] ?? aspectRatio.toString();
}
