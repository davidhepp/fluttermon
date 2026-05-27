import 'package:flutter/foundation.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonProvider extends ChangeNotifier {
  PokemonProvider(this._pokemonService);

  static const int pageSize = 30;

  final PokemonService _pokemonService;

  List<Pokemon> pokemons = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMorePokemons = true;
  String? errorMessage;
  String? loadMoreErrorMessage;

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
      final page = await _pokemonService.fetchPokemons(
        limit: pageSize,
        offset: 0,
      );
      pokemons = page.pokemons;
      hasMorePokemons = page.hasNextPage;
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
      final page = await _pokemonService.fetchPokemons(
        limit: pageSize,
        offset: pokemons.length,
      );
      pokemons = [...pokemons, ...page.pokemons];
      hasMorePokemons = page.hasNextPage;
    } on PokemonServiceException catch (e) {
      loadMoreErrorMessage = e.message;
    } catch (e) {
      loadMoreErrorMessage = 'Error: $e';
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
}
