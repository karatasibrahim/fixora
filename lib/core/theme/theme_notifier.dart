import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme_mode');
    _mode = switch (saved) {
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.light,
    };
    notifyListeners();
  }

  void set(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    SharedPreferences.getInstance()
        .then((p) => p.setString('theme_mode', mode.name));
  }
}

final themeNotifier = ThemeNotifier();
