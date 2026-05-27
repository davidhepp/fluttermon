class UserProfile {
  const UserProfile({required this.name, required this.subtitle});

  final String name;
  final String subtitle;

  UserProfile copyWith({String? name, String? subtitle}) {
    return UserProfile(
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'subtitle': subtitle};
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name']?.toString() ?? 'Trainer',
      subtitle: json['subtitle']?.toString() ?? 'Ready to catch them all',
    );
  }
}
