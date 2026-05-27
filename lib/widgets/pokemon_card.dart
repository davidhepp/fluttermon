import 'package:flutter/material.dart';

import '../models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    required this.pokemon,
    this.isCollected = false,
    this.onTap,
    super.key,
  });

  final Pokemon pokemon;
  final bool isCollected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = pokemon.imageUrl;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _PokemonImage(imageUrl: imageUrl),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatName(pokemon.name),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (pokemon.id != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '#${pokemon.id.toString().padLeft(3, '0')}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isCollected) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                  semanticLabel: 'Collected',
                ),
              ],
            ],
          ),
        ),
      ),
    );
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
}

class _PokemonImage extends StatelessWidget {
  const _PokemonImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: 72,
        height: 72,
        child: imageUrl == null
            ? Icon(Icons.catching_pokemon, color: colorScheme.onSurfaceVariant)
            : Image.network(
                imageUrl!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.catching_pokemon,
                    color: colorScheme.onSurfaceVariant,
                  );
                },
              ),
      ),
    );
  }
}
