import 'package:sobrius_app/models/relapse_model.dart';
import 'package:sobrius_app/core/factories/model_factory.dart';
import 'package:uuid/uuid.dart';

class RelapseFactory implements ModelFactory<RelapseModel> {
  final Uuid _uuid = const Uuid();
  
  @override
  RelapseModel createFromMap(String id, Map<String, dynamic> map) {
    return RelapseModel(
      id: id,
      userId: map['userId'] as String,
      date: DateTime.parse(map['date'] as String),
      notes: map['notes'] as String?,
      triggers: map['triggers'] != null 
          ? List<String>.from(map['triggers'] as List)
          : null,
    );
  }
  
  @override
  RelapseModel createEmpty() {
    return RelapseModel(
      id: _uuid.v4(),
      userId: '',
      date: DateTime.now(),
      notes: null,
      triggers: null,
    );
  }
  
  // Método adicional para criar com userId
  RelapseModel createForUser(String userId, {String? notes}) {
    return RelapseModel(
      id: _uuid.v4(),
      userId: userId,
      date: DateTime.now(),
      notes: notes,
      triggers: null,
    );
  }
}
