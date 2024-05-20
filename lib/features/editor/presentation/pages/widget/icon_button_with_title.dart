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
