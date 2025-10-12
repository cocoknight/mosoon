//KaKao 전략

import 'package:flutter/material.dart';

import '../recommendation_strategy.dart';
import '../../models/persona.dart';
import '../../models/recommendation.dart';
import '../../services/kakao_service.dart';
import '../strategy_registry.dart';

class KakaoStrategy implements RecommendationStrategy {
  final _service = KakaoService();

  KakaoStrategy() {
    StrategyRegistry.register(this); // ✅ 자동 등록
  }

  @override
  String get id => "kakao";

  @override
  bool supports(Persona persona) {
    return persona.location.contains("경기") || persona.preferences["taste"]?.isNotEmpty == true;
  }

//TOAN : 10/09/2025. debugging 가능하도록 코드 수정
//   @override
//   Future<List<Recommendation>> recommend(Persona persona) async {
//     return await _service.fetchRecommendations(persona);
//   }
// }

@override
Future<List<Recommendation>> recommend(Persona persona) async {
  try {
    final results = await _service.fetchRecommendations(persona);
    debugPrint("KakaoStrategy returned ${results.length} items");
    return results;
  } catch (e) {
    debugPrint("KakaoStrategy error: $e");
    return [];
  }
 }
}
