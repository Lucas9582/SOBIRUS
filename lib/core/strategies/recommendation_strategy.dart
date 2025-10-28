class Recommendation {
  final String title;
  final String description;
  final String emoji;
  
  Recommendation({
    required this.title,
    required this.description,
    required this.emoji,
  });
}

abstract class RecommendationStrategy {
  List<Recommendation> generateRecommendations(int daysClean);
  String get addictionName;
}
