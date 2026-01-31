import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = false;

  ThemeMode get getTheme {
    if (isDark) {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
