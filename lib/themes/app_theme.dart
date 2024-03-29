// File theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData appThemeData() {
    return ThemeData(
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      primaryTextTheme: const TextTheme(
        bodyMedium: TextStyle(
            color: Colors.white, fontSize: 70, fontWeight: FontWeight.w200),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      appBarTheme: const AppBarTheme(
        color: Colors.black,
        toolbarHeight: 90.0,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 30.0),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}
