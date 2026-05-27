import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermon/validators/pokemon_search_validator.dart';

void main() {
  group('validatePokemonSearchQuery', () {
    test('accepts empty search text', () {
      expect(validatePokemonSearchQuery(''), isNull);
    });

    test('requires at least two characters when searching', () {
      expect(validatePokemonSearchQuery('p'), 'Enter at least 2 characters');
    });

    test('rejects unsupported characters', () {
      expect(
        validatePokemonSearchQuery('pika!'),
        'Use letters, numbers, spaces, or hyphens',
      );
    });

    test('accepts pokemon-style search text', () {
      expect(validatePokemonSearchQuery('mr mime'), isNull);
      expect(validatePokemonSearchQuery('ho-oh'), isNull);
    });

    test('accepts numeric pokemon ids', () {
      expect(validatePokemonSearchQuery('1'), isNull);
      expect(validatePokemonSearchQuery('1000'), isNull);
    });
  });
}
