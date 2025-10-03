// plugins/recommendation_plugin/recommendation_plugin.dart

import '../../models/persona.dart';
import '../../models/recommendation.dart';

abstract class RecommendationPlugin {
  Future<List<Recommendation>> fetchRecommendations(Persona persona);
}