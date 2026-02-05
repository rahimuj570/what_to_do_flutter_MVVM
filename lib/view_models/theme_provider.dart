import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;

  ThemeProvider() {
    _fetchSavedTheme();
  }

  bool get isDark => _isDark;

  ThemeMode get getTheme {
    if (_isDark) {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }

  void toggleTheme({required bool isDark}) async {
    _isDark = isDark;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isDark', isDark);
    notifyListeners();
  }

  Future<void> _fetchSavedTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _isDark = sharedPreferences.getBool('isDark') ?? false;
    notifyListeners();
  }
}
