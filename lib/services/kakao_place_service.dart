import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';
import '../models/recommendation.dart';

Future<Recommendation?> fetchKakaoPlace(String keyword, double userLat, double userLng) async {
  final encoded = Uri.encodeComponent(keyword);
  final url = Uri.parse(
    "https://dapi.kakao.com/v2/local/search/keyword.json?query=$encoded&x=$userLng&y=$userLat",
  );

  final response = await http.get(url, headers: {
    "Authorization": "KakaoAK ${ApiKeys.kakaoRestApiKey}",
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final documents = data['documents'];
    if (documents.isNotEmpty) {
      return Recommendation.fromKakao(documents[0]);
    }
  }
  return null;
}