import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermon/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('serializes to and from json', () {
      const profile = UserProfile(
        name: 'Ash',
        subtitle: 'Ready to catch them all',
      );

      final json = profile.toJson();
      final parsedProfile = UserProfile.fromJson(json);

      expect(json, {'name': 'Ash', 'subtitle': 'Ready to catch them all'});
      expect(parsedProfile.name, 'Ash');
      expect(parsedProfile.subtitle, 'Ready to catch them all');
    });
  });
}
