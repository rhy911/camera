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
          width: 55,
          height: 145,
          arrowHeight: 5,
          arrowWidth: 5,
          transitionDuration: Durations.short4,
        );
      },
      child: const Icon(
        Icons.aspect_ratio,
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
  State<AspectRatioMenu> createState() => _AspectRatioMenuState();
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
          child:
              const Text("9:16", style: TextStyle(color: Colors.indigoAccent)),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              as = 3 / 4;
            });
            widget.onAspectRatioChanged(as);
          },
          child: const Text(
            "3:4",
            style: TextStyle(color: Colors.indigoAccent),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              as = 1 / 1;
            });
            widget.onAspectRatioChanged(as);
          },
          child: const Text(
            "1:1",
            style: TextStyle(color: Colors.indigoAccent),
          ),
        ),
      ],
    );
  }
}
