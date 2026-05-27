import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermon/models/pokemon.dart';
import 'package:fluttermon/providers/collection_provider.dart';
import 'package:fluttermon/services/collection_service.dart';

void main() {
  group('CollectionProvider', () {
    test('adds pokemon and reports collected state', () async {
      final provider = CollectionProvider(_FakeCollectionService());
      const pokemon = Pokemon(
        name: 'bulbasaur',
        url: 'https://pokeapi.co/api/v2/pokemon/1/',
      );

      await provider.fetchCollection();
      await provider.addPokemon(pokemon);

      expect(provider.pokemons, hasLength(1));
      expect(provider.isCollected(pokemon), isTrue);
      expect(provider.isSaving, isFalse);
      expect(provider.saveErrorMessage, isNull);
    });

    test('removes pokemon and updates collected state', () async {
      final provider = CollectionProvider(_FakeCollectionService());
      const pokemon = Pokemon(
        name: 'bulbasaur',
        url: 'https://pokeapi.co/api/v2/pokemon/1/',
      );

      await provider.fetchCollection();
      await provider.addPokemon(pokemon);
      await provider.removePokemon(pokemon);

      expect(provider.pokemons, isEmpty);
      expect(provider.isCollected(pokemon), isFalse);
    });
  });
}

class _FakeCollectionService extends CollectionService {
  List<Pokemon> _collection = [];

  @override
  Future<List<Pokemon>> fetchCollection() async {
    return _collection;
  }

  @override
  Future<List<Pokemon>> addPokemon(Pokemon pokemon) async {
    _collection = [..._collection, pokemon];
    return _collection;
  }

  @override
  Future<List<Pokemon>> removePokemon(Pokemon pokemon) async {
    _collection = _collection.where((collectedPokemon) {
      return collectedPokemon.id != pokemon.id;
    }).toList();
    return _collection;
  }
}
