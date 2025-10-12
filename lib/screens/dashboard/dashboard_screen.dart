//DashboardScreen을 전략 중심 구조로 리팩토링
//추천 결과를 전략별로 명확히 구분하여 명함형 카드 UI로 시각적으로 몰입감 있게 표현


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../models/persona.dart';
// import '../../models/recommendation.dart';
// import '../../providers/persona_provider.dart';
// import '../../providers/recommendation_provider.dart';
// import '../../widgets/strategy_card.dart';
// import '../persona/persona_list_screen.dart';
// import '../../screens/recommendation/reason_screen.dart';

// class DashboardScreen extends ConsumerWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

  // static const Map<String, Map<String, Object>> strategyStyles = {
  //   "kakao": {
  //     "color": Colors.orange,
  //     "icon": Icons.location_on,
  //     "label": "카카오 추천"
  //   },
  //   "openai": {
  //     "color": Colors.indigo,
  //     "icon": Icons.auto_awesome,
  //     "label": "AI 추천"
  //   },
  //   // 추가 전략은 여기에 확장
  // };

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final persona = ref.watch(personaProvider);
//     final grouped = persona != null
//         ? ref.watch(groupedRecommendationProvider(persona))
//         : const AsyncValue<Map<String, List<Recommendation>>>.loading();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('안녕하세요, ${persona?.name ?? "사용자"}님 👋'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person),
//             tooltip: "페르소나 관리",
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const PersonaListScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("오늘의 추천 🎯", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             grouped.when(
//               data: (groupedItems) => Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: groupedItems.entries.map((entry) {
//                   final strategyId = entry.key;
//                   final recs = entry.value;
//                   final style = strategyStyles[strategyId];

//                   final label = style?["label"] as String? ?? strategyId;
//                   final icon = style?["icon"] as IconData? ?? Icons.star;
//                   final color = style?["color"] as Color? ?? Colors.grey;

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       SizedBox(
//                         height: 220,
//                         child: ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: recs.length,
//                           itemBuilder: (context, index) {
//                             final rec = recs[index];
//                             return StrategyCard(
//                               recommendation: rec,
//                               backgroundColor: color,
//                               icon: icon,
//                             );
//                           },
//                           separatorBuilder: (_, __) => const SizedBox(width: 12),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                     ],
//                   );
//                 }).toList(),
//               ),
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error: (err, _) => Text('추천을 불러올 수 없습니다: $err'),
//             ),

//             ElevatedButton.icon(
//               icon: const Icon(Icons.person_add, color: Colors.white),
//               label: const Text("페르소나 등록하기", style: TextStyle(color: Colors.white)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/persona/form');
//               },
//             ),

//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.info_outline),
//               label: const Text("추천 근거 보기"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.grey[800],
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const RecommendationReasonScreen(
//                       prompt: "프롬프트 없음",
//                       response: "응답 없음",
//                       strategyLabel: "OpenAI",
//                     ),
//                   ),
//                 );
//               },
//             ),

//             const SizedBox(height: 24),
//             const Text("빠른 기능 접근 🚀", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             GridView.count(
//               crossAxisCount: 2,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               childAspectRatio: 1.2,
//               children: [
//                 FeatureButton(label: "메모", icon: Icons.note, onTap: () => Navigator.pushNamed(context, '/memo')),
//                 FeatureButton(label: "일정", icon: Icons.calendar_today, onTap: () => Navigator.pushNamed(context, '/schedule')),
//                 FeatureButton(label: "채팅", icon: Icons.chat, onTap: () => Navigator.pushNamed(context, '/chat')),
//                 FeatureButton(label: "공유", icon: Icons.share, onTap: () => Navigator.pushNamed(context, '/share')),
//               ],
//             ),
//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0,
//         onTap: (index) {
//           // TODO: 화면 전환 처리
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
//           BottomNavigationBarItem(icon: Icon(Icons.star), label: '추천'),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
//         ],
//       ),
//     );
//   }
// }

// class FeatureButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onTap;
//   const FeatureButton({required this.label, required this.icon, required this.onTap, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 28),
//               const SizedBox(height: 8),
//               Text(label, style: const TextStyle(fontSize: 14)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import '../models/recommendation.dart';

// class StrategyCard extends StatelessWidget {
//   final Recommendation recommendation;
//   final Color backgroundColor;
//   final IconData icon;

//   const StrategyCard({
//     required this.recommendation,
//     required this.backgroundColor,
//     required this.icon,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       width: 240,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 28, color: Colors.white),
//           const SizedBox(height: 12),
//           Text(
//             recommendation.title,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             recommendation.description,
//             style: const TextStyle(fontSize: 14, color: Colors.white70),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../models/persona.dart';
// import '../../models/recommendation.dart';
// import '../../providers/persona_provider.dart';
// import '../../providers/recommendation_provider.dart';
// import '../../widgets/strategy_card.dart';
// import '../persona/persona_list_screen.dart';
// import '../../screens/recommendation/reason_screen.dart';

// class DashboardScreen extends ConsumerWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   // static const Map<String, Map<String, Object>> strategyStyles = {
//   //   "kakao": {
//   //     "icon": Icons.location_on,
//   //     "label": "카카오 추천"
//   //   },
//   //   "openai": {
//   //     "icon": Icons.auto_awesome,
//   //     "label": "AI 추천"
//   //   },
//   // };



//   static const Map<String, Map<String, Object>> strategyStyles = {
//     "kakao": {
//       "color": Colors.orange,
//       "icon": Icons.location_on,
//       "label": "카카오 추천"
//     },
//     "openai": {
//       "color": Colors.indigo,
//       "icon": Icons.auto_awesome,
//       "label": "AI 추천"
//     },
//     // 추가 전략은 여기에 확장
//   };
  


//   void _openKakaoMap(String title) async {
//     if (title.trim().isEmpty) return;
//     final url = Uri.encodeFull("https://map.kakao.com/?q=$title");
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     }
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final persona = ref.watch(personaProvider);
//     final grouped = persona != null
//         ? ref.watch(groupedRecommendationProvider(persona))
//         : const AsyncValue<Map<String, List<Recommendation>>>.loading();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('안녕하세요, ${persona?.name ?? "사용자"}님 👋'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person),
//             tooltip: "페르소나 관리",
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const PersonaListScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: grouped.when(
//         data: (groupedItems) => ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: groupedItems.length,
//           itemBuilder: (context, strategyIndex) {
//             final strategyId = groupedItems.keys.elementAt(strategyIndex);
//             final recs = groupedItems[strategyId]!;
//             final style = strategyStyles[strategyId];

//             final label = style?["label"] as String? ?? strategyId;
//             final icon = style?["icon"] as IconData? ?? Icons.star;
//             final color = style?["color"] as Color? ?? Colors.grey;
            
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 SizedBox(
//                   height: 220,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: recs.length,
//                     itemBuilder: (context, index) {
//                       final rec = recs[index];
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 12),
//                         child: StrategyCard(
//                           recommendation: rec,
//                          icon: icon,
//                          backgroundColor: color, // ✅ strategyStyles에서 가져온 색상 그대로 전달
//                          onLocationTap: strategyId == "kakao"
//                          ? () => _openKakaoMap(rec.title)
//                          : null,

//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             );
//           },
//         ),
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, _) => Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text('추천을 불러올 수 없습니다: $err'),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0,
//         onTap: (index) {
//           // TODO: 화면 전환 처리
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
//           BottomNavigationBarItem(icon: Icon(Icons.star), label: '추천'),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../models/persona.dart';
// import '../../models/recommendation.dart';
// import '../../providers/persona_provider.dart';
// import '../../providers/recommendation_provider.dart';
// import '../../widgets/strategy_card.dart';
// import '../persona/persona_list_screen.dart';

// class DashboardScreen extends ConsumerWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   static const Map<String, Map<String, Object>> strategyStyles = {
//     "kakao": {
//       "color": Colors.orangeAccent, // ✅ 밝은 오렌지
//       "icon": Icons.location_on,
//       "label": "카카오 추천"
//     },
//     "openai": {
//       "color": Colors.indigo,
//       "icon": Icons.auto_awesome,
//       "label": "AI 추천"
//     },
//   };

//   // void _openKakaoMapApp(BuildContext context, String query) async {
//   //   final uri = Uri.parse("kakaomap://open?page=placeSearch&q=$query");

//   //   if (await canLaunchUrl(uri)) {
//   //     final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
//   //     if (!success) {
//   //       _showErrorDialog(context, "카카오맵 앱을 실행할 수 없습니다.");
//   //     }
//   //   } else {
//   //     _showErrorDialog(context, "카카오맵 앱이 설치되어 있지 않거나 실행할 수 없습니다.");
//   //   }
//   // }

//   void _openKakaoMapApp(BuildContext context, String query) async {
//   final encodedQuery = Uri.encodeComponent(query);
//   final uri = Uri.parse("kakaomap://open?page=placeSearch&q=$encodedQuery");

//   if (await canLaunchUrl(uri)) {
//     final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
//     if (!success) {
//       _showErrorDialog(context, "카카오맵 앱을 실행할 수 없습니다.");
//     }
//   } else {
//     _showErrorDialog(context, "카카오맵 앱이 설치되어 있지 않거나 실행할 수 없습니다.");
//   }
// }


//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("실행 오류"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             child: const Text("확인"),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final persona = ref.watch(personaProvider);
//     final grouped = persona != null
//         ? ref.watch(groupedRecommendationProvider(persona))
//         : const AsyncValue<Map<String, List<Recommendation>>>.loading();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('안녕하세요, ${persona?.name ?? "사용자"}님 👋'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person),
//             tooltip: "페르소나 관리",
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const PersonaListScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: grouped.when(
//         data: (groupedItems) => ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: groupedItems.length,
//           itemBuilder: (context, strategyIndex) {
//             final strategyId = groupedItems.keys.elementAt(strategyIndex);
//             final recs = groupedItems[strategyId]!;
//             final style = strategyStyles[strategyId];

//             final label = style?["label"] as String? ?? strategyId;
//             final icon = style?["icon"] as IconData? ?? Icons.star;
//             final color = style?["color"] as Color? ?? Colors.grey;

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 SizedBox(
//                   height: 220,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: recs.length,
//                     itemBuilder: (context, index) {
//                       final rec = recs[index];
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 12),
//                         child: StrategyCard(
//                           recommendation: rec,
//                           icon: icon,
//                           backgroundColor: color,
//                           onLocationTap: strategyId == "kakao"
//                               ? () => _openKakaoMapApp(context, rec.title ?? "")
//                               : null,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             );
//           },
//         ),
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, _) => Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text('추천을 불러올 수 없습니다: $err'),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0,
//         onTap: (index) {
//           // TODO: 화면 전환 처리
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
//           BottomNavigationBarItem(icon: Icon(Icons.star), label: '추천'),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../../config/api_keys.dart'; // ✅ API 키 불러오기
// import '../../models/persona.dart';
// import '../../models/recommendation.dart';
// import '../../providers/persona_provider.dart';
// import '../../providers/recommendation_provider.dart';
// import '../../widgets/strategy_card.dart';
// import '../persona/persona_list_screen.dart';

// class DashboardScreen extends ConsumerWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   static const Map<String, Map<String, Object>> strategyStyles = {
//     "kakao": {
//       "color": Colors.orangeAccent,
//       "icon": Icons.location_on,
//       "label": "카카오 추천"
//     },
//     "openai": {
//       "color": Colors.indigo,
//       "icon": Icons.auto_awesome,
//       "label": "AI 추천"
//     },
//   };


//   Future<void> _launchKakaoReview(BuildContext context, String keyword) async {
//   final encoded = Uri.encodeComponent(keyword);
//   final url = Uri.parse("https://dapi.kakao.com/v2/local/search/keyword.json?query=$encoded");

//   final response = await http.get(url, headers: {
//     "Authorization": "KakaoAK ${ApiKeys.kakaoRestApiKey}",
//   });

//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     final documents = data['documents'];
//     if (documents.isNotEmpty) {
//       final placeUrl = documents[0]['place_url'];
//       final uri = Uri.parse(placeUrl);
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } else {
//         _showErrorDialog(context, "웹 브라우저를 열 수 없습니다.");
//       }
//     } else {
//       _showErrorDialog(context, "검색 결과가 없습니다.");
//     }
//   } else {
//     _showErrorDialog(context, "카카오 API 호출 실패: ${response.statusCode}");
//   }
// }



//   Future<void> _launchKakaoMap(BuildContext context, String keyword) async {
//     final encoded = Uri.encodeComponent(keyword);
//     final url = Uri.parse("https://dapi.kakao.com/v2/local/search/keyword.json?query=$encoded");

//     final response = await http.get(url, headers: {
//       "Authorization": "KakaoAK ${ApiKeys.kakaoRestApiKey}", // ✅ API 키 사용
//     });

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final documents = data['documents'];
//       if (documents.isNotEmpty) {
//         final place = documents[0];
//         final lat = place['y'];
//         final lng = place['x'];
//         final uri = Uri.parse("kakaomap://look?p=$lat,$lng");

//         if (await canLaunchUrl(uri)) {
//           await launchUrl(uri, mode: LaunchMode.externalApplication);
//         } else {
//           _showErrorDialog(context, "카카오맵 앱을 실행할 수 없습니다.");
//         }
//       } else {
//         _showErrorDialog(context, "검색 결과가 없습니다.");
//       }
//     } else {
//       _showErrorDialog(context, "카카오 API 호출 실패: ${response.statusCode}");
//     }
//   }

//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("실행 오류"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             child: const Text("확인"),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final persona = ref.watch(personaProvider);
//     final grouped = persona != null
//         ? ref.watch(groupedRecommendationProvider(persona))
//         : const AsyncValue<Map<String, List<Recommendation>>>.loading();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('안녕하세요, ${persona?.name ?? "사용자"}님 👋'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person),
//             tooltip: "페르소나 관리",
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const PersonaListScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: grouped.when(
//         data: (groupedItems) => ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: groupedItems.length,
//           itemBuilder: (context, strategyIndex) {
//             final strategyId = groupedItems.keys.elementAt(strategyIndex);
//             final recs = groupedItems[strategyId]!;
//             final style = strategyStyles[strategyId];

//             final label = style?["label"] as String? ?? strategyId;
//             final icon = style?["icon"] as IconData? ?? Icons.star;
//             final color = style?["color"] as Color? ?? Colors.grey;

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 SizedBox(
//                   height: 220,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: recs.length,
//                     itemBuilder: (context, index) {
//                       final rec = recs[index];
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 12),
//                         child: StrategyCard(
//                           recommendation: rec,
//                           icon: icon,
//                           backgroundColor: color,
//                           onLocationTap: strategyId == "kakao"
//                               ? () => _launchKakaoMap(context, rec.title)
//                               : null,
//                           onReviewTap: strategyId == "kakao"
//                               ? () => _launchKakaoReview(context, rec.title)
//                               : null,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             );
//           },
//         ),
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, _) => Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text('추천을 불러올 수 없습니다: $err'),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0,
//         onTap: (index) {
//           // TODO: 화면 전환 처리
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
//           BottomNavigationBarItem(icon: Icon(Icons.star), label: '추천'),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
//         ],
//       ),
//     );
//   }
// }


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

// import '../../config/api_keys.dart';
// import '../../models/persona.dart';
// import '../../models/recommendation.dart';
// import '../../providers/persona_provider.dart';
// import '../../providers/recommendation_provider.dart';
// import '../../widgets/strategy_card.dart';
// import '../persona/persona_list_screen.dart';

// class DashboardScreen extends ConsumerWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   static const Map<String, Map<String, Object>> strategyStyles = {
//     "kakao": {
//       "color": Colors.orangeAccent,
//       "icon": Icons.location_on,
//       "label": "카카오 추천"
//     },
//     "openai": {
//       "color": Colors.indigo,
//       "icon": Icons.auto_awesome,
//       "label": "AI 추천"
//     },
//   };

//   Future<void> _launchKakaoMap(BuildContext context, String keyword) async {
//     final encoded = Uri.encodeComponent(keyword);
//     final url = Uri.parse("https://dapi.kakao.com/v2/local/search/keyword.json?query=$encoded");

//     final response = await http.get(url, headers: {
//       "Authorization": "KakaoAK ${ApiKeys.kakaoRestApiKey}",
//     });

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final documents = data['documents'];
//       if (documents.isNotEmpty) {
//         final place = documents[0];
//         final lat = place['y'];
//         final lng = place['x'];
//         final uri = Uri.parse("kakaomap://look?p=$lat,$lng");

//         if (await canLaunchUrl(uri)) {
//           await launchUrl(uri, mode: LaunchMode.externalApplication);
//         } else {
//           _showErrorDialog(context, "카카오맵 앱을 실행할 수 없습니다.");
//         }
//       } else {
//         _showErrorDialog(context, "검색 결과가 없습니다.");
//       }
//     } else {
//       _showErrorDialog(context, "카카오 API 호출 실패: ${response.statusCode}");
//     }
//   }

//   Future<void> _launchKakaoReview(BuildContext context, Recommendation rec) async {
//     if (rec.placeUrl == null || rec.placeUrl!.isEmpty) {
//       _showErrorDialog(context, "리뷰 링크가 없습니다.");
//       return;
//     }

//     final uri = Uri.parse(rec.placeUrl!);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       _showErrorDialog(context, "웹 브라우저를 열 수 없습니다.");
//     }
//   }

//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("실행 오류"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             child: const Text("확인"),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final persona = ref.watch(personaProvider);
//     final grouped = persona != null
//         ? ref.watch(groupedRecommendationProvider(persona))
//         : const AsyncValue<Map<String, List<Recommendation>>>.loading();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('안녕하세요, ${persona?.name ?? "사용자"}님 👋'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person),
//             tooltip: "페르소나 관리",
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const PersonaListScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: grouped.when(
//         data: (groupedItems) => ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: groupedItems.length,
//           itemBuilder: (context, strategyIndex) {
//             final strategyId = groupedItems.keys.elementAt(strategyIndex);
//             final recs = groupedItems[strategyId]!;
//             final style = strategyStyles[strategyId];

//             final label = style?["label"] as String? ?? strategyId;
//             final icon = style?["icon"] as IconData? ?? Icons.star;
//             final color = style?["color"] as Color? ?? Colors.grey;

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 SizedBox(
//                   height: 220,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: recs.length,
//                     itemBuilder: (context, index) {
//                       final rec = recs[index];
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 12),
//                         child: StrategyCard(
//                           recommendation: rec,
//                           icon: icon,
//                           backgroundColor: color,
//                           onLocationTap: strategyId == "kakao"
//                               ? () => _launchKakaoMap(context, rec.title)
//                               : null,
//                           onReviewTap: strategyId == "kakao"
//                               ? () => _launchKakaoReview(context, rec)
//                               : null,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             );
//           },
//         ),
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, _) => Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text('추천을 불러올 수 없습니다: $err'),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0,
//         onTap: (index) {
//           // TODO: 화면 전환 처리
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
//           BottomNavigationBarItem(icon: Icon(Icons.star), label: '추천'),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../config/api_keys.dart';
import '../../models/persona.dart';
import '../../models/recommendation.dart';
import '../../providers/persona_provider.dart';
import '../../providers/recommendation_provider.dart';
import '../../widgets/strategy_card.dart';
import '../persona/persona_list_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  static const Map<String, Map<String, Object>> strategyStyles = {
    "kakao": {
      "color": Colors.orangeAccent,
      "icon": Icons.location_on,
      "label": "카카오 추천"
    },
    "openai": {
      "color": Colors.indigo,
      "icon": Icons.auto_awesome,
      "label": "AI 추천"
    },
  };

  Future<void> _launchKakaoMap(BuildContext context, String keyword) async {
    final encoded = Uri.encodeComponent(keyword);
    final url = Uri.parse("https://dapi.kakao.com/v2/local/search/keyword.json?query=$encoded");

    final response = await http.get(url, headers: {
      "Authorization": "KakaoAK ${ApiKeys.kakaoRestApiKey}",
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final documents = data['documents'];
      if (documents.isNotEmpty) {
        final place = documents[0];
        final lat = place['y'];
        final lng = place['x'];
        final uri = Uri.parse("kakaomap://look?p=$lat,$lng");

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          _showErrorDialog(context, "카카오맵 앱을 실행할 수 없습니다.");
        }
      } else {
        _showErrorDialog(context, "검색 결과가 없습니다.");
      }
    } else {
      _showErrorDialog(context, "카카오 API 호출 실패: ${response.statusCode}");
    }
  }

  Future<void> _launchKakaoReview(BuildContext context, Recommendation rec) async {
    if (rec.placeUrl == null || rec.placeUrl!.isEmpty) {
      _showErrorDialog(context, "리뷰 링크가 없습니다.");
      return;
    }

    final uri = Uri.parse(rec.placeUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showErrorDialog(context, "웹 브라우저를 열 수 없습니다.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("실행 오류"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("확인"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedPersonaIdProvider);
    
    final personaAsync = ref.watch(personaProvider(selectedId));

    return personaAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text("페르소나 로딩 실패: $err")),
      ),
      data: (persona) {
        if (persona == null) {
          return const Scaffold(
            body: Center(child: Text("선택된 페르소나가 없습니다.")),
          );
        }

        final grouped = ref.watch(groupedRecommendationProvider(persona));

        return Scaffold(
          appBar: AppBar(
            title: Text('안녕하세요, ${persona.name}님 👋'),
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
          body: grouped.when(
            data: (groupedItems) => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedItems.length,
              itemBuilder: (context, strategyIndex) {
                final strategyId = groupedItems.keys.elementAt(strategyIndex);
                final recs = groupedItems[strategyId]!;
                final style = strategyStyles[strategyId];

                final label = style?["label"] as String? ?? strategyId;
                final icon = style?["icon"] as IconData? ?? Icons.star;
                final color = style?["color"] as Color? ?? Colors.grey;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recs.length,
                        itemBuilder: (context, index) {
                          final rec = recs[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: StrategyCard(
                              recommendation: rec,
                              icon: icon,
                              backgroundColor: color,
                              onLocationTap: strategyId == "kakao"
                                  ? () => _launchKakaoMap(context, rec.title)
                                  : null,
                              onReviewTap: strategyId == "kakao"
                                  ? () => _launchKakaoReview(context, rec)
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('추천을 불러올 수 없습니다: $err'),
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
      },
    );
  }
}