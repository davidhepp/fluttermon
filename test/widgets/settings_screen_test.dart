import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fluttermon/models/app_settings.dart';
import 'package:fluttermon/providers/settings_provider.dart';
import 'package:fluttermon/screens/settings_screen.dart';
import 'package:fluttermon/services/settings_service.dart';

void main() {
  testWidgets('renders appearance settings', (tester) async {
    final provider = SettingsProvider(_LoadedSettingsService());
    await provider.loadSettings();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
  });
}

class _LoadedSettingsService extends SettingsService {
  @override
  Future<AppSettings> loadSettings() async {
    return const AppSettings(themeMode: ThemeMode.light);
  }
}
