import 'package:flutter/material.dart';

import '../models/pokemon.dart';

class PokemonDetailScreen extends StatelessWidget {
  const PokemonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pokemon = ModalRoute.of(context)?.settings.arguments as Pokemon?;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(pokemon?.name ?? 'Pokemon')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (pokemon?.imageUrl != null)
                Image.network(
                  pokemon!.imageUrl!,
                  width: 160,
                  height: 160,
                  fit: BoxFit.contain,
                ),
              const SizedBox(height: 16),
              Text(
                pokemon?.name ?? 'Pokemon details',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                pokemon?.id == null
                    ? 'PokeAPI details will be loaded here.'
                    : 'PokeAPI details for #${pokemon!.id} will be loaded here.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
