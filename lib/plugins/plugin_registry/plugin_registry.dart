// plugins/plugin_registry/plugin_registry.dart

import 'package:mosoon/models/persona.dart';

import '../recommendation_plugin/recommendation_plugin.dart';
import '../food_recommendation/food_plugin.dart';
import '../shopping_recommendation/shopping_plugin.dart';
import '../transport_recommendation/transport_plugin.dart';
//import '../developer_recommendation/developer_plugin.dart';
//import '../traveler_recommendation/traveler_plugin.dart';

//TOAN : 09/07/2025. 우선 3개의 추천 플러그인으로 시작하자.
//추후에 Plug-In구조로 다시 추가하거나 삭제가 가능하다.
/*
final List<RecommendationPlugin> registeredPlugins = [
  FoodRecommendationPlugin(),
  ShoppingRecommendationPlugin(),
  TransportRecommendationPlugin(),
  //DeveloperRecommendationPlugin(),
  //TravelerRecommendationPlugin(),
];
*/

class PluginRegistry {
  static List<RecommendationPlugin> getPluginsForPersona(Persona persona) {
    return [
      FoodRecommendationPlugin(),
      //TransportRecommendationPlugin(),
      
      //ShoppingRecommendationPlugin(),
    ];
  }
}
