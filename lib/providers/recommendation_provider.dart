import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:mosoon/plugins/plugin_registry.dart';
import 'package:mosoon/plugins/plugin_registry/plugin_registry.dart';
import '../models/persona.dart';
import '../models/recommendation.dart';
//import '../plugins/recommendation_plugin/recommendation_plugin.dart';

final recommendationProvider = FutureProvider.family<List<Recommendation>, Persona>((ref, persona) async {
  final plugins = PluginRegistry.getPluginsForPersona(persona);
  List<Recommendation> all = [];

  for (final plugin in plugins) {
    final recs = await plugin.fetchRecommendations(persona); // ✅ 수정된 부분
    //final recs = await plugin.
    all.addAll(recs);
  }

  return all;
});