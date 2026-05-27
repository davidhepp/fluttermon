import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermon/models/pokemon_detail.dart';

void main() {
  group('PokemonDetail', () {
    test('parses API detail and species json', () {
      final detail = PokemonDetail.fromApiJson(
        pokemonJson: {
          'id': 1,
          'name': 'bulbasaur',
          'sprites': {
            'other': {
              'official-artwork': {
                'front_default': 'https://example.com/1.png',
              },
            },
          },
          'types': [
            {
              'type': {'name': 'grass'},
            },
            {
              'type': {'name': 'poison'},
            },
          ],
          'stats': [
            {
              'base_stat': 45,
              'stat': {'name': 'hp'},
            },
          ],
        },
        speciesJson: {
          'flavor_text_entries': [
            {
              'flavor_text': 'A strange seed was\nplanted on its back.',
              'language': {'name': 'en'},
            },
          ],
          'genera': [
            {
              'genus': 'Seed Pokemon',
              'language': {'name': 'en'},
            },
          ],
        },
      );

      expect(detail.id, 1);
      expect(detail.name, 'bulbasaur');
      expect(detail.imageUrl, 'https://example.com/1.png');
      expect(detail.types, ['grass', 'poison']);
      expect(detail.stats.single.name, 'hp');
      expect(detail.stats.single.baseStat, 45);
      expect(detail.description, 'A strange seed was planted on its back.');
      expect(detail.genus, 'Seed Pokemon');
    });
  });
}
