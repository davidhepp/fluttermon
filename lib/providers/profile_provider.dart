import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';
import '../services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider(this._profileService);

  final ProfileService _profileService;

  UserProfile? profile;
  bool isLoading = true;
  String? errorMessage;

  Future<void> fetchProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      profile = await _profileService.fetchProfile();
    } catch (e) {
      errorMessage = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
