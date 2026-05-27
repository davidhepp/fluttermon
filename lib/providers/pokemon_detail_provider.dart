import 'package:flutter/foundation.dart';

import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';
import '../services/pokemon_service.dart';

class PokemonDetailProvider extends ChangeNotifier {
  PokemonDetailProvider(this._pokemonService);

  final PokemonService _pokemonService;

  PokemonDetail? detail;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchPokemonDetail(Pokemon pokemon) async {
    isLoading = true;
    errorMessage = null;
    detail = null;
    notifyListeners();

    try {
      detail = await _pokemonService.fetchPokemonDetail(pokemon);
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
