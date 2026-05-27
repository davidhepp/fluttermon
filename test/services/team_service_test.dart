import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttermon/models/pokemon.dart';
import 'package:fluttermon/services/team_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TeamService', () {
    test('uses six empty slots by default', () async {
      SharedPreferences.setMockInitialValues({});
      final service = TeamService();

      final team = await service.fetchTeam();

      expect(team, hasLength(TeamService.teamSize));
      expect(team.whereType<Pokemon>(), isEmpty);
    });

    test('saves and loads team slots', () async {
      SharedPreferences.setMockInitialValues({});
      final service = TeamService();
      const pokemon = Pokemon(
        name: 'bulbasaur',
        url: 'https://pokeapi.co/api/v2/pokemon/1/',
      );

      await service.saveTeam([pokemon, null, null, null, null, null]);
      final team = await service.fetchTeam();

      expect(team.first?.name, 'bulbasaur');
      expect(team, hasLength(TeamService.teamSize));
    });
  });
}
