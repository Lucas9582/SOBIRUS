// lib/models/profile.dart
class Profile {
  final String id;
  final String username;
  final String? bio;
  final String? avatarUrl;
  final List<String>? vices;
  final String? personalReason;
  final DateTime createdAt;

  Profile({
    required this.id,
    required this.username,
    this.bio,
    this.avatarUrl,
    this.vices,
    this.personalReason,
    required this.createdAt,
  });

  // Factory constructor para criar um Profile a partir de um mapa (do Supabase)
  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      username: map['username'],
      bio: map['bio'],
      avatarUrl: map['avatar_url'],
      vices: (map['vices'] as List?)?.map((e) => e.toString()).toList(),
      personalReason: map['personal_reason'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Método para converter um Profile em um mapa (para o Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'bio': bio,
      'avatar_url': avatarUrl,
      'vices': vices,
      'personal_reason': personalReason,
      'created_at': createdAt.toIso8601String(),
    };
  }
}