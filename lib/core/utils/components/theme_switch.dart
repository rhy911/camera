import 'package:Camera/config/themes/app_color.dart';
import 'package:Camera/config/themes/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return FlutterSwitch(
      height: 40,
      width: 90,
      toggleSize: 40,
      showOnOff: true,
      value: themeProvider.isDarkMode,
      onToggle: (bool value) {
        themeProvider.switchThemeData(value);
      },
      activeColor: AppColor.transparentLight[80]!,
      activeToggleColor: AppColor.backgroundLight,
      activeIcon: const Icon(
        Icons.dark_mode_rounded,
        color: AppColor.black,
      ),
      activeText: 'Dark',
      activeTextColor: AppColor.transparentDark[200]!,
      inactiveColor: AppColor.transparentDark[80]!,
      inactiveToggleColor: AppColor.backgroundDark,
      inactiveIcon: const Icon(
        Icons.light_mode_rounded,
        color: AppColor.white,
      ),
      inactiveText: 'Light',
      inactiveTextColor: AppColor.transparentLight[200]!,
    );
  }
}
