import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

class SettingsService {
  static const String _themeModeKey = 'theme_mode';

  Future<AppSettings> loadSettings() async {
    final preferences = await SharedPreferences.getInstance();
    final savedThemeMode = preferences.getString(_themeModeKey);

    return AppSettings(themeMode: _themeModeFromString(savedThemeMode));
  }

  Future<AppSettings> saveThemeMode(ThemeMode themeMode) async {
    final preferences = await SharedPreferences.getInstance();
    final didSave = await preferences.setString(_themeModeKey, themeMode.name);

    if (!didSave) {
      throw const SettingsServiceException('Failed to save theme mode');
    }

    return loadSettings();
  }

  ThemeMode _themeModeFromString(String? themeMode) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == themeMode,
      orElse: () => ThemeMode.system,
    );
  }
}

class SettingsServiceException implements Exception {
  const SettingsServiceException(this.message);

  final String message;
}
