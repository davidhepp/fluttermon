import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttermon/models/pokemon.dart';
import 'package:fluttermon/services/collection_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CollectionService', () {
    test('saves and loads collected pokemon', () async {
      SharedPreferences.setMockInitialValues({});
      final service = CollectionService();

      await service.addPokemon(
        const Pokemon(
          name: 'bulbasaur',
          url: 'https://pokeapi.co/api/v2/pokemon/1/',
        ),
      );
      final collection = await service.fetchCollection();

      expect(collection.map((pokemon) => pokemon.name), ['bulbasaur']);
    });

    test('does not add duplicate pokemon ids', () async {
      SharedPreferences.setMockInitialValues({});
      final service = CollectionService();
      const pokemon = Pokemon(
        name: 'bulbasaur',
        url: 'https://pokeapi.co/api/v2/pokemon/1/',
      );

      await service.addPokemon(pokemon);
      await service.addPokemon(pokemon);
      final collection = await service.fetchCollection();

      expect(collection, hasLength(1));
    });

    test('removes collected pokemon', () async {
      SharedPreferences.setMockInitialValues({});
      final service = CollectionService();
      const pokemon = Pokemon(
        name: 'bulbasaur',
        url: 'https://pokeapi.co/api/v2/pokemon/1/',
      );

      await service.addPokemon(pokemon);
      final collection = await service.removePokemon(pokemon);

      expect(collection, isEmpty);
    });
  });
}
