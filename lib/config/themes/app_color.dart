import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color(0xFFA69CAC);
  static const Color secondaryColor = Color(0xFF161B33);
  static const Color midColor = Color(0xFF474973);
  static const Color backgroundLight = Color(0xFFF1DAC4);
  static const Color backgroundDark = Color(0xFF0D0C1D);
  static const Color black = Colors.black87;
  static const Color white = Colors.white70;
  static const Color primaryTextColor = Colors.white;

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
