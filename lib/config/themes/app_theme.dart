import 'package:Camera/config/themes/app_color.dart';
import 'package:Camera/config/themes/app_textstyle.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final AppTextStyle _textStyle = AppTextStyle.instance;
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColor.primaryLight,
    scaffoldBackgroundColor: AppColor.backgroundLight,
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColor.popupMenuColor,
    ),
    appBarTheme: const AppBarTheme(
        color: AppColor.appBarColor,
        toolbarHeight: 80.0,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColor.white),
        titleTextStyle: TextStyle(
          color: AppColor.primaryDark,
          fontSize: 30.0,
        )),
    textTheme: TextTheme(
      displayLarge: _textStyle.displayLarge,
      displayMedium: _textStyle.displayMedium,
      displaySmall: _textStyle.displaySmall,
      headlineLarge: _textStyle.headlineLarge,
      headlineMedium: _textStyle.headlineMedium,
      headlineSmall: _textStyle.headlineSmall,
      titleLarge: _textStyle.titleLarge,
      titleSmall: _textStyle.titleSmall,
      titleMedium: _textStyle.titleMedium,
      labelLarge: _textStyle.labelLarge,
      labelMedium: _textStyle.labelMedium,
      labelSmall: _textStyle.labelSmall,
      bodyLarge: _textStyle.bodyLarge,
      bodyMedium: _textStyle.bodyMedium,
      bodySmall: _textStyle.bodySmall,
    ),
  );
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColor.primaryDark,
    scaffoldBackgroundColor: AppColor.backgroundDark,
    iconTheme: const IconThemeData(color: AppColor.iconColor),
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColor.popupMenuColor,
    ),
    appBarTheme: const AppBarTheme(
        color: AppColor.appBarColor,
        toolbarHeight: 80.0,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColor.primaryLight,
          fontSize: 30.0,
        )),
    textTheme: TextTheme(
      displayLarge: _textStyle.displayLarge.copyWith(color: AppColor.white),
      displayMedium: _textStyle.displayMedium.copyWith(color: AppColor.white),
      displaySmall: _textStyle.displaySmall.copyWith(color: AppColor.white),
      headlineLarge: _textStyle.headlineLarge.copyWith(color: AppColor.white),
      headlineMedium: _textStyle.headlineMedium.copyWith(color: AppColor.white),
      headlineSmall: _textStyle.headlineSmall.copyWith(color: AppColor.white),
      titleLarge: _textStyle.titleLarge.copyWith(color: AppColor.white),
      titleSmall: _textStyle.titleSmall.copyWith(color: AppColor.white),
      titleMedium: _textStyle.titleMedium.copyWith(color: AppColor.white),
      labelLarge: _textStyle.labelLarge.copyWith(),
      labelMedium: _textStyle.labelMedium.copyWith(color: AppColor.white),
      labelSmall: _textStyle.labelSmall.copyWith(color: AppColor.white),
      bodyLarge: _textStyle.bodyLarge.copyWith(color: AppColor.white),
      bodyMedium: _textStyle.bodyMedium.copyWith(color: AppColor.white),
      bodySmall: _textStyle.bodySmall.copyWith(color: AppColor.white),
    ),
  );
}
