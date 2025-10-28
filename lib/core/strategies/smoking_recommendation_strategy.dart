import 'package:sobrius_app/core/strategies/recommendation_strategy.dart';

class SmokingRecommendationStrategy implements RecommendationStrategy {
  @override
  String get addictionName => 'Cigarro';
  
  @override
  List<Recommendation> generateRecommendations(int daysClean) {
    if (daysClean <= 7) {
      return [
        Recommendation(
          title: 'Use adesivos de nicotina',
          description: 'Se prescrito, use conforme orientação médica.',
          emoji: '💊',
        ),
        Recommendation(
          title: 'Remova todos os cigarros',
          description: 'Jogue fora cigarros, isqueiros e cinzeiros.',
          emoji: '🚮',
        ),
        Recommendation(
          title: 'Beba muita água',
          description: 'Ajuda a eliminar nicotina e mantém boca ocupada.',
          emoji: '💧',
        ),
      ];
    } else if (daysClean <= 30) {
      return [
        Recommendation(
          title: 'Mude sua rotina',
          description: 'Evite situações que associava ao cigarro.',
          emoji: '🔄',
        ),
        Recommendation(
          title: 'Escove dentes frequentemente',
          description: 'Mantém gosto fresco e reduz vontade.',
          emoji: '🪥',
        ),
      ];
    } else {
      return [
        Recommendation(
          title: 'Calcule economia',
          description: 'Some quanto economizou e use para algo especial!',
          emoji: '💰',
        ),
        Recommendation(
          title: 'Respire profundamente',
          description: 'Aprecie sua capacidade pulmonar melhorada!',
          emoji: '🫁',
        ),
      ];
    }
  }
}
