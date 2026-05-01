import 'package:flutter/foundation.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonProvider extends ChangeNotifier {
  PokemonProvider(this._pokemonService);

  final PokemonService _pokemonService;

  List<Pokemon> pokemons = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> fetchPokemons() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      pokemons = await _pokemonService.fetchPokemons();
    } on PokemonServiceException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
