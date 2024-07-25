import 'package:flutter/material.dart';
import 'package:mid/settings/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider {
  static const String _isDarkModeKey = 'isDarkMode';
  static const String _sortingCriteriaKey = 'sortingCriteria';

  Future<Settings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return Settings(
      isDarkMode: prefs.getBool(_isDarkModeKey) ?? false,
      sortingCriteria: prefs.getString(_sortingCriteriaKey) ?? 'title',
    );
  }

  Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, settings.isDarkMode);
    await prefs.setString(_sortingCriteriaKey, settings.sortingCriteria);
  }

  Future<void> saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDarkMode);
  }

  Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? false;
  }
}

class ThemeNotifier extends ChangeNotifier {
  final SettingsProvider settingsProvider;
  bool _isDarkMode = false;

  ThemeNotifier(this.settingsProvider) {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme =>
      _isDarkMode ? ThemeData.dark() : ThemeData.light();

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    settingsProvider.saveTheme(_isDarkMode);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = await settingsProvider.loadTheme();
    notifyListeners();
  }
}
