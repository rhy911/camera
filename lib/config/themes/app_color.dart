import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryDark = Color(0xFF1F0330);
  static const Color backgroundDark = Color(0xFF000000);
  static const Color darkPurple = Color(0xFF52057B);

  static const Color black = Colors.black87;

  static const Color primaryLight = Color(0xFFF3DFFA);
  static const Color backgroundLight = Color(0xFFF9F9F9);
  static const Color lightPurple = Color(0xFFECC5FB);
  static const Color lightYellow = Color(0xFFFAF4B7);
  static const Color white = Color(0xFFFFFFFF);

  static const Color midColor = Color(0xFF474973);

  static const Color iconColor = Colors.white;
  static const Color vibrantColor = Color(0xFFE63946);
  static const Color popupMenuColor = Colors.black38;
  static const Color appBarColor = Colors.transparent;
  static const Color appBarIconColor = Colors.white;

  static MaterialColor transparentLight = const MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      20: Color(0x14FFFFFF),
      40: Color(0x29FFFFFF),
      60: Color(0x3DFFFFFF),
      80: Color(0x52FFFFFF),
      100: Color(0x64FFFFFF),
      200: Color(0xC8FFFFFF),
      300: Color(0x99FFFFFF),
      400: Color(0xCCFFFFFF),
      500: Color(0xFFFFFFFF),
    },
  );

  static MaterialColor transparentDark = const MaterialColor(
    0xFF000000,
    <int, Color>{
      20: Color(0x14000000),
      40: Color(0x29000000),
      60: Color(0x3D000000),
      80: Color(0x52000000),
      100: Color(0x64000000),
      200: Color(0xC8000000),
      300: Color(0x99000000),
      400: Color(0xCC000000),
      500: Color(0xFF000000),
    },
  );
}
