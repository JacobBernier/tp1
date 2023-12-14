import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkTheme = true; // Set the initial theme to dark

  ThemeData get themeData =>
      _isDarkTheme ? ThemeData.dark() : ThemeData.light();

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
}
