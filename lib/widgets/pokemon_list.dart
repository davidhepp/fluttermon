import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import 'pokemon_card.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({required this.pokemons, super.key});

  final List<Pokemon> pokemons;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        return PokemonCard(pokemon: pokemons[index]);
      },
    );
  }
}
