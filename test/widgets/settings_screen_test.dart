import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fluttermon/models/app_settings.dart';
import 'package:fluttermon/models/user_profile.dart';
import 'package:fluttermon/providers/profile_provider.dart';
import 'package:fluttermon/providers/settings_provider.dart';
import 'package:fluttermon/screens/settings_screen.dart';
import 'package:fluttermon/services/profile_service.dart';
import 'package:fluttermon/services/settings_service.dart';

void main() {
  testWidgets('renders appearance settings', (tester) async {
    final settingsProvider = SettingsProvider(_LoadedSettingsService());
    final profileProvider = ProfileProvider(_LoadedProfileService());
    await settingsProvider.loadSettings();
    await profileProvider.fetchProfile();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settingsProvider),
          ChangeNotifierProvider.value(value: profileProvider),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Trainer name'), findsOneWidget);
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

class _LoadedProfileService extends ProfileService {
  @override
  Future<UserProfile> fetchProfile() async {
    return const UserProfile(
      name: 'Trainer',
      subtitle: 'Ready to catch them all',
    );
  }
}
