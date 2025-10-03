import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mosoon/models/persona.dart';
import 'package:mosoon/models/recommendation.dart';
import 'package:mosoon/config/api_keys.dart';

class RecommendationService {
  final String pluginId = "openai";

  /// ✅ 추천 근거 보기용 속성 추가
  String? lastPrompt;
  String? lastRawResponse;

  Future<List<Recommendation>> fetchRecommendations(Persona persona) async {
    final prompt = _buildPrompt(persona);
    lastPrompt = prompt; // 프롬프트 저장

    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
     headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${ApiKeys.openAiKey}", // ✅ 안전하게 참조
      },


      body: jsonEncode({
        "model": "gpt-4",
        "messages": [
          {"role": "system", "content": "당신은 음식과 쇼핑 추천 전문가입니다."},
          {"role": "user", "content": prompt}
        ],
        "temperature": 0.7
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("AI 추천 요청 실패: ${response.body}");
    }

    final content = jsonDecode(response.body)["choices"][0]["message"]["content"];
    lastRawResponse = content; // 응답 저장

    final lines = LineSplitter.split(content).where((line) => line.trim().isNotEmpty);
    return lines.map((line) => Recommendation.fromAI(line, pluginId: pluginId)).toList();
  }

  String _buildPrompt(Persona persona) {
    final taste = persona.preferences["taste"] ?? "";
    final shopping = persona.preferences["shopping"] ?? "";
    final location = persona.location;
    final description = persona.description;

    return """
사용자는 '$location'에 거주하며 '$taste'를 좋아합니다.
쇼핑 스타일은 '$shopping'이고, 성향은 '$description'입니다.
이 사용자에게 어울리는 음식 3가지와 쇼핑 아이템 2가지를 추천해주세요.
각 항목은 이름과 간단한 설명으로 구성해주세요.
""";
  }
}