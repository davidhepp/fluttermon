import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermon/models/pokemon.dart';
import 'package:fluttermon/providers/team_provider.dart';
import 'package:fluttermon/services/team_service.dart';

void main() {
  group('TeamProvider', () {
    test('sets and clears a pokemon team slot', () async {
      final provider = TeamProvider(_FakeTeamService());
      const pokemon = Pokemon(
        name: 'bulbasaur',
        url: 'https://pokeapi.co/api/v2/pokemon/1/',
      );

      await provider.fetchTeam();
      await provider.setPokemonAtSlot(0, pokemon);

      expect(provider.team.first?.name, 'bulbasaur');
      expect(provider.isSaving, isFalse);
      expect(provider.saveErrorMessage, isNull);

      await provider.clearSlot(0);

      expect(provider.team.first, isNull);
    });

    test('moves duplicate pokemon to the newest slot', () async {
      final provider = TeamProvider(_FakeTeamService());
      const pokemon = Pokemon(
        name: 'bulbasaur',
        url: 'https://pokeapi.co/api/v2/pokemon/1/',
      );

      await provider.fetchTeam();
      await provider.setPokemonAtSlot(0, pokemon);
      await provider.setPokemonAtSlot(2, pokemon);

      expect(provider.team[0], isNull);
      expect(provider.team[2]?.name, 'bulbasaur');
    });
  });
}

class _FakeTeamService extends TeamService {
  List<Pokemon?> _team = List<Pokemon?>.filled(TeamService.teamSize, null);

  @override
  Future<List<Pokemon?>> fetchTeam() async {
    return _team;
  }

  @override
  Future<List<Pokemon?>> saveTeam(List<Pokemon?> team) async {
    _team = team;
    return _team;
  }
}
