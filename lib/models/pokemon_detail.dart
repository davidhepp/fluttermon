class PokemonDetail {
  const PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.stats,
    required this.description,
    required this.genus,
  });

  final int id;
  final String name;
  final String? imageUrl;
  final List<String> types;
  final List<PokemonStat> stats;
  final String description;
  final String? genus;

  factory PokemonDetail.fromApiJson({
    required Map<String, dynamic> pokemonJson,
    required Map<String, dynamic> speciesJson,
  }) {
    return PokemonDetail(
      id: pokemonJson['id'] as int,
      name: pokemonJson['name'].toString(),
      imageUrl:
          pokemonJson['sprites']?['other']?['official-artwork']?['front_default']
              as String?,
      types: (pokemonJson['types'] as List<dynamic>)
          .map((typeJson) => typeJson['type']['name'].toString())
          .toList(),
      stats: (pokemonJson['stats'] as List<dynamic>)
          .map((statJson) => PokemonStat.fromJson(statJson))
          .toList(),
      description: _englishFlavorText(speciesJson),
      genus: _englishGenus(speciesJson),
    );
  }

  static String _englishFlavorText(Map<String, dynamic> json) {
    final entries = json['flavor_text_entries'] as List<dynamic>;
    final englishEntry = entries.cast<Map<String, dynamic>>().firstWhere(
      (entry) => entry['language']['name'] == 'en',
      orElse: () => const {'flavor_text': 'No Pokédex description available.'},
    );

    return englishEntry['flavor_text']
        .toString()
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String? _englishGenus(Map<String, dynamic> json) {
    final entries = json['genera'] as List<dynamic>;
    for (final entry in entries.cast<Map<String, dynamic>>()) {
      if (entry['language']['name'] == 'en') {
        return entry['genus']?.toString();
      }
    }

    return null;
  }
}

class PokemonStat {
  const PokemonStat({required this.name, required this.baseStat});

  final String name;
  final int baseStat;

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      name: json['stat']['name'].toString(),
      baseStat: json['base_stat'] as int,
    );
  }
}
