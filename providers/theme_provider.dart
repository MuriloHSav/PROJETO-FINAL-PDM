import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // Ou ThemeMode.light como padrão

  ThemeMode get themeMode => _themeMode;

  // Adicione este getter:
  bool get isDarkMode => _themeMode == ThemeMode.dark; // <-- ESTE É O GETTER QUE FALTA

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}