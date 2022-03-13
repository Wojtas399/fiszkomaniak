import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  toggleTheme(bool isOnDarkMode) {
    _themeMode = isOnDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
