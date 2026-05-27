import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermon/validators/profile_validator.dart';

void main() {
  group('validateTrainerName', () {
    test('requires a non-empty name', () {
      expect(validateTrainerName(''), 'Enter a trainer name');
    });

    test('requires at least two characters', () {
      expect(validateTrainerName('A'), 'Name must be at least 2 characters');
    });

    test('limits long names', () {
      expect(
        validateTrainerName('A very very very long trainer name'),
        'Name must be 24 characters or fewer',
      );
    });

    test('accepts valid names', () {
      expect(validateTrainerName('Ash'), isNull);
    });
  });
}
