import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sobrius_app/models/relapse_model.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class RelapseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _relapsesCollection = 'relapses';

  // Salva uma nova recaída. O método permanece assíncrono.
  Future<void> saveRelapse(RelapseModel relapse) async {
    try {
      await _firestore.collection(_relapsesCollection).doc(relapse.id).set(relapse.toFirestore());
    } catch (e, s) {
      logger.e('Erro ao salvar recaída', error: e, stackTrace: s);
      throw Exception('Falha ao salvar recaída.');
    }
  }

  // --- Método anterior (comentado para referência) ---
  // Future<List<RelapseModel>> fetchRelapses(String userId) async {
  //   try {
  //     final querySnapshot = await _firestore.collection(_relapsesCollection).where('userId', isEqualTo: userId).get();
  //     return querySnapshot.docs.map((doc) => RelapseModel.fromFirestore(doc)).toList();
  //   } catch (e, s) {
  //     logger.e('Erro ao buscar recaídas', error: e, stackTrace: s);
  //     throw Exception('Falha ao buscar recaídas.');
  //   }
  // }
  // --- Fim do método anterior ---

  // O novo método que retorna uma stream de recaídas.
  // Ele usa `.snapshots()` para obter atualizações em tempo real do Firestore.
  Stream<List<RelapseModel>> fetchRelapsesStream(String userId) {
    return _firestore
        .collection(_relapsesCollection)
        .where('userId', isEqualTo: userId)
        // O `snapshots()` retorna uma Stream de QuerySnapshot.
        .snapshots()
        // Mapeamos a stream para converter cada QuerySnapshot em uma lista de RelapseModel.
        .map((snapshot) {
      try {
        return snapshot.docs.map((doc) => RelapseModel.fromFirestore(doc)).toList();
      } catch (e, s) {
        logger.e('Erro ao processar stream de recaídas', error: e, stackTrace: s);
        // Em um ambiente de produção, você pode querer apenas retornar uma lista vazia ou lidar com o erro de outra forma
        return [];
      }
    });
  }
}
