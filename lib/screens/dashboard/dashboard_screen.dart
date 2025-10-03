import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/persona.dart';
import '../../models/recommendation.dart';
import '../../providers/recommendation_provider.dart';
import '../../providers/persona_provider.dart';
import '../../widgets/recommendation_card.dart';
import '../persona/persona_list_screen.dart';
import '../../screens/recommendation/reason_screen.dart'; // ✅ 추천 근거 화면 import
import '../../services/recommendation_service.dart'; // ✅ 서비스 import

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final persona = ref.watch(personaProvider);
    final recommendations = persona != null
        ? ref.watch(recommendationProvider(persona))
        : const AsyncValue<List<Recommendation>>.loading();

    return Scaffold(
      appBar: AppBar(
        title: Text('안녕하세요, ${persona?.name ?? "사용자"}님 👋'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "페르소나 관리",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PersonaListScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("오늘의 음식 추천 🍱", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 360,
              child: recommendations.when(
                data: (items) => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final rec = items[index];
                    return RecommendationCard(recommendation: rec);
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('추천을 불러올 수 없습니다: $err'),
              ),
            ),

            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text("페르소나 등록하기", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/persona/form');
              },
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.info_outline),
              label: const Text("추천 근거 보기"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                final service = RecommendationService(); // ✅ 실제 앱에서는 Provider로 관리하는 것이 좋습니다
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecommendationReasonScreen(service: service),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            const Text("빠른 기능 접근 🚀", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              children: [
                FeatureButton(label: "메모", icon: Icons.note, onTap: () => Navigator.pushNamed(context, '/memo')),
                FeatureButton(label: "일정", icon: Icons.calendar_today, onTap: () => Navigator.pushNamed(context, '/schedule')),
                FeatureButton(label: "채팅", icon: Icons.chat, onTap: () => Navigator.pushNamed(context, '/chat')),
                FeatureButton(label: "공유", icon: Icons.share, onTap: () => Navigator.pushNamed(context, '/share')),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // TODO: 화면 전환 처리
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: '추천'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const FeatureButton({required this.label, required this.icon, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(icon), Text(label)],
          ),
        ),
      ),
    );
  }
}