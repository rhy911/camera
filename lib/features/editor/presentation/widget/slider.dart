import 'package:flutter/material.dart';

Widget adjustSlider({value, onChanged}) {
  return Slider(
    label: '${value.toStringAsFixed(2)}',
    value: value,
    onChanged: onChanged,
    min: -0.9,
    max: 1,
    activeColor: Colors.white,
  );
}

Widget drawSlider({value, onChanged}) {
  return Slider(
    label: '${value.toStringAsFixed(2)}',
    value: value,
    onChanged: onChanged,
    min: 1,
    max: 30,
    activeColor: Colors.white,
  );
}
