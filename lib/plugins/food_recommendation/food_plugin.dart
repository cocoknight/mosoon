// // plugins/food_recommendation/food_plugin.dart

// import 'package:uuid/uuid.dart';
// import '../../models/recommendation.dart';
// import '../../models/persona.dart';
// import '../recommendation_plugin/recommendation_plugin.dart';

// class FoodRecommendationPlugin implements RecommendationPlugin {
//   final _uuid = Uuid(); // UUID 생성기

//   @override
//   Future<List<Recommendation>> fetchRecommendations(Persona persona) async {
//     return [
//       _createRecommendation(
//         title: '김치찌개',
//         description: '매콤한 한국 전통 찌개',
//         imageUrl: 'assets/images/kimchi.png',
//       ),
//       _createRecommendation(
//         title: '비빔밥',
//         description: '다양한 채소와 고추장으로 비벼먹는 한식',
//         imageUrl: 'assets/images/bibimbap.png',
//       ),
//     ];
//   }

//   Recommendation _createRecommendation({
//     required String title,
//     required String description,
//     required String imageUrl,
//   }) {
//     return Recommendation(
//       id: _uuid.v4(), // 고유 ID 자동 생성
//       title: title,
//       description: description,
//       imageUrl: imageUrl,
//       pluginId: 'food', // 현재 플러그인 ID 자동 지정
//     );
//   }
// }



import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../models/recommendation.dart';
import '../../models/persona.dart';
import '../recommendation_plugin/recommendation_plugin.dart';
import '../../config/api_keys.dart';

class FoodRecommendationPlugin implements RecommendationPlugin {
  final _uuid = Uuid();

  @override
  Future<List<Recommendation>> fetchRecommendations(Persona persona) async {
    final taste = persona.preferences["taste"] ?? "김치찌개";
    final location = persona.location ?? "서울";

    // Step 1: 주소 → 좌표 변환
    final coordRes = await http.get(
      Uri.parse("https://dapi.kakao.com/v2/local/search/address.json?query=$location"),
      headers: {
        "Authorization": "KakaoAK ${ApiKeys.kakaoRestApiKey}",
      },
    );

    print("API 호출 상태 코드: ${coordRes.statusCode}");
    print("응답 본문: ${coordRes.body}");


    if (coordRes.statusCode != 200) return [_fallback()];

    final coordData = jsonDecode(coordRes.body);
    if (coordData["documents"].isEmpty) return [_fallback()];

    final x = coordData["documents"][0]["x"];
    final y = coordData["documents"][0]["y"];

    // Step 2: 음식 키워드로 주변 검색
    final searchRes = await http.get(
      Uri.parse("https://dapi.kakao.com/v2/local/search/keyword.json?query=$taste&x=$x&y=$y&radius=3000"),
      headers: {
        "Authorization": "KakaoAK ${ApiKeys.kakaoRestApiKey}",
      },
    );

    if (searchRes.statusCode != 200) return [_fallback()];

    final searchData = jsonDecode(searchRes.body);
    final List<Recommendation> results = [];

    for (var item in searchData["documents"]) {
      results.add(Recommendation(
    id: _uuid.v4(),
    title: item["place_name"] ?? "이름 없음",
    description: item["road_address_name"] ?? item["address_name"] ?? "주소 없음",
    imageUrl: item["thumbnail_url"] ?? "https://mosoon.app/images/food/default.png",
    pluginId: "food", // 또는 "shopping" 등 도메인에 따라 변경

    // 🔧 새 필드들 추가
    distance: item["distance"] ?? "0",
    placeUrl: item["place_url"] ?? "",
    phone: item["phone"] ?? "",
    category: item["category_name"] ?? "",
    ));

    }

    return results.isEmpty ? [_fallback()] : results;
  }

  Recommendation _fallback() {
    return Recommendation(
      id: _uuid.v4(),
      title: "김치찌개",
      description: "기본 추천: 매콤한 한국 전통 찌개",
      imageUrl: "assets/images/kimchi.png",
      pluginId: "food",

       // 🔧 확장된 필드들
    distance: "0", // fallback이므로 거리 없음
    placeUrl: "https://map.kakao.com/", // 기본 Kakao 지도 링크 또는 빈 문자열
    phone: "", // 전화번호 없음
    category: "한식 > 찌개류", // 기본 업종 분류

    );
  }
}