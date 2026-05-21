import 'package:flutter/material.dart';

import '../models/app_settings.dart';

class SettingsService {
  AppSettings _settings = const AppSettings(
    themeMode: ThemeMode.system,
    languageCode: 'en',
  );

  Future<AppSettings> loadSettings() async {
    return _settings;
  }

  Future<AppSettings> saveThemeMode(ThemeMode themeMode) async {
    _settings = _settings.copyWith(themeMode: themeMode);

    return _settings;
  }

  Future<AppSettings> saveLanguageCode(String languageCode) async {
    _settings = _settings.copyWith(languageCode: languageCode);

    return _settings;
  }
}

class SettingsServiceException implements Exception {
  const SettingsServiceException(this.message);

  final String message;
}
