import 'package:flutter/material.dart';


class RecommendationReasonScreen extends StatelessWidget {
  final String prompt;
  final String response;
  final String strategyLabel;

  const RecommendationReasonScreen({
    required this.prompt,
    required this.response,
    required this.strategyLabel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$strategyLabel 추천 근거")),
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