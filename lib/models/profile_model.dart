// lib/features/profile/data/models/profile_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// O modelo de dados para o perfil do utilizador.
// Esta classe representa como os dados serão guardados no Firestore.
class ProfileModel {
  final String id;
  final String username;
  final String? bio;
  final String? personalReason;
  final List<String> vices;
  final DateTime? sobrietyStartDate;
  final String? avatarUrl;

  ProfileModel({
    required this.id,
    required this.username,
    this.bio,
    this.personalReason,
    this.vices = const [],
    this.sobrietyStartDate,
    this.avatarUrl,
  });

  // Construtor de fábrica para criar um objeto ProfileModel a partir de um mapa
  factory ProfileModel.fromMap(String id, Map<String, dynamic> map) {
    return ProfileModel(
      id: id,
      username: map['username'] as String,
      bio: map['bio'] as String?,
      personalReason: map['personalReason'] as String?,
      vices: List<String>.from(map['vices'] as List),
      // Converte o Timestamp do Firestore para um objeto DateTime
      sobrietyStartDate: (map['sobrietyStartDate'] as Timestamp?)?.toDate(),
      avatarUrl: map['avatarUrl'] as String?,
    );
  }

  // Converte o objeto ProfileModel num mapa para o Firestore
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'bio': bio,
      'personalReason': personalReason,
      'vices': vices,
      // Converte o DateTime para um Timestamp do Firestore
      'sobrietyStartDate': sobrietyStartDate != null ? Timestamp.fromDate(sobrietyStartDate!) : null,
      'avatarUrl': avatarUrl,
    };
  }
}
