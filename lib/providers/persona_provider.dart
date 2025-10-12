// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/persona.dart';

// /// 페르소나 목록 Provider
// final personaListProvider = StateProvider<List<Persona>>((ref) {
//   return [
//     Persona(
//       id: 'dev',
//       name: '개발자',
//       description: '코드를 사랑하는 사람',
//       imageUrl: 'assets/images/dev.png',
//       preferences: {
//     "taste": "매운 음식",
//     "shopping": "패션",
//   },
//   location: "화성시",

//     ),
//     Persona(
//       id: 'traveler',
//       name: '여행가',
//       description: '세상을 탐험하는 사람',
//       imageUrl: 'assets/images/traveler.png',
//       preferences: {
//     "taste": "매운 음식",
//     "shopping": "패션",
//   },
//   location: "화성시",

//     ),
//     Persona(
//       id: 'chef',
//       name: '요리사',
//       description: '맛을 창조하는 사람',
//       imageUrl: 'assets/images/chef.png',
//       preferences: {
//     "taste": /*"김치찌게"*/"삼겹살",
//     "shopping": "패션",
//   },
//   location: "동탄",
//     ),


//   ];
// });

// /// 선택된 페르소나 Provider
// //final personaProvider = StateProvider<Persona?>((ref) => null);

// //기본값을 요리사로 선택
// final personaProvider = StateProvider<Persona?>((ref) {
//   final list = ref.read(personaListProvider);
//   return list.firstWhere((p) => p.id == 'chef');
// });


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/persona.dart';

// /// ✅ Firestore에서 불러온 전체 페르소나 목록을 저장하는 Provider
// final personaListProvider = StateProvider<List<Persona>>((ref) => []);

// /// ✅ Firestore에서 마지막 선택된 페르소나를 불러오는 Provider
// final personaProvider = FutureProvider<Persona?>((ref) async {
//   final firestore = FirebaseFirestore.instance;

//   try {
//     // 🔹 1. 전체 페르소나 목록 불러오기
//     final snapshot = await firestore.collection("personas").get();
//     final personas = snapshot.docs.map((doc) {
//       final data = doc.data();
//       return Persona.fromJson(data);
//     }).toList();

//     // 🔹 2. 목록을 상태에 저장
//     ref.read(personaListProvider.notifier).state = personas;

//     if (personas.isEmpty) {
//       debugPrint("[personaProvider] ❗ Firestore에 저장된 페르소나가 없습니다.");
//       return null;
//     }

//     // 🔹 3. 선택된 페르소나 ID 불러오기
//     final selectedDoc = await firestore.collection("settings").doc("selectedPersona").get();
//     final selectedId = selectedDoc.data()?["id"] as String?;

//     if (selectedId != null) {
//       final matched = personas.firstWhere(
//         (p) => p.id == selectedId,
//         orElse: () {
//           debugPrint("[personaProvider] ⚠ 선택된 ID($selectedId)에 해당하는 페르소나가 목록에 없습니다.");
//           return personas.last;
//         },
//       );
//       debugPrint("[personaProvider] ✅ 선택된 페르소나: ${matched.name}");
//       return matched;
//     } else {
//       // 🔹 4. 선택된 페르소나가 없을 경우 → 최근 항목 사용
//       final fallback = personas.last;
//       debugPrint("[personaProvider] ℹ 선택된 페르소나가 없어 최근 항목(${fallback.name})으로 대체합니다.");
//       return fallback;
//     }
//   } catch (e, stack) {
//     debugPrint("[personaProvider] ❌ Firestore 로딩 오류: $e");
//     debugPrint(stack.toString());
//     return null;
//   }
// });

// /// ✅ 선택된 페르소나를 앱 내에서 동기적으로 관리하는 Provider (UI에서 직접 수정 가능)
// final selectedPersonaProvider = StateProvider<Persona?>((ref) => null);


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/persona.dart';

/// 🔹 전체 페르소나 목록을 저장하는 Provider
final personaListProvider = StateProvider<List<Persona>>((ref) => []);

/// 🔹 선택된 페르소나 ID를 저장하는 Provider (UI에서 직접 수정 가능)
final selectedPersonaIdProvider = StateProvider<String?>((ref) => null);

/// 🔹 선택된 ID 기반으로 페르소나를 불러오는 Provider
final personaProvider = FutureProvider.family<Persona?, String?>((ref, selectedId) async {
  final firestore = FirebaseFirestore.instance;

  try {
    // 1. Firestore에서 전체 페르소나 목록 불러오기
    final snapshot = await firestore.collection("personas").get();
    final personas = snapshot.docs.map((doc) {
      final data = doc.data();
      return Persona.fromJson(data);
    }).toList();

    // 2. 목록을 상태에 저장
    ref.read(personaListProvider.notifier).state = personas;

    if (personas.isEmpty) {
      debugPrint("[personaProvider] ❗ Firestore에 저장된 페르소나가 없습니다.");
      return null;
    }

    // 3. 선택된 ID가 null이면 Firestore에서 마지막 선택된 ID 불러오기
    String? id = selectedId;
    if (id == null) {
      final selectedDoc = await firestore.collection("settings").doc("selectedPersona").get();
      id = selectedDoc.data()?["id"] as String?;
      debugPrint("[personaProvider] Firestore에서 선택된 ID: $id");
    }

    // 4. ID에 해당하는 페르소나 찾기
    if (id != null) {
      final matched = personas.firstWhere(
        (p) => p.id == id,
        orElse: () {
          debugPrint("[personaProvider] ⚠ 선택된 ID($id)에 해당하는 페르소나가 목록에 없습니다.");
          return personas.last;
        },
      );
      debugPrint("[personaProvider] ✅ 선택된 페르소나: ${matched.name}");
      return matched;
    } else {
      // 5. 선택된 ID가 없을 경우 → 최근 항목 사용
      final fallback = personas.last;
      debugPrint("[personaProvider] ℹ 선택된 페르소나가 없어 최근 항목(${fallback.name})으로 대체합니다.");
      return fallback;
    }
  } catch (e, stack) {
    debugPrint("[personaProvider] ❌ Firestore 로딩 오류: $e");
    debugPrint(stack.toString());
    return null;
  }
}
);
