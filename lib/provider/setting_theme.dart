import 'package:flutter/material.dart';

class ThemeModeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  
  set isDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  Color get backgroundColor {
    Color backgroundColor = _isDarkMode
                    ? Colors.black
                    : Colors.white;
    return backgroundColor;
  }

  Color get textColor {
    Color textColor = _isDarkMode
                    ? Colors.white
                    : Colors.black;
    return textColor;
  }
}