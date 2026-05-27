import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';
import '../providers/collection_provider.dart';
import '../providers/pokemon_detail_provider.dart';
import '../providers/team_provider.dart';

class PokemonDetailScreen extends StatefulWidget {
  const PokemonDetailScreen({super.key});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  Pokemon? _pokemon;
  bool _didFetch = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didFetch) {
      return;
    }

    _pokemon = ModalRoute.of(context)?.settings.arguments as Pokemon?;
    final pokemon = _pokemon;
    if (pokemon != null) {
      // Defer the provider update until this route has finished mounting.
      // fetchPokemonDetail notifies listeners immediately for its loading state;
      // doing that during provider/route construction can trip Flutter's
      // "dirty element" assertion.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        context.read<PokemonDetailProvider>().fetchPokemonDetail(pokemon);
      });
    }
    _didFetch = true;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonDetailProvider>();
    final collectionProvider = context.watch<CollectionProvider>();
    final teamProvider = context.read<TeamProvider>();
    final pokemon = _pokemon;

    return Scaffold(
      appBar: AppBar(title: Text(pokemon?.name ?? 'Pokemon')),
      body: _PokemonDetailBody(
        pokemon: pokemon,
        provider: provider,
        collectionProvider: collectionProvider,
        teamProvider: teamProvider,
        onRetry: pokemon == null
            ? null
            : () {
                provider.fetchPokemonDetail(pokemon);
              },
      ),
    );
  }
}

class _PokemonDetailBody extends StatelessWidget {
  const _PokemonDetailBody({
    required this.pokemon,
    required this.provider,
    required this.collectionProvider,
    required this.teamProvider,
    required this.onRetry,
  });

  final Pokemon? pokemon;
  final PokemonDetailProvider provider;
  final CollectionProvider collectionProvider;
  final TeamProvider teamProvider;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (pokemon == null) {
      return const Center(child: Text('No Pokemon selected'));
    }

    if (provider.isLoading ||
        (provider.detail == null && provider.errorMessage == null)) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(provider.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
    }

    final detail = provider.detail;
    if (detail == null) {
      return const Center(child: Text('No Pokemon details found'));
    }

    return _PokemonDetailContent(
      pokemon: pokemon!,
      detail: detail,
      collectionProvider: collectionProvider,
      teamProvider: teamProvider,
    );
  }
}

class _PokemonDetailContent extends StatelessWidget {
  const _PokemonDetailContent({
    required this.pokemon,
    required this.detail,
    required this.collectionProvider,
    required this.teamProvider,
  });

  final Pokemon pokemon;
  final PokemonDetail detail;
  final CollectionProvider collectionProvider;
  final TeamProvider teamProvider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCollected = collectionProvider.isCollected(pokemon);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (detail.imageUrl != null)
          Image.network(
            detail.imageUrl!,
            height: 220,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(height: 220);
            },
          ),
        const SizedBox(height: 12),
        Text(
          _formatName(detail.name),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          '#${detail.id.toString().padLeft(3, '0')}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        if (detail.genus != null) ...[
          const SizedBox(height: 4),
          Text(
            detail.genus!,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: detail.types
              .map((type) => _PokemonTypeBadge(type: type))
              .toList(),
        ),
        const SizedBox(height: 24),
        Text('Pokédex', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(detail.description, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 24),
        Text('Stats', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        ...detail.stats.map((stat) => _StatRow(stat: stat)),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: collectionProvider.isSaving
              ? null
              : () {
                  if (isCollected) {
                    collectionProvider.removePokemon(pokemon);
                    teamProvider.removePokemon(pokemon);
                  } else {
                    collectionProvider.addPokemon(pokemon);
                  }
                },
          icon: collectionProvider.isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(isCollected ? Icons.remove_circle_outline : Icons.add),
          label: Text(
            isCollected ? 'Remove from collection' : 'Add to collection',
          ),
        ),
        if (collectionProvider.saveErrorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            collectionProvider.saveErrorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],
      ],
    );
  }
}

class _PokemonTypeBadge extends StatelessWidget {
  const _PokemonTypeBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final assetPath = 'assets/images/types/$type.png';

    return Semantics(
      label: '${_formatName(type)} type',
      image: true,
      child: Image.asset(
        assetPath,
        height: 28,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Chip(label: Text(_formatName(type)));
        },
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.stat});

  final PokemonStat stat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (stat.baseStat / 255).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              _formatName(stat.name),
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(child: LinearProgressIndicator(value: progress)),
          const SizedBox(width: 12),
          SizedBox(
            width: 32,
            child: Text(
              stat.baseStat.toString(),
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium,
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
