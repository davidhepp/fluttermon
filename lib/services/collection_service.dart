import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/pokemon.dart';

class CollectionService {
  static const String _collectionKey = 'pokemon_collection';

  Future<List<Pokemon>> fetchCollection() async {
    final preferences = await SharedPreferences.getInstance();
    final collectionJson = preferences.getString(_collectionKey);

    if (collectionJson == null) {
      return [];
    }

    final decoded = json.decode(collectionJson) as List<dynamic>;
    return decoded
        .map(
          (pokemonJson) =>
              Pokemon.fromJson(pokemonJson as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<Pokemon>> addPokemon(Pokemon pokemon) async {
    final currentCollection = await fetchCollection();
    final pokemonId = pokemon.id;

    if (pokemonId != null &&
        currentCollection.any((collectedPokemon) {
          return collectedPokemon.id == pokemonId;
        })) {
      return currentCollection;
    }

    final updatedCollection = [...currentCollection, pokemon];
    await _saveCollection(updatedCollection);

    return updatedCollection;
  }

  Future<List<Pokemon>> removePokemon(Pokemon pokemon) async {
    final currentCollection = await fetchCollection();
    final pokemonId = pokemon.id;
    final updatedCollection = currentCollection.where((collectedPokemon) {
      return collectedPokemon.id != pokemonId;
    }).toList();

    await _saveCollection(updatedCollection);

    return updatedCollection;
  }

  Future<void> _saveCollection(List<Pokemon> collection) async {
    final preferences = await SharedPreferences.getInstance();
    final encodedCollection = json.encode(
      collection.map((pokemon) => pokemon.toJson()).toList(),
    );

    await preferences.setString(_collectionKey, encodedCollection);
  }
}
