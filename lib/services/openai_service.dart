// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;
// import '../models/persona.dart';
// import '../models/recommendation.dart';
// import '../config/api_keys.dart';

// class OpenAiService {
//   Future<List<Recommendation>> fetchRecommendations(Persona persona) async {
//     final prompt = _buildPrompt(persona);
//     //print("[OpenAiService] 🔹 보낸 프롬프트:\n$prompt");
//     log("OpenAI 응답 내용: $prompt");

//     final response = await http.post(
//       Uri.parse("https://api.openai.com/v1/chat/completions"),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer ${ApiKeys.openAiKey}",
//       },
//       body: jsonEncode({
//         "model": "gpt-3.5-turbo",
//         "messages": [
//           {"role": "system", "content": "당신은 추천 전문가입니다."},
//           {"role": "user", "content": prompt}
//         ],
//         "temperature": 0.7,
//       }),
//     );

//     final json = jsonDecode(utf8.decode(response.bodyBytes));
//     final content = json["choices"][0]["message"]["content"];
//     //print("[OpenAiService] 🔸 OpenAI 응답 내용:\n$content");
//     log("OpenAI 응답 내용: $content");
 
//     final lines = LineSplitter.split(content).where((line) => line.trim().isNotEmpty);
//     final recommendations = lines.map((line) => Recommendation.fromAI(line)).toList();

//     //print("[OpenAiService] ✅ 추천 결과 ${recommendations.length}개 생성됨");
//     log("[OpenAiService] ✅ 추천 결과 ${recommendations.length}개 생성됨");
//     for (var rec in recommendations) {
//       //print("• ${rec.title} → ${rec.description}");
//       log("• ${rec.title} → ${rec.description}");
//     }

//     return recommendations;
//   }

//   String _buildPrompt(Persona persona) {
//     final name = persona.name;
//     final location = persona.location;
//     final taste = persona.preferences["taste"] ?? "";
//     final shopping = persona.preferences["shopping"] ?? "";
//     final desc = persona.description;

//     return "$name은 $location에 거주하며, $desc 성향을 가진 사람입니다. "
//            "선호 음식은 '$taste', 쇼핑 관심사는 '$shopping'입니다. "
//            "이 사람에게 어울리는 음식과 쇼핑 추천을 각각 3개씩 제시해주세요.";
//   }
// }


import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/persona.dart';
import '../models/recommendation.dart';
import '../config/api_keys.dart';

class OpenAiService {
  Future<List<Recommendation>> fetchRecommendations(Persona persona) async {
    final prompt = _buildPrompt(persona);
    log("[OpenAiService] 🔹 보낸 프롬프트:\n$prompt");

    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${ApiKeys.openAiKey}",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "당신은 추천 전문가입니다."},
          {"role": "user", "content": prompt}
        ],
        "temperature": 0.7,
      }),
    );

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    final content = json["choices"][0]["message"]["content"];
    log("[OpenAiService] 🔸 OpenAI 응답 내용:\n$content");

    // 줄 단위로 나누고 의미 있는 추천만 필터링
    final lines = LineSplitter.split(content)
        .map((line) => line.trim())
        .where((line) =>
            line.isNotEmpty &&
            RegExp(r'^\d+\.\s*').hasMatch(line) &&
            line.contains(":"));

    final recommendations = lines.map((line) => Recommendation.fromAI(line)).toList();

    log("[OpenAiService] ✅ 추천 결과 ${recommendations.length}개 생성됨");
    for (var rec in recommendations) {
      log("• ${rec.title} → ${rec.description}");
    }

    return recommendations;
  }

  String _buildPrompt(Persona persona) {
    final name = persona.name;
    final location = persona.location;
    final taste = persona.preferences["taste"] ?? "";
    final shopping = persona.preferences["shopping"] ?? "";
    final desc = persona.description;

    return "$name은 $location에 거주하며, $desc 성향을 가진 사람입니다. "
           "선호 음식은 '$taste', 쇼핑 관심사는 '$shopping'입니다. "
           "이 사람에게 어울리는 음식과 쇼핑 추천을 각각 3개씩 제시해주세요.";
  }
}
