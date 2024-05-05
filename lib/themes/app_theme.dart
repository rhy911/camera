import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData appThemeData() {
    return ThemeData(
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.pink[100],
      primaryTextTheme: const TextTheme(
        bodyMedium: TextStyle(
            color: Colors.white, fontSize: 70, fontWeight: FontWeight.w200),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      popupMenuTheme: const PopupMenuThemeData(
        color: Colors.black38,
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        toolbarHeight: 80.0,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 30.0),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}
