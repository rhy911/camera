import 'dart:math';

import 'package:flutter/material.dart';

Widget iconButtonWithTitle(IconData icon, String title, {required onPressed}) {
  return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
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
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: pi / 2,
              child: Icon(icon, color: Colors.white),
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
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 25, child: image),
              Text(title, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ));
}
