// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/persona.dart';
// import '../models/recommendation.dart';
// import '../config/api_keys.dart';



// class KakaoService {
//   static const int radius = 20000; // 20km

//   Future<List<Recommendation>> fetchRecommendations(Persona persona) async {
//     final location = persona.location;
//     final coords = await _getCoordinates(location);
//     if (coords == null) return [];

//     final rawTaste = persona.preferences["taste"] ?? "";
//     final rawShopping = persona.preferences["shopping"] ?? "";
//     final keywords = [...rawTaste.split(","), ...rawShopping.split(",")]
//         .map((s) => s.trim())
//         .where((s) => s.isNotEmpty)
//         .toList();

//     final Set<String> seenTitles = {};
//     final List<Recommendation> allResults = [];

//     for (final keyword in keywords) {
//       final response = await http.get(
//         Uri.parse(
//           "https://dapi.kakao.com/v2/local/search/keyword.json"
//           "?query=$keyword"
//           "&x=${coords['x']}&y=${coords['y']}&radius=$radius"
//         ),
//         headers: {
//           "Authorization": "KakaoAK ${ApiKeys.kakaoRestApiKey}"
//         },
//       );

//       final json = jsonDecode(response.body);
//       final items = json["documents"];

//       if (items != null && items is List) {
//         for (final item in items) {
//           final rec = Recommendation.fromKakao(item);
//           if (!seenTitles.contains(rec.title)) {
//             seenTitles.add(rec.title);
//             allResults.add(rec);
//           }
//         }
//       }
//     }

//     return allResults;
//   }

//   // ✅ 주소 → 좌표 변환
//   Future<Map<String, String>?> _getCoordinates(String address) async {
//     final response = await http.get(
//       Uri.parse("https://dapi.kakao.com/v2/local/search/address.json?query=$address"),
//       headers: {
//         "Authorization": "KakaoAK ${ApiKeys.kakaoRestApiKey}"
//       },
//     );

//     final json = jsonDecode(response.body);
//     final documents = json["documents"];
//     if (documents != null && documents is List && documents.isNotEmpty) {
//       final first = documents[0];
//       return {
//         "x": first["x"],
//         "y": first["y"],
//       };
//     }

//     return null;
//   }
// }


//TOAN : 10/14/2025. 현재 위치 기준으로 추천을 진행 한다.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/persona.dart';
import '../models/recommendation.dart';
import '../config/api_keys.dart';

class KakaoService {
  static const int radius = 20000; // 20km

  Future<List<Recommendation>> fetchRecommendations(Persona persona) async {
    final position = await _getCurrentPosition();
    if (position == null) return [];

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
          "&x=${position.longitude}&y=${position.latitude}&radius=$radius"
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

  /// ✅ 현재 GPS 위치 가져오기
  Future<Position?> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
