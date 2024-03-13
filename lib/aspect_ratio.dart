import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class MyButton extends StatelessWidget {
  const MyButton(this.ap, this.onAspectRatioChanged, {super.key});
  final double ap;
  final ValueChanged<double> onAspectRatioChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => AspectRatioMenu(
            initialAspectRatio: ap,
            onAspectRatioChanged: onAspectRatioChanged,
          ),
          direction: PopoverDirection.top,
          width: 60,
          height: 150,
          arrowHeight: 10,
          arrowWidth: 10,
        );
      },
      child: const Icon(
        Icons.aspect_ratio,
        color: Colors.white,
      ),
    );
  }
}

class AspectRatioMenu extends StatefulWidget {
  const AspectRatioMenu({
    super.key,
    required this.initialAspectRatio,
    required this.onAspectRatioChanged,
  });

  final double initialAspectRatio;
  final ValueChanged<double> onAspectRatioChanged;

  @override
  _AspectRatioMenuState createState() => _AspectRatioMenuState();
}

class _AspectRatioMenuState extends State<AspectRatioMenu> {
  late double as = 9 / 16;

  @override
  void initState() {
    super.initState();
    as = widget.initialAspectRatio;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              as = 9 / 16;
            });
            widget.onAspectRatioChanged(as);
          },
          child: const Text("9:16"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              as = 3 / 4;
            });
            widget.onAspectRatioChanged(as);
          },
          child: const Text("3:4"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              as = 1 / 1;
            });
            widget.onAspectRatioChanged(as);
          },
          child: const Text("1:1"),
        ),
      ],
    );
  }
}
