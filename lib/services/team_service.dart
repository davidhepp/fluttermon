import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/pokemon.dart';

class TeamService {
  static const int teamSize = 6;
  static const String _teamKey = 'pokemon_team';

  Future<List<Pokemon?>> fetchTeam() async {
    final preferences = await SharedPreferences.getInstance();
    final teamJson = preferences.getString(_teamKey);

    if (teamJson == null) {
      return List<Pokemon?>.filled(teamSize, null);
    }

    final decoded = json.decode(teamJson) as List<dynamic>;
    final team = decoded.map((pokemonJson) {
      if (pokemonJson == null) {
        return null;
      }

      return Pokemon.fromJson(pokemonJson as Map<String, dynamic>);
    }).toList();

    if (team.length >= teamSize) {
      return team.take(teamSize).toList();
    }

    return [...team, ...List<Pokemon?>.filled(teamSize - team.length, null)];
  }

  Future<List<Pokemon?>> saveTeam(List<Pokemon?> team) async {
    final normalizedTeam = team.take(teamSize).toList();
    if (normalizedTeam.length < teamSize) {
      normalizedTeam.addAll(
        List<Pokemon?>.filled(teamSize - normalizedTeam.length, null),
      );
    }

    final preferences = await SharedPreferences.getInstance();
    final encodedTeam = json.encode(
      normalizedTeam.map((pokemon) => pokemon?.toJson()).toList(),
    );

    await preferences.setString(_teamKey, encodedTeam);

    return normalizedTeam;
  }
}
