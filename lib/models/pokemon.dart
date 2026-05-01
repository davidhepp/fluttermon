class Pokemon {
  const Pokemon({required this.name});

  final String name;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'].toString());
  }
}
