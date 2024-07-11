import 'package:Camera/config/themes/app_color.dart';
import 'package:flutter/material.dart';

class AppTextStyle {
  static AppTextStyle instance = AppTextStyle();

  TextStyle displayLarge = const TextStyle(
    color: AppColor.black,
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );
  TextStyle displayMedium = const TextStyle(
    color: AppColor.black,
    fontSize: 34,
    fontWeight: FontWeight.bold,
  );
  TextStyle displaySmall = const TextStyle(
    color: AppColor.black,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );
  TextStyle headlineLarge = const TextStyle(
    color: AppColor.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  TextStyle headlineMedium = const TextStyle(
    color: AppColor.black,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
  TextStyle headlineSmall = const TextStyle(
    color: AppColor.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  TextStyle titleLarge = const TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColor.black,
    fontSize: 20,
  );
  TextStyle titleMedium = const TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColor.black,
    fontSize: 18,
  );
  TextStyle titleSmall = const TextStyle(
    color: AppColor.black,
    fontSize: 16,
  );
  TextStyle labelLarge = const TextStyle(
    color: AppColor.black,
    fontSize: 16,
  );
  TextStyle labelMedium = const TextStyle(
    color: AppColor.black,
    fontSize: 14,
  );
  TextStyle labelSmall = const TextStyle(
    color: AppColor.black,
    fontSize: 12,
  );
  TextStyle bodyLarge = const TextStyle(
    color: AppColor.black,
    fontSize: 16,
  );
  TextStyle bodyMedium = const TextStyle(
    color: AppColor.black,
    fontSize: 14,
  );
  TextStyle bodySmall = const TextStyle(
    color: AppColor.black,
    fontSize: 12,
  );
}
