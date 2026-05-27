import 'package:flutter/foundation.dart';

import '../models/pokemon.dart';
import '../services/team_service.dart';

class TeamProvider extends ChangeNotifier {
  TeamProvider(this._teamService);

  final TeamService _teamService;

  List<Pokemon?> team = List<Pokemon?>.filled(TeamService.teamSize, null);
  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;
  String? saveErrorMessage;

  Future<void> fetchTeam() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      team = await _teamService.fetchTeam();
    } catch (e) {
      errorMessage = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setPokemonAtSlot(int slotIndex, Pokemon pokemon) async {
    if (slotIndex < 0 || slotIndex >= TeamService.teamSize) {
      return;
    }

    isSaving = true;
    saveErrorMessage = null;
    notifyListeners();

    try {
      final updatedTeam = [...team];
      for (var index = 0; index < updatedTeam.length; index++) {
        if (updatedTeam[index]?.id == pokemon.id) {
          updatedTeam[index] = null;
        }
      }
      updatedTeam[slotIndex] = pokemon;
      team = await _teamService.saveTeam(updatedTeam);
    } catch (e) {
      saveErrorMessage = 'Error: $e';
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> clearSlot(int slotIndex) async {
    if (slotIndex < 0 || slotIndex >= TeamService.teamSize) {
      return;
    }

    isSaving = true;
    saveErrorMessage = null;
    notifyListeners();

    try {
      final updatedTeam = [...team];
      updatedTeam[slotIndex] = null;
      team = await _teamService.saveTeam(updatedTeam);
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
      final updatedTeam = team.map((teamPokemon) {
        return teamPokemon?.id == pokemon.id ? null : teamPokemon;
      }).toList();
      team = await _teamService.saveTeam(updatedTeam);
    } catch (e) {
      saveErrorMessage = 'Error: $e';
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
