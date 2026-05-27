import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermon/models/pokemon.dart';

void main() {
  group('Pokemon', () {
    test('serializes to and from json', () {
      const pokemon = Pokemon(
        name: 'bulbasaur',
        url: 'https://pokeapi.co/api/v2/pokemon/1/',
      );

      final json = pokemon.toJson();
      final parsedPokemon = Pokemon.fromJson(json);

      expect(json, {
        'name': 'bulbasaur',
        'url': 'https://pokeapi.co/api/v2/pokemon/1/',
      });
      expect(parsedPokemon.name, 'bulbasaur');
      expect(parsedPokemon.id, 1);
    });
  });
}
