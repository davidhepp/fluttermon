import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_list.dart';
import '../widgets/app_bar.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    setState(() {});
  }

  double _scrollbarTopPadding(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final minHeight = kToolbarHeight + topPadding;
    final maxHeight = CustomSliverAppBar.expandedHeight + topPadding;
    final scrollOffset = _scrollController.hasClients
        ? _scrollController.offset
        : 0;

    return (maxHeight - scrollOffset).clamp(minHeight, maxHeight);
  }

  @override
  Widget build(BuildContext context) {
    final pokemonProvider = context.watch<PokemonProvider>();

    return Scaffold(
      body: RawScrollbar(
        controller: _scrollController,
        padding: EdgeInsets.only(top: _scrollbarTopPadding(context)),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const CustomSliverAppBar(
              title: 'Pokémon',
              imagePath: 'assets/images/appbar/appbar1.png',
            ),
            if (pokemonProvider.isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (pokemonProvider.errorMessage != null)
              SliverFillRemaining(
                child: Center(
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
                ),
              )
            else if (pokemonProvider.pokemons.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text('No pokemons found')),
              )
            else
              PokemonList(pokemons: pokemonProvider.pokemons),
          ],
        ),
      ),
    );
  }
}
