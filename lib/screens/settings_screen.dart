import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import '../providers/settings_provider.dart';
import '../validators/profile_validator.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _loadedProfileName;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _syncNameField(String name) {
    if (_loadedProfileName == name) {
      return;
    }

    _loadedProfileName = name;
    _nameController.text = name;
  }

  Future<void> _saveName(ProfileProvider profileProvider) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    await profileProvider.updateName(_nameController.text);
    if (!mounted || profileProvider.saveErrorMessage != null) {
      return;
    }

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final profileProvider = context.watch<ProfileProvider>();

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

          final profile = profileProvider.profile;
          if (profile != null) {
            _syncNameField(profile.name);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (settingsProvider.isSaving || profileProvider.isSaving)
                const LinearProgressIndicator(),
              const SizedBox(height: 8),
              Text('Profile', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (profileProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (profileProvider.errorMessage != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profileProvider.errorMessage!),
                    TextButton(
                      onPressed: profileProvider.fetchProfile,
                      child: const Text('Retry'),
                    ),
                  ],
                )
              else if (profile == null)
                const Text('No profile found')
              else
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _nameController,
                    validator: (value) => validateTrainerName(value ?? ''),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Trainer name',
                      border: const OutlineInputBorder(),
                      errorText: profileProvider.saveErrorMessage,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.save),
                        tooltip: 'Save trainer name',
                        onPressed: profileProvider.isSaving
                            ? null
                            : () => _saveName(profileProvider),
                      ),
                    ),
                    onFieldSubmitted: (_) => _saveName(profileProvider),
                  ),
                ),
              const SizedBox(height: 24),
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
            ],
          );
        },
      ),
    );
  }
}
