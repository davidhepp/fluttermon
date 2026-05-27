String? validateTrainerName(String value) {
  final name = value.trim();

  if (name.isEmpty) {
    return 'Enter a trainer name';
  }

  if (name.length < 2) {
    return 'Name must be at least 2 characters';
  }

  if (name.length > 24) {
    return 'Name must be 24 characters or fewer';
  }

  return null;
}
