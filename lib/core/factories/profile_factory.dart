import 'package:sobrius_app/models/profile_model.dart';
import 'package:sobrius_app/core/factories/model_factory.dart';

class ProfileFactory implements ModelFactory<ProfileModel> {
  @override
  ProfileModel createFromMap(String id, Map<String, dynamic> map) {
    try {
      return ProfileModel(
        id: id,
        userId: map['userId'] as String? ?? id,
        userName: map['userName'] as String? ?? 'Usuário',
        addiction: map['addiction'] as String? ?? '',
        sobrietyStartDate: map['sobrietyStartDate'] != null
            ? DateTime.parse(map['sobrietyStartDate'] as String)
            : DateTime.now(),
        personalReason: map['personalReason'] as String? ?? '',
        profileImageUrl: map['profileImageUrl'] as String?,
        bio: map['bio'] as String?,
      );
    } catch (e) {
      return createEmpty();
    }
  }
  
  @override
  ProfileModel createEmpty() {
    return ProfileModel(
      id: '',
      userId: '',
      userName: 'Novo Usuário',
      addiction: '',
      sobrietyStartDate: DateTime.now(),
      personalReason: '',
      profileImageUrl: null,
      bio: null,
    );
  }
  
  // Método adicional
  ProfileModel createWithDefaults(String userId, String userName) {
    return ProfileModel(
      id: userId,
      userId: userId,
      userName: userName,
      addiction: '',
      sobrietyStartDate: DateTime.now(),
      personalReason: '',
      profileImageUrl: null,
      bio: 'Olá! Estou começando minha jornada de recuperação.',
    );
  }
}
