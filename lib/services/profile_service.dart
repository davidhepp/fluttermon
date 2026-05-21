import '../models/user_profile.dart';

class ProfileService {
  Future<UserProfile> fetchProfile() async {
    return const UserProfile(
      name: 'Trainer',
      subtitle: 'Ready to catch them all',
    );
  }
}
