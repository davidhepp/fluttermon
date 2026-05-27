import 'pokemon.dart';

class PokemonPage {
  const PokemonPage({required this.pokemons, required this.hasNextPage});

  final List<Pokemon> pokemons;
  final bool hasNextPage;

  factory PokemonPage.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List<dynamic>;

    return PokemonPage(
      pokemons: results
          .map((pokemonJson) => Pokemon.fromJson(pokemonJson))
          .toList(),
      hasNextPage: json['next'] != null,
    );
  }
}
