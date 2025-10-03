import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/persona.dart';

/// 페르소나 목록 Provider
final personaListProvider = StateProvider<List<Persona>>((ref) {
  return [
    Persona(
      id: 'dev',
      name: '개발자',
      description: '코드를 사랑하는 사람',
      imageUrl: 'assets/images/dev.png',
      preferences: {
    "taste": "매운 음식",
    "shopping": "패션",
  },
  location: "화성시",

    ),
    Persona(
      id: 'traveler',
      name: '여행가',
      description: '세상을 탐험하는 사람',
      imageUrl: 'assets/images/traveler.png',
      preferences: {
    "taste": "매운 음식",
    "shopping": "패션",
  },
  location: "화성시",

    ),
    Persona(
      id: 'chef',
      name: '요리사',
      description: '맛을 창조하는 사람',
      imageUrl: 'assets/images/chef.png',
      preferences: {
    "taste": /*"김치찌게"*/"삼겹살",
    "shopping": "패션",
  },
  location: "동탄",
    ),


  ];
});

/// 선택된 페르소나 Provider
//final personaProvider = StateProvider<Persona?>((ref) => null);

//기본값을 요리사로 선택
final personaProvider = StateProvider<Persona?>((ref) {
  final list = ref.read(personaListProvider);
  return list.firstWhere((p) => p.id == 'chef');
});

