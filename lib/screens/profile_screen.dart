import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../models/pokemon.dart';
import '../providers/collection_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/team_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final collectionProvider = context.watch<CollectionProvider>();
    final teamProvider = context.watch<TeamProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (profileProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(profileProvider.errorMessage!),
                  TextButton(
                    onPressed: profileProvider.fetchProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final profile = profileProvider.profile;
          if (profile == null) {
            return const Center(child: Text('No profile found'));
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.person,
                  size: 52,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                profile.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                profile.subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              Text('Team', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _TeamSlotGrid(
                team: teamProvider.team,
                isLoading: teamProvider.isLoading,
                isSaving: teamProvider.isSaving,
                errorMessage: teamProvider.errorMessage,
                saveErrorMessage: teamProvider.saveErrorMessage,
                collection: collectionProvider.pokemons,
                isCollectionLoading: collectionProvider.isLoading,
                onRetryTeam: teamProvider.fetchTeam,
                onSelectPokemon: teamProvider.setPokemonAtSlot,
                onClearSlot: teamProvider.clearSlot,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TeamSlotGrid extends StatelessWidget {
  const _TeamSlotGrid({
    required this.team,
    required this.isLoading,
    required this.isSaving,
    required this.errorMessage,
    required this.saveErrorMessage,
    required this.collection,
    required this.isCollectionLoading,
    required this.onRetryTeam,
    required this.onSelectPokemon,
    required this.onClearSlot,
  });

  final List<Pokemon?> team;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? saveErrorMessage;
  final List<Pokemon> collection;
  final bool isCollectionLoading;
  final VoidCallback onRetryTeam;
  final Future<void> Function(int slotIndex, Pokemon pokemon) onSelectPokemon;
  final Future<void> Function(int slotIndex) onClearSlot;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(errorMessage!),
          TextButton(onPressed: onRetryTeam, child: const Text('Retry')),
        ],
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final pokemon = team[index];

        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: isSaving
              ? null
              : () {
                  _showTeamPicker(context, index);
                },
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(8),
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.35,
              ),
            ),
            child: pokemon == null
                ? Center(
                    child: Icon(
                      Icons.add,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  )
                : _TeamPokemonSlot(
                    pokemon: pokemon,
                    onClear: isSaving
                        ? null
                        : () {
                            onClearSlot(index);
                          },
                  ),
          ),
        );
      },
    );
  }

  Future<void> _showTeamPicker(BuildContext context, int slotIndex) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        if (isCollectionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (collection.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Collect Pokemon from the Pokédex before adding them to your team.',
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.builder(
          itemCount: collection.length,
          itemBuilder: (context, index) {
            final pokemon = collection[index];

            return ListTile(
              leading: pokemon.imageUrl == null
                  ? const Icon(Icons.catching_pokemon)
                  : Image.network(
                      pokemon.imageUrl!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.catching_pokemon);
                      },
                    ),
              title: Text(_formatName(pokemon.name)),
              subtitle: pokemon.id == null
                  ? null
                  : Text('#${pokemon.id.toString().padLeft(3, '0')}'),
              onTap: () async {
                await onSelectPokemon(slotIndex, pokemon);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            );
          },
        );
      },
    );
  }
}

class _TeamPokemonSlot extends StatelessWidget {
  const _TeamPokemonSlot({required this.pokemon, required this.onClear});

  final Pokemon pokemon;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: pokemon.imageUrl == null
                    ? Icon(
                        Icons.catching_pokemon,
                        color: theme.colorScheme.onSurfaceVariant,
                      )
                    : Image.network(
                        pokemon.imageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.catching_pokemon,
                            color: theme.colorScheme.onSurfaceVariant,
                          );
                        },
                      ),
              ),
              Text(
                _formatName(pokemon.name),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Remove from team',
            onPressed: onClear,
          ),
        ),
      ],
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
