import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/persona.dart';
import '../models/recommendation.dart';
import '../config/api_keys.dart';

//TOAN : 10/09/2025. 아래 구조는 페르소나가 예를 들어, 쉼표로 구분된 복합 키워드를 추가했을때 처리하지 못한다.
//즉 복합 키워드 갯수만큼 kakao api를 호출하지 못한다.
// class KakaoService {
//   Future<List<Recommendation>> fetchRecommendations(Persona persona) async {
//     final keyword = persona.preferences["taste"] ?? "맛집";
//     final location = persona.location;

//     final response = await http.get(
//       Uri.parse("https://dapi.kakao.com/v2/local/search/keyword.json?query=$keyword"),
//       headers: {
//         "Authorization": "KakaoAK ${ApiKeys.kakaoRestApiKey}"
//       }
//     );

//     final json = jsonDecode(response.body);
//     final items = json["documents"] as List;

//     return items.map((item) => Recommendation.fromKakao(item)).toList();
//   }
// }

class KakaoService {
  static const int radius = 20000; // 20km

  Future<List<Recommendation>> fetchRecommendations(Persona persona) async {
    final location = persona.location;
    final coords = await _getCoordinates(location);
    if (coords == null) return [];

    final rawTaste = persona.preferences["taste"] ?? "";
    final rawShopping = persona.preferences["shopping"] ?? "";
    final keywords = [...rawTaste.split(","), ...rawShopping.split(",")]
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final Set<String> seenTitles = {};
    final List<Recommendation> allResults = [];

    for (final keyword in keywords) {
      final response = await http.get(
        Uri.parse(
          "https://dapi.kakao.com/v2/local/search/keyword.json"
          "?query=$keyword"
          "&x=${coords['x']}&y=${coords['y']}&radius=$radius"
        ),
        headers: {
          "Authorization": "KakaoAK ${ApiKeys.kakaoRestApiKey}"
        },
      );

      final json = jsonDecode(response.body);
      final items = json["documents"];

      if (items != null && items is List) {
        for (final item in items) {
          final rec = Recommendation.fromKakao(item);
          if (!seenTitles.contains(rec.title)) {
            seenTitles.add(rec.title);
            allResults.add(rec);
          }
        }
      }
    }

    return allResults;
  }

  // ✅ 주소 → 좌표 변환
  Future<Map<String, String>?> _getCoordinates(String address) async {
    final response = await http.get(
      Uri.parse("https://dapi.kakao.com/v2/local/search/address.json?query=$address"),
      headers: {
        "Authorization": "KakaoAK ${ApiKeys.kakaoRestApiKey}"
      },
    );

    final json = jsonDecode(response.body);
    final documents = json["documents"];
    if (documents != null && documents is List && documents.isNotEmpty) {
      final first = documents[0];
      return {
        "x": first["x"],
        "y": first["y"],
      };
    }

    return null;
  }
}

