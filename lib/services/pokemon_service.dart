import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonService {
  static const String apiUrl = 'https://pokeapi.co/api/v2/pokemon?limit=10000';

  Future<List<Pokemon>> fetchPokemons() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode != 200) {
      throw const PokemonServiceException('Failed to load pokemons');
    }

    final data = json.decode(response.body);
    final List<dynamic> results = data['results'];

    return results.map((pokemonJson) => Pokemon.fromJson(pokemonJson)).toList();
  }
}

class PokemonServiceException implements Exception {
  const PokemonServiceException(this.message);

  final String message;
}
