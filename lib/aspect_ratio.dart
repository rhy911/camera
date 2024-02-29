import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class MyButton extends StatelessWidget {
  MyButton(this.ap, {super.key});
  double ap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => AspectRatioMenu(ap),
          direction: PopoverDirection.top,
          width: 60,
          height: 150,
          arrowHeight: 10,
          arrowWidth: 10,
        );
      },
      child: const Icon(Icons.aspect_ratio),
    );
  }
}

class AspectRatioMenu extends StatelessWidget {
  AspectRatioMenu(this.as, {super.key});
  double as = 9 / 16;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            as = 9 / 16;
          },
          child: const Text("9:16"),
        ),
        TextButton(
          onPressed: () {
            as = 3 / 4;
          },
          child: const Text("3:4"),
        ),
        TextButton(
          onPressed: () {
            as = 1 / 1;
          },
          child: const Text("1:1"),
        ),
      ],
    );
  }
}
