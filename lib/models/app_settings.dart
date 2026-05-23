import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({required this.themeMode});

  final ThemeMode themeMode;

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == json['themeMode'],
        orElse: () => ThemeMode.system,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'themeMode': themeMode.name};
  }

  AppSettings copyWith({ThemeMode? themeMode}) {
    return AppSettings(themeMode: themeMode ?? this.themeMode);
  }
}
