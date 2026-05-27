import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import 'pokemon_card.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({
    required this.pokemons,
    required this.isLoadingMore,
    required this.loadMoreErrorMessage,
    required this.hasMorePokemons,
    required this.showEndMessage,
    required this.onRetryLoadMore,
    required this.onPokemonTap,
    super.key,
  });

  final List<Pokemon> pokemons;
  final bool isLoadingMore;
  final String? loadMoreErrorMessage;
  final bool hasMorePokemons;
  final bool showEndMessage;
  final VoidCallback onRetryLoadMore;
  final ValueChanged<Pokemon> onPokemonTap;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: pokemons.length + 1,
      itemBuilder: (context, index) {
        if (index == pokemons.length) {
          return _PokemonListFooter(
            isLoadingMore: isLoadingMore,
            errorMessage: loadMoreErrorMessage,
            hasMorePokemons: hasMorePokemons,
            showEndMessage: showEndMessage,
            onRetry: onRetryLoadMore,
          );
        }

        final pokemon = pokemons[index];

        return PokemonCard(
          pokemon: pokemon,
          onTap: () {
            onPokemonTap(pokemon);
          },
        );
      },
    );
  }
}

class _PokemonListFooter extends StatelessWidget {
  const _PokemonListFooter({
    required this.isLoadingMore,
    required this.errorMessage,
    required this.hasMorePokemons,
    required this.showEndMessage,
    required this.onRetry,
  });

  final bool isLoadingMore;
  final String? errorMessage;
  final bool hasMorePokemons;
  final bool showEndMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Text(errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (!hasMorePokemons && showEndMessage) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text('All pokemons loaded')),
      );
    }

    return const SizedBox(height: 24);
  }
}
