import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermon/models/pokemon.dart';
import 'package:fluttermon/models/pokemon_detail.dart';
import 'package:fluttermon/providers/pokemon_detail_provider.dart';
import 'package:fluttermon/services/pokemon_service.dart';

void main() {
  group('PokemonDetailProvider', () {
    test('loads pokemon detail from the service', () async {
      final provider = PokemonDetailProvider(_FakePokemonService());

      await provider.fetchPokemonDetail(
        const Pokemon(
          name: 'bulbasaur',
          url: 'https://pokeapi.co/api/v2/pokemon/1/',
        ),
      );

      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
      expect(provider.detail?.name, 'bulbasaur');
      expect(provider.detail?.types, ['grass']);
    });
  });
}

class _FakePokemonService extends PokemonService {
  @override
  Future<PokemonDetail> fetchPokemonDetail(Pokemon pokemon) async {
    return const PokemonDetail(
      id: 1,
      name: 'bulbasaur',
      imageUrl: null,
      types: ['grass'],
      stats: [PokemonStat(name: 'hp', baseStat: 45)],
      description: 'A strange seed was planted on its back.',
      genus: 'Seed Pokemon',
    );
  }
}
