// lib/features/relapse_repository.dart
import 'package:sobrius_app/models/relapse_model.dart';
import 'package:sobrius_app/services/relapse_service.dart';

class RelapseRepository {
  final RelapseService service;

  RelapseRepository({required this.service});

  // Método para salvar uma nova recaída
  Future<void> saveRelapse(RelapseModel relapse) async {
    await service.saveRelapse(relapse);
  }

  // A principal alteração: o método agora retorna uma Stream.
  // Isso permite que o aplicativo ouça as atualizações em tempo real.
  Stream<List<RelapseModel>> fetchRelapses(String userId) {
    return service.fetchRelapsesStream(userId);
  }
}