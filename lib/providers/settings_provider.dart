import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._settingsService);

  final SettingsService _settingsService;

  AppSettings settings = const AppSettings(
    themeMode: ThemeMode.system,
    languageCode: 'en',
  );
  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;

  ThemeMode get themeMode => settings.themeMode;

  Future<void> loadSettings() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      settings = await _settingsService.loadSettings();
    } on SettingsServiceException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await _save(() => _settingsService.saveThemeMode(themeMode));
  }

  Future<void> updateLanguageCode(String languageCode) async {
    await _save(() => _settingsService.saveLanguageCode(languageCode));
  }

  Future<void> _save(Future<AppSettings> Function() saveSettings) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      settings = await saveSettings();
    } on SettingsServiceException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Error: $e';
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
