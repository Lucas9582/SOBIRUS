// lib/features/profile/data/services/profile_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:sobrius_app/models/profile_model.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final _profilesCollection = 'profiles';

  /// Busca um perfil de usuário no Firestore.
  /// Retorna um [ProfileModel] se o perfil for encontrado, ou null se não.
  Future<ProfileModel?> fetchProfile(String userId) async {
    try {
      final docSnapshot = await _firestore.collection(_profilesCollection).doc(userId).get();
      if (docSnapshot.exists) {
        // CORREÇÃO: Usando o método fromMap do ProfileModel
        return ProfileModel.fromMap(docSnapshot.id, docSnapshot.data()!);
      }
      return null;
    } catch (e, s) {
      // Em um aplicativo real, você logaria esse erro para depuração
      logger.e('Erro ao buscar perfil.', error: e, stackTrace: s);
      throw Exception('Falha ao buscar perfil.');
    }
  }

  /// Salva ou atualiza um perfil de usuário no Firestore.
  /// Usa `SetOptions(merge: true)` para evitar a substituição completa do documento.
  Future<void> saveProfile(ProfileModel profile) async {
    try {
      // CORREÇÃO: Usando o método toMap do ProfileModel
      await _firestore.collection(_profilesCollection).doc(profile.id).set(profile.toMap(), SetOptions(merge: true));
    } catch (e, s) {
      logger.e('Erro ao salvar perfil.', error: e, stackTrace: s);
      throw Exception('Falha ao salvar perfil.');
    }
  }

  /// Faz o upload da imagem do perfil para o Firebase Storage.
  /// Retorna a URL de download da imagem.
  Future<String> uploadProfileImage(String userId, File imageFile) async {
    try {
      final storageRef = _storage.ref().child('user_avatars/$userId.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e, s) {
      logger.e('Erro ao fazer upload da imagem.', error: e, stackTrace: s);
      throw Exception('Falha ao fazer upload da imagem.');
    }
  }

  /// Atualiza apenas a data de sobriedade de um perfil de usuário no Firestore.
  Future<void> updateSobrietyStartDate(String userId, DateTime newDate) async {
    try {
      await _firestore.collection(_profilesCollection).doc(userId).update({
        'sobrietyStartDate': newDate,
      });
    } catch (e, s) {
      logger.e('Erro ao atualizar a data de sobriedade.', error: e, stackTrace: s);
      throw Exception('Falha ao atualizar a data de sobriedade.');
    }
  }
}
