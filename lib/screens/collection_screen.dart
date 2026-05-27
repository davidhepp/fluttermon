import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../models/pokemon.dart';
import '../providers/collection_provider.dart';
import '../providers/team_provider.dart';
import '../widgets/app_bar.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  void _openPokemonDetail(BuildContext context, Pokemon pokemon) {
    Navigator.pushNamed(context, AppRoutes.pokemonDetail, arguments: pokemon);
  }

  @override
  Widget build(BuildContext context) {
    final collectionProvider = context.watch<CollectionProvider>();
    final teamProvider = context.read<TeamProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(
            title: 'Collection',
            imagePath: 'assets/images/appbar/appbar3.png',
          ),
          if (collectionProvider.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (collectionProvider.errorMessage != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      collectionProvider.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: collectionProvider.fetchCollection,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (collectionProvider.pokemons.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Your collection is currently empty.\nGo to the Pokédex to add your first Pokémon!',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid.builder(
                itemCount: collectionProvider.pokemons.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  final pokemon = collectionProvider.pokemons[index];

                  return _CollectionPokemonTile(
                    pokemon: pokemon,
                    onRemove: () async {
                      await collectionProvider.removePokemon(pokemon);
                      await teamProvider.removePokemon(pokemon);
                    },
                    onTap: () {
                      _openPokemonDetail(context, pokemon);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _CollectionPokemonTile extends StatelessWidget {
  const _CollectionPokemonTile({
    required this.pokemon,
    required this.onRemove,
    required this.onTap,
  });

  final Pokemon pokemon;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Expanded(
                    child: pokemon.imageUrl == null
                        ? Icon(
                            Icons.catching_pokemon,
                            size: 56,
                            color: theme.colorScheme.onSurfaceVariant,
                          )
                        : Image.network(
                            pokemon.imageUrl!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.catching_pokemon,
                                size: 56,
                                color: theme.colorScheme.onSurfaceVariant,
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatName(pokemon.name),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (pokemon.id != null)
                    Text(
                      '#${pokemon.id.toString().padLeft(3, '0')}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatName(String name) {
  return name
      .split('-')
      .map(
        (part) => part.isEmpty
            ? part
            : '${part[0].toUpperCase()}${part.substring(1)}',
      )
      .join(' ');
}
