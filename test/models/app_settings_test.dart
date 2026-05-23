import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermon/models/app_settings.dart';

void main() {
  group('AppSettings', () {
    test('serializes to and from json', () {
      const settings = AppSettings(themeMode: ThemeMode.dark);

      final json = settings.toJson();
      final parsedSettings = AppSettings.fromJson(json);

      expect(json, {'themeMode': 'dark'});
      expect(parsedSettings.themeMode, ThemeMode.dark);
    });

    test('uses defaults for unknown json values', () {
      final settings = AppSettings.fromJson({'themeMode': 'unknown'});

      expect(settings.themeMode, ThemeMode.system);
    });
  });
}
