
//전략 인터페이스
import '../models/persona.dart';
import '../models/recommendation.dart';

abstract class RecommendationStrategy {
  String get id;
  bool supports(Persona persona);
  Future<List<Recommendation>> recommend(Persona persona);
}