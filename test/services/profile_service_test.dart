import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttermon/services/profile_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileService', () {
    test('saves and loads the trainer name', () async {
      SharedPreferences.setMockInitialValues({});
      final service = ProfileService();

      await service.saveName('Misty');
      final profile = await service.fetchProfile();

      expect(profile.name, 'Misty');
      expect(profile.subtitle, 'Ready to catch them all');
    });

    test('uses default profile when no profile is saved', () async {
      SharedPreferences.setMockInitialValues({});
      final service = ProfileService();

      final profile = await service.fetchProfile();

      expect(profile.name, 'Trainer');
      expect(profile.subtitle, 'Ready to catch them all');
    });
  });
}
