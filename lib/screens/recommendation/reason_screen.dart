import 'package:flutter/material.dart';
import '../../services/recommendation_service.dart';

class RecommendationReasonScreen extends StatelessWidget {
  final RecommendationService service;
  const RecommendationReasonScreen({required this.service, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prompt = service.lastPrompt ?? "프롬프트 없음";
    final response = service.lastRawResponse ?? "응답 없음";

    return Scaffold(
      appBar: AppBar(title: const Text("추천 근거 보기")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("📌 AI에게 전달된 프롬프트", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(prompt, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 24),
              const Text("🤖 OpenAI 응답 결과", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(response, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}