import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = false;

  ThemeProvider() {
    loadTheme();
  }

  void toggleTheme() async {
    isDark = !isDark;

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDark", isDark);

    notifyListeners();
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool("isDark") ?? false;
    notifyListeners();
  }
}