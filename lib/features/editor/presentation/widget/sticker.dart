import 'package:flutter/material.dart';

Widget sticker(image, {required onPressed}) {
  return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50, child: image),
            ],
          ),
        ),
      ));
}
