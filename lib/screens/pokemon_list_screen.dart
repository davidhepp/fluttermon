import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../models/pokemon.dart';
import '../providers/collection_provider.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/pokemon_list.dart';
import '../widgets/pokemon_search_bar.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

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
    _searchController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final pokemonProvider = context.read<PokemonProvider>();
    if (_shouldLoadNextPage()) {
      pokemonProvider.loadNextPage();
    }

    setState(() {});
  }

  bool _shouldLoadNextPage() {
    if (!_scrollController.hasClients) {
      return false;
    }

    const nextPageScrollThreshold = 320.0;
    final position = _scrollController.position;

    // Start the next "API" request before the user reaches the end so the next
    // page is usually ready by the time the bottom cards come into view.
    return position.extentAfter < nextPageScrollThreshold;
  }

  double _scrollbarTopPadding(BuildContext context) {
    // calculate using the media query padding and the app bar height so the scrollbar is aligned with the app bar
    final topPadding = MediaQuery.paddingOf(context).top;
    final minHeight = kToolbarHeight + topPadding;
    final maxHeight = CustomSliverAppBar.expandedHeight + topPadding;
    final scrollOffset = _scrollController.hasClients
        ? _scrollController.offset
        : 0;

    return (maxHeight - scrollOffset).clamp(minHeight, maxHeight);
  }

  void _openPokemonDetail(Pokemon pokemon) {
    Navigator.pushNamed(context, AppRoutes.pokemonDetail, arguments: pokemon);
  }

  @override
  Widget build(BuildContext context) {
    final pokemonProvider = context.watch<PokemonProvider>();
    final collectionProvider = context.watch<CollectionProvider>();
    final visiblePokemons = pokemonProvider.visiblePokemons;

    return Scaffold(
      body: RawScrollbar(
        controller: _scrollController,
        padding: EdgeInsets.only(top: _scrollbarTopPadding(context)),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const CustomSliverAppBar(
              title: 'Pokédex',
              imagePath: 'assets/images/appbar/appbar2.png',
            ),
            PokemonSearchBar(
              controller: _searchController,
              errorText: pokemonProvider.searchErrorMessage,
              onChanged: pokemonProvider.updateSearchQuery,
              onClear: () {
                _searchController.clear();
                pokemonProvider.clearSearchQuery();
              },
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
                        onPressed: () {
                          pokemonProvider.fetchPokemons(refresh: true);
                        },
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
            else if (visiblePokemons.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptySearchState(
                  hasMorePokemons: pokemonProvider.hasMorePokemons,
                  isLoadingMore: pokemonProvider.isLoadingMore,
                  onLoadMore: pokemonProvider.loadNextPage,
                ),
              )
            else
              PokemonList(
                pokemons: visiblePokemons,
                isLoadingMore: pokemonProvider.isLoadingMore,
                loadMoreErrorMessage: pokemonProvider.loadMoreErrorMessage,
                hasMorePokemons:
                    !pokemonProvider.hasActiveSearch &&
                    pokemonProvider.hasMorePokemons,
                showEndMessage: !pokemonProvider.hasActiveSearch,
                onRetryLoadMore: pokemonProvider.loadNextPage,
                onPokemonTap: _openPokemonDetail,
                isPokemonCollected: collectionProvider.isCollected,
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState({
    required this.hasMorePokemons,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  final bool hasMorePokemons;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No Pokemon match your search'),
            if (hasMorePokemons) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: onLoadMore,
                child: const Text('Load more Pokemon'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
