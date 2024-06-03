import 'package:flutter/material.dart';

Widget slider({value, onChanged}) {
  return Slider(
    label: '${value.toStringAsFixed(2)}',
    value: value,
    onChanged: onChanged,
    min: -0.9,
    max: 1,
    activeColor: Colors.white,
  );
}
