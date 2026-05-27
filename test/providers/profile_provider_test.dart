import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermon/models/user_profile.dart';
import 'package:fluttermon/providers/profile_provider.dart';
import 'package:fluttermon/services/profile_service.dart';

void main() {
  group('ProfileProvider', () {
    test('updates the trainer name', () async {
      final provider = ProfileProvider(_FakeProfileService());

      await provider.fetchProfile();
      await provider.updateName('Brock');

      expect(provider.profile?.name, 'Brock');
      expect(provider.isSaving, isFalse);
      expect(provider.saveErrorMessage, isNull);
    });
  });
}

class _FakeProfileService extends ProfileService {
  UserProfile _profile = const UserProfile(
    name: 'Trainer',
    subtitle: 'Ready to catch them all',
  );

  @override
  Future<UserProfile> fetchProfile() async {
    return _profile;
  }

  @override
  Future<UserProfile> saveName(String name) async {
    _profile = _profile.copyWith(name: name.trim());
    return _profile;
  }
}
