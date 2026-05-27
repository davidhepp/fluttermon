import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

class ProfileService {
  static const String _profileKey = 'user_profile';
  static const UserProfile _defaultProfile = UserProfile(
    name: 'Trainer',
    subtitle: 'Ready to catch them all',
  );

  Future<UserProfile> fetchProfile() async {
    final preferences = await SharedPreferences.getInstance();
    final profileJson = preferences.getString(_profileKey);

    if (profileJson == null) {
      return _defaultProfile;
    }

    return UserProfile.fromJson(
      json.decode(profileJson) as Map<String, dynamic>,
    );
  }

  Future<UserProfile> saveName(String name) async {
    final preferences = await SharedPreferences.getInstance();
    final currentProfile = await fetchProfile();
    final updatedProfile = currentProfile.copyWith(name: name.trim());

    await preferences.setString(
      _profileKey,
      json.encode(updatedProfile.toJson()),
    );

    return updatedProfile;
  }
}
