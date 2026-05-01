import 'package:flutter/material.dart';

import '../models/pokemon.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({required this.pokemons, super.key});

  final List<Pokemon> pokemons;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        final String name = pokemons[index].name;
        final String capitalizedName = name.isNotEmpty
            ? '${name[0].toUpperCase()}${name.substring(1)}'
            : name;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Text(capitalizedName, style: const TextStyle(fontSize: 18)),
          ),
        );
      },
    );
  }
}
