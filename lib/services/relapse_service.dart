import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sobrius_app/models/relapse_model.dart';
import 'package:sobrius_app/core/database/firebase_connection.dart'; // ADICIONAR
import 'package:logger/logger.dart';

final logger = Logger();

class RelapseService {
  // Usar Singleton
  final FirebaseFirestore _firestore = FirebaseConnection.getInstance().firestore;
  final String _collection = 'relapses';

  Future<void> saveRelapse(RelapseModel relapse) async {
    try {
      await _firestore.collection(_collection).doc(relapse.id).set(relapse.toMap());
    } catch (e, s) {
      logger.e('Erro ao salvar recaída.', error: e, stackTrace: s);
      throw Exception('Falha ao salvar recaída.');
    }
  }

  Future<List<RelapseModel>> fetchRelapses(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => RelapseModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e, s) {
      logger.e('Erro ao buscar recaídas.', error: e, stackTrace: s);
      throw Exception('Falha ao buscar recaídas.');
    }
  }

  Future<void> deleteRelapse(String relapseId) async {
    try {
      await _firestore.collection(_collection).doc(relapseId).delete();
    } catch (e, s) {
      logger.e('Erro ao deletar recaída.', error: e, stackTrace: s);
      throw Exception('Falha ao deletar recaída.');
    }
  }
}
