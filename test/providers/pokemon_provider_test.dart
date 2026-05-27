import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermon/models/pokemon.dart';
import 'package:fluttermon/models/pokemon_page.dart';
import 'package:fluttermon/providers/pokemon_provider.dart';
import 'package:fluttermon/services/pokemon_service.dart';

void main() {
  group('PokemonProvider', () {
    test('loads pokemons in pages', () async {
      final provider = PokemonProvider(
        _FakePokemonService([
          const PokemonPage(
            pokemons: [
              Pokemon(
                name: 'bulbasaur',
                url: 'https://pokeapi.co/api/v2/pokemon/1/',
              ),
            ],
            hasNextPage: true,
          ),
          const PokemonPage(
            pokemons: [
              Pokemon(
                name: 'ivysaur',
                url: 'https://pokeapi.co/api/v2/pokemon/2/',
              ),
            ],
            hasNextPage: false,
          ),
        ]),
      );

      await provider.fetchPokemons();

      expect(provider.pokemons.map((pokemon) => pokemon.name), ['bulbasaur']);
      expect(provider.isLoading, isFalse);
      expect(provider.hasMorePokemons, isTrue);

      await provider.loadNextPage();

      expect(provider.pokemons.map((pokemon) => pokemon.name), [
        'bulbasaur',
        'ivysaur',
      ]);
      expect(provider.isLoadingMore, isFalse);
      expect(provider.hasMorePokemons, isFalse);
      expect(provider.loadMoreErrorMessage, isNull);
    });
  });
}

class _FakePokemonService extends PokemonService {
  _FakePokemonService(this._pages);

  final List<PokemonPage> _pages;
  int _requestCount = 0;

  @override
  Future<PokemonPage> fetchPokemons({
    required int limit,
    required int offset,
  }) async {
    return _pages[_requestCount++];
  }
}
