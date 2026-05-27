import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon_page.dart';

class PokemonService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<PokemonPage> fetchPokemons({
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
}

class PokemonServiceException implements Exception {
  const PokemonServiceException(this.message);

  final String message;
}
