
//전략 자동 등록
import 'recommendation_strategy.dart';
import '../models/persona.dart';

class StrategyRegistry {
  static final List<RecommendationStrategy> _strategies = [];

  static void register(RecommendationStrategy strategy) {
    _strategies.add(strategy);
  }

  static List<RecommendationStrategy> getFor(Persona persona) {
    return _strategies.where((s) => s.supports(persona)).toList();
  }

  static List<RecommendationStrategy> get all => _strategies;
}