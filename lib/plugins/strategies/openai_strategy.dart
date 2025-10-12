//OpenAI전략

import '../recommendation_strategy.dart';
import '../../models/persona.dart';
import '../../models/recommendation.dart';
import '../../services/openai_service.dart';
import '../strategy_registry.dart';

class OpenAiStrategy implements RecommendationStrategy {
  final _service = OpenAiService();

  OpenAiStrategy() {
    StrategyRegistry.register(this); // ✅ 자동 등록
  }

  @override
  String get id => "openai";

  @override
  bool supports(Persona persona) {
    return persona.description.length > 10;
  }

  @override
  Future<List<Recommendation>> recommend(Persona persona) async {
    return await _service.fetchRecommendations(persona);
  }
}