import 'package:sobrius_app/core/strategies/recommendation_strategy.dart';
import 'package:sobrius_app/strategies/alcohol_recommendation_strategy.dart';
import 'package:sobrius_app/strategies/smoking_recommendation_strategy.dart';
import 'package:sobrius_app/strategies/generic_recommendation_strategy.dart';

class RecommendationService {
  RecommendationStrategy? _strategy;
  
  void setStrategy(String addiction) {
    final addictionLower = addiction.toLowerCase().trim();
    
    if (addictionLower.contains('álcool') || 
        addictionLower.contains('alcool') ||
        addictionLower.contains('bebida')) {
      _strategy = AlcoholRecommendationStrategy();
    } else if (addictionLower.contains('cigarro') || 
               addictionLower.contains('fumo') ||
               addictionLower.contains('tabaco')) {
      _strategy = SmokingRecommendationStrategy();
    } else {
      _strategy = GenericRecommendationStrategy();
    }
  }
  
  List<Recommendation> getRecommendations(int daysClean) {
    if (_strategy == null) {
      _strategy = GenericRecommendationStrategy();
    }
    return _strategy!.generateRecommendations(daysClean);
  }
  
  String? get currentAddiction => _strategy?.addictionName;
}
