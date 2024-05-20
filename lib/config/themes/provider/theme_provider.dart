import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeData = ThemeMode.dark;
  bool _isDarkMode = true;

  ThemeMode get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  void switchThemeData(bool newStatus) {
    switch (_isDarkMode) {
      case false:
        _themeData = ThemeMode.dark;
        _isDarkMode = newStatus;
        break;
      case true:
        _themeData = ThemeMode.light;
        _isDarkMode = newStatus;
        break;
      default:
        ThemeMode.system;
        _themeData = ThemeMode.system;
        break;
    }
    notifyListeners();
  }
}
