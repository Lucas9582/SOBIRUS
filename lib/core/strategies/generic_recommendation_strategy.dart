import 'package:sobrius_app/core/strategies/recommendation_strategy.dart';

class GenericRecommendationStrategy implements RecommendationStrategy {
  @override
  String get addictionName => 'Geral';
  
  @override
  List<Recommendation> generateRecommendations(int daysClean) {
    return [
      Recommendation(
        title: 'Mantenha-se ativo',
        description: 'Pratique atividades físicas regulares.',
        emoji: '🏃',
      ),
      Recommendation(
        title: 'Busque apoio',
        description: 'Converse com amigos, família ou grupos de apoio.',
        emoji: '👥',
      ),
      Recommendation(
        title: 'Estabeleça rotina',
        description: 'Crie hábitos saudáveis e consistentes.',
        emoji: '📅',
      ),
      Recommendation(
        title: 'Seja gentil consigo',
        description: 'Recuperação é uma jornada, não perfeição.',
        emoji: '💚',
      ),
    ];
  }
}
