import 'package:flutter/foundation.dart';

import '../models/pokemon.dart';
import '../services/collection_service.dart';

class CollectionProvider extends ChangeNotifier {
  CollectionProvider(this._collectionService);

  final CollectionService _collectionService;

  List<Pokemon> pokemons = [];
  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;
  String? saveErrorMessage;

  Future<void> fetchCollection() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      pokemons = await _collectionService.fetchCollection();
    } catch (e) {
      errorMessage = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPokemon(Pokemon pokemon) async {
    isSaving = true;
    saveErrorMessage = null;
    notifyListeners();

    try {
      pokemons = await _collectionService.addPokemon(pokemon);
    } catch (e) {
      saveErrorMessage = 'Error: $e';
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> removePokemon(Pokemon pokemon) async {
    isSaving = true;
    saveErrorMessage = null;
    notifyListeners();

    try {
      pokemons = await _collectionService.removePokemon(pokemon);
    } catch (e) {
      saveErrorMessage = 'Error: $e';
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  bool isCollected(Pokemon pokemon) {
    final pokemonId = pokemon.id;
    if (pokemonId == null) {
      return false;
    }

    return pokemons.any((collectedPokemon) => collectedPokemon.id == pokemonId);
  }
}
