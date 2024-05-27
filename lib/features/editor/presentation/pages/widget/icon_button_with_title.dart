import 'dart:math';

import 'package:flutter/material.dart';

Widget iconButtonWithTitle(IconData icon, String title, {required onPressed}) {
  return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ));
}

Widget rotatedIconButtonWithTitle(IconData icon, String title,
    {required onPressed}) {
  return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: pi / 2,
              child: Icon(icon),
            ),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ));
}

Widget imageIconButtonWithTitle(var image, String title, {required onPressed}) {
  return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 35, child: image),
              Text(title, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ));
}
