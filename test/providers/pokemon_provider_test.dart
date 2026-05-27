import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermon/models/pokemon.dart';
import 'package:fluttermon/models/pokemon_page.dart';
import 'package:fluttermon/providers/pokemon_provider.dart';
import 'package:fluttermon/services/pokemon_service.dart';

void main() {
  group('PokemonProvider', () {
    test('loads pokemons in pages', () async {
      final provider = PokemonProvider(
        _FakePokemonService(
          List.generate(31, (index) {
            final id = index + 1;
            return _pokemon(id, 'pokemon-$id');
          }),
        ),
      );

      await provider.fetchPokemons();

      expect(provider.pokemons.length, PokemonProvider.pageSize);
      expect(provider.isLoading, isFalse);
      expect(provider.hasMorePokemons, isTrue);

      await provider.loadNextPage();

      expect(provider.pokemons.length, 31);
      expect(provider.isLoadingMore, isFalse);
      expect(provider.hasMorePokemons, isFalse);
      expect(provider.loadMoreErrorMessage, isNull);
    });

    test('filters visible pokemons with a valid search query', () async {
      final provider = PokemonProvider(
        _FakePokemonService([
          _pokemon(1, 'bulbasaur'),
          _pokemon(4, 'charmander'),
        ]),
      );

      await provider.fetchPokemons();
      provider.updateSearchQuery('char');

      expect(provider.visiblePokemons.map((pokemon) => pokemon.name), [
        'charmander',
      ]);
      expect(provider.searchErrorMessage, isNull);
    });

    test('keeps the list unfiltered when search query is invalid', () async {
      final provider = PokemonProvider(
        _FakePokemonService([_pokemon(1, 'bulbasaur')]),
      );

      await provider.fetchPokemons();
      provider.updateSearchQuery('!');

      expect(provider.visiblePokemons.map((pokemon) => pokemon.name), [
        'bulbasaur',
      ]);
      expect(
        provider.searchErrorMessage,
        'Use letters, numbers, spaces, or hyphens',
      );
    });

    test('finds a pokemon outside the rendered page', () async {
      final provider = PokemonProvider(
        _FakePokemonService([
          ...List.generate(30, (index) {
            final id = index + 1;
            return _pokemon(id, 'pokemon-$id');
          }),
          _pokemon(1000, 'gholdengo'),
        ]),
      );

      await provider.fetchPokemons();
      provider.updateSearchQuery('ghol');

      expect(provider.visiblePokemons.map((pokemon) => pokemon.name), [
        'gholdengo',
      ]);
      expect(provider.searchErrorMessage, isNull);
    });
  });
}

class _FakePokemonService extends PokemonService {
  _FakePokemonService(this._pokemons);

  final List<Pokemon> _pokemons;

  @override
  Future<PokemonPage> loadPokemonIndex() async {
    return PokemonPage(pokemons: _pokemons, hasNextPage: false);
  }
}

Pokemon _pokemon(int id, String name) {
  return Pokemon(name: name, url: 'https://pokeapi.co/api/v2/pokemon/$id/');
}
