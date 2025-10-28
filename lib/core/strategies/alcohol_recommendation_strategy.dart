import 'package:sobrius_app/core/strategies/recommendation_strategy.dart';

class AlcoholRecommendationStrategy implements RecommendationStrategy {
  @override
  String get addictionName => 'Álcool';
  
  @override
  List<Recommendation> generateRecommendations(int daysClean) {
    if (daysClean <= 7) {
      return [
        Recommendation(
          title: 'Mantenha-se hidratado',
          description: 'Beba pelo menos 2 litros de água por dia.',
          emoji: '💧',
        ),
        Recommendation(
          title: 'Evite gatilhos sociais',
          description: 'Fique longe de bares e festas.',
          emoji: '🚫',
        ),
        Recommendation(
          title: 'Contatos de emergência',
          description: 'Tenha números de apoio salvos.',
          emoji: '📞',
        ),
      ];
    } else if (daysClean <= 30) {
      return [
        Recommendation(
          title: 'Exercícios regulares',
          description: 'Pratique 30min de atividade 3-4x por semana.',
          emoji: '🏃',
        ),
        Recommendation(
          title: 'Diário de gratidão',
          description: 'Escreva 3 coisas pelas quais é grato todo dia.',
          emoji: '📝',
        ),
        Recommendation(
          title: 'Grupo de apoio',
          description: 'Participe de AA ou grupos online.',
          emoji: '👥',
        ),
      ];
    } else {
      return [
        Recommendation(
          title: 'Desenvolva hobbies',
          description: 'Preencha seu tempo livre com atividades saudáveis.',
          emoji: '🎨',
        ),
        Recommendation(
          title: 'Reconecte com família',
          description: 'Repare relacionamentos danificados.',
          emoji: '❤️',
        ),
        Recommendation(
          title: 'Celebre conquistas',
          description: 'Reconheça seu progresso!',
          emoji: '🎉',
        ),
      ];
    }
  }
}
