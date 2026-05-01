import 'package:flutter/material.dart';

import '../models/pokemon.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({required this.pokemons, super.key});

  final List<Pokemon> pokemons;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: pokemons.length,
        itemBuilder: (context, index) {
          final String name = pokemons[index].name;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Text(name, style: const TextStyle(fontSize: 18)),
            ),
          );
        },
      ),
    );
  }
}
