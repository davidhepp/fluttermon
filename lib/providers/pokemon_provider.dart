import 'package:flutter/foundation.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../validators/pokemon_search_validator.dart';

class PokemonProvider extends ChangeNotifier {
  PokemonProvider(this._pokemonService);

  static const int pageSize = 30;

  final PokemonService _pokemonService;

  List<Pokemon> _pokemonIndex = [];
  List<Pokemon> pokemons = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMorePokemons = true;
  String? errorMessage;
  String? loadMoreErrorMessage;
  String searchQuery = '';
  String? searchErrorMessage;

  bool get hasActiveSearch => searchQuery.isNotEmpty;

  List<Pokemon> get visiblePokemons {
    if (!hasActiveSearch) {
      return pokemons;
    }

    final normalizedQuery = _normalizeSearchText(searchQuery);
    return _pokemonIndex.where((pokemon) {
      return _matchesSearchQuery(pokemon, normalizedQuery);
    }).toList();
  }

  Future<void> fetchPokemons({bool refresh = false}) async {
    isLoading = true;
    errorMessage = null;
    loadMoreErrorMessage = null;
    hasMorePokemons = true;
    if (refresh) {
      pokemons = [];
    }
    notifyListeners();

    try {
      final page = await _pokemonService.loadPokemonIndex();
      _pokemonIndex = page.pokemons;
      pokemons = _pokemonIndex.take(pageSize).toList();
      hasMorePokemons = pokemons.length < _pokemonIndex.length;
    } on PokemonServiceException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (isLoading || isLoadingMore || !hasMorePokemons) {
      return;
    }

    isLoadingMore = true;
    loadMoreErrorMessage = null;
    notifyListeners();

    try {
      final nextPage = _pokemonIndex.skip(pokemons.length).take(pageSize);
      pokemons = [...pokemons, ...nextPage];
      hasMorePokemons = pokemons.length < _pokemonIndex.length;
    } catch (e) {
      loadMoreErrorMessage = 'Error: $e';
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  void updateSearchQuery(String value) {
    searchErrorMessage = validatePokemonSearchQuery(value);

    if (searchErrorMessage != null) {
      searchQuery = '';
      notifyListeners();
      return;
    }

    searchQuery = value.trim();
    notifyListeners();
  }

  void clearSearchQuery() {
    searchQuery = '';
    searchErrorMessage = null;
    notifyListeners();
  }

  bool _matchesSearchQuery(Pokemon pokemon, String normalizedQuery) {
    final normalizedName = _normalizeSearchText(pokemon.name);
    return normalizedName.contains(normalizedQuery) ||
        pokemon.id?.toString() == normalizedQuery;
  }

  String _normalizeSearchText(String value) {
    return value.toLowerCase().replaceAll('-', ' ');
  }
}
