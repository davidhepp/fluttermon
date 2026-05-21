import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Map<String, String> _languages = {
    'en': 'English',
    'de': 'Deutsch',
  };

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Builder(
        builder: (context) {
          if (settingsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (settingsProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(settingsProvider.errorMessage!),
                  TextButton(
                    onPressed: settingsProvider.loadSettings,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (settingsProvider.isSaving) const LinearProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                'Appearance',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: Icon(Icons.brightness_auto),
                    label: Text('System'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: Icon(Icons.light_mode),
                    label: Text('Light'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: Icon(Icons.dark_mode),
                    label: Text('Dark'),
                  ),
                ],
                selected: {settingsProvider.settings.themeMode},
                onSelectionChanged: settingsProvider.isSaving
                    ? null
                    : (selection) {
                        settingsProvider.updateThemeMode(selection.first);
                      },
              ),
              const SizedBox(height: 24),
              Text('Language', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: settingsProvider.settings.languageCode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Language',
                ),
                items: _languages.entries
                    .map(
                      (language) => DropdownMenuItem(
                        value: language.key,
                        child: Text(language.value),
                      ),
                    )
                    .toList(),
                onChanged: settingsProvider.isSaving
                    ? null
                    : (languageCode) {
                        if (languageCode != null) {
                          settingsProvider.updateLanguageCode(languageCode);
                        }
                      },
              ),
            ],
          );
        },
      ),
    );
  }
}
