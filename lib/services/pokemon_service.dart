import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import '../models/pokemon.dart';
import '../models/pokemon_page.dart';

class PokemonService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';
  static const String _pokemonIndexAsset = 'assets/data/pokemon_db.json';

  Future<PokemonPage> loadPokemonIndex() async {
    final jsonText = await rootBundle.loadString(_pokemonIndexAsset);
    final data = json.decode(jsonText) as Map<String, dynamic>;

    return PokemonPage.fromJson(data);
  }

  Future<PokemonPage> fetchPokemonPage({
    required int limit,
    required int offset,
  }) async {
    final uri = Uri.parse(
      _baseUrl,
    ).replace(queryParameters: {'limit': '$limit', 'offset': '$offset'});
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw const PokemonServiceException('Failed to load pokemons');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;

    return PokemonPage.fromJson(data);
  }

  Future<Pokemon> fetchPokemon(String query) async {
    final uri = Uri.parse('$_baseUrl/$query');
    final response = await http.get(uri);

    if (response.statusCode == 404) {
      throw const PokemonNotFoundException('Pokemon not found');
    }

    if (response.statusCode != 200) {
      throw const PokemonServiceException('Failed to load pokemon');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;

    return Pokemon.fromDetailJson(data);
  }
}

class PokemonServiceException implements Exception {
  const PokemonServiceException(this.message);

  final String message;
}

class PokemonNotFoundException extends PokemonServiceException {
  const PokemonNotFoundException(super.message);
}
