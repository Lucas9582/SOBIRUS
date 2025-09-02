import 'dart:io';
import 'package:sobrius_app/models/profile_model.dart';
import 'package:sobrius_app/services/profile_service.dart';

// Repositório que lida com a lógica de dados para perfis de utilizador.
// Abstrai a fonte de dados (Firestore) do resto da aplicação.
class ProfileRepository {
  final ProfileService service;

  // Construtor agora aceita um parâmetro nomeado.
  ProfileRepository({required this.service});

  // Obtém os dados do perfil do utilizador do Firestore.
  Future<ProfileModel?> fetchProfile({required String userId}) async {
    try {
      return await service.fetchProfile(userId);
    } catch (e) {
      // Em caso de erro, lança uma exceção para o ViewModel lidar com ela
      throw Exception('Erro ao buscar perfil: $e');
    }
  }

  // Guarda ou atualiza um perfil no Firestore.
  Future<void> saveProfile(ProfileModel profile) async {
    try {
      await service.saveProfile(profile);
    } catch (e) {
      throw Exception('Erro ao guardar perfil: $e');
    }
  }

  // Faz upload de uma imagem do perfil para o Firebase Storage.
  Future<String?> uploadProfileImage(String userId, File imageFile) async {
    try {
      return await service.uploadProfileImage(userId, imageFile);
    } catch (e) {
      throw Exception('Erro ao fazer upload da imagem: $e');
    }
  }

  // Novo método para atualizar a data de sobriedade no perfil do usuário.
  // A assinatura do método foi atualizada para usar parâmetros nomeados.
  Future<void> updateSobrietyStartDate({required String userId, required DateTime newDate}) async {
    try {
      await service.updateSobrietyStartDate(userId, newDate);
    } catch (e) {
      throw Exception('Erro ao atualizar a data de sobriedade: $e');
    }
  }
}
