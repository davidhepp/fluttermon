import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttermon/services/settings_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsService', () {
    test('saves and loads the selected theme mode', () async {
      SharedPreferences.setMockInitialValues({});
      final service = SettingsService();

      await service.saveThemeMode(ThemeMode.dark);
      final settings = await service.loadSettings();

      expect(settings.themeMode, ThemeMode.dark);
    });

    test('uses system theme when no theme mode is saved', () async {
      SharedPreferences.setMockInitialValues({});
      final service = SettingsService();

      final settings = await service.loadSettings();

      expect(settings.themeMode, ThemeMode.system);
    });
  });
}
