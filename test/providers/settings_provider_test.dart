import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermon/models/app_settings.dart';
import 'package:fluttermon/providers/settings_provider.dart';
import 'package:fluttermon/services/settings_service.dart';

void main() {
  group('SettingsProvider', () {
    test('updates the selected theme mode', () async {
      final provider = SettingsProvider(_FakeSettingsService());

      await provider.loadSettings();
      await provider.updateThemeMode(ThemeMode.dark);

      expect(provider.settings.themeMode, ThemeMode.dark);
      expect(provider.isLoading, isFalse);
      expect(provider.isSaving, isFalse);
      expect(provider.errorMessage, isNull);
    });
  });
}

class _FakeSettingsService extends SettingsService {
  AppSettings _settings = const AppSettings(themeMode: ThemeMode.system);

  @override
  Future<AppSettings> loadSettings() async {
    return _settings;
  }

  @override
  Future<AppSettings> saveThemeMode(ThemeMode themeMode) async {
    _settings = _settings.copyWith(themeMode: themeMode);
    return _settings;
  }
}
