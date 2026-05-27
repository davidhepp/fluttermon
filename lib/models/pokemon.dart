class Pokemon {
  const Pokemon({required this.name, required this.url});

  final String name;
  final String url;

  int? get id {
    final segments = Uri.parse(url).pathSegments;
    for (final segment in segments.reversed) {
      final parsedId = int.tryParse(segment);
      if (parsedId != null) {
        return parsedId;
      }
    }

    return null;
  }

  String? get imageUrl {
    final pokemonId = id;
    if (pokemonId == null) {
      return null;
    }

    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png';
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'].toString(), url: json['url'].toString());
  }

  factory Pokemon.fromDetailJson(Map<String, dynamic> json) {
    final id = json['id'].toString();

    return Pokemon(
      name: json['name'].toString(),
      url: 'https://pokeapi.co/api/v2/pokemon/$id/',
    );
  }
}
