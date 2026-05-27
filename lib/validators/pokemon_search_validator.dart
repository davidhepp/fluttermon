String? validatePokemonSearchQuery(String value) {
  final query = value.trim();

  if (query.isEmpty) {
    return null;
  }

  final validCharacters = RegExp(r'^[a-zA-Z0-9 -]+$');
  if (!validCharacters.hasMatch(query)) {
    return 'Use letters, numbers, spaces, or hyphens';
  }

  final isNumericId = RegExp(r'^[0-9]+$').hasMatch(query);
  if (!isNumericId && query.length < 2) {
    return 'Enter at least 2 characters';
  }

  return null;
}
