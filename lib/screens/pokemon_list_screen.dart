import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_list.dart';

class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pokemonProvider = context.watch<PokemonProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon'), centerTitle: true),
      body: pokemonProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : pokemonProvider.errorMessage != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(pokemonProvider.errorMessage!),
                  TextButton(
                    onPressed: pokemonProvider.fetchPokemons,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : pokemonProvider.pokemons.isEmpty
          ? const Center(child: Text('No pokemons found'))
          : PokemonList(pokemons: pokemonProvider.pokemons),
    );
  }
}
