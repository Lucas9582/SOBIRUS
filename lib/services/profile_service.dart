import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:sobrius_app/models/profile_model.dart';
import 'package:sobrius_app/core/database/firebase_connection.dart'; // ADICIONAR
import 'package:logger/logger.dart';

final logger = Logger();

class ProfileService {
  // ANTES: final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // DEPOIS: Usar Singleton
  final FirebaseFirestore _firestore = FirebaseConnection.getInstance().firestore;
  final FirebaseStorage _storage = FirebaseConnection.getInstance().storage;

  final _profilesCollection = 'profiles';

  Future<ProfileModel?> fetchProfile(String userId) async {
    try {
      final docSnapshot = await _firestore.collection(_profilesCollection).doc(userId).get();
      if (docSnapshot.exists) {
        return ProfileModel.fromMap(docSnapshot.id, docSnapshot.data()!);
      }
      return null;
    } catch (e, s) {
      logger.e('Erro ao buscar perfil.', error: e, stackTrace: s);
      throw Exception('Falha ao buscar perfil.');
    }
  }

  Future<void> saveProfile(ProfileModel profile) async {
    try {
      await _firestore.collection(_profilesCollection).doc(profile.id).set(profile.toMap(), SetOptions(merge: true));
    } catch (e, s) {
      logger.e('Erro ao salvar perfil.', error: e, stackTrace: s);
      throw Exception('Falha ao salvar perfil.');
    }
  }

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
