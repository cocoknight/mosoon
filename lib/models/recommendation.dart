class Recommendation {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String pluginId;

   // 🔧 확장된 필드들
  final String distance;     // 거리 (단위: m)
  final String placeUrl;     // Kakao 지도 링크
  final String phone;        // 전화번호 (선택)
  final String category;     // 업종 분류 (선택)


  Recommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.pluginId,
     required this.distance,
    required this.placeUrl,
    required this.phone,
    required this.category,
  });

  factory Recommendation.fromKakao(Map<String, dynamic> json, String pluginId) {
    return Recommendation(
      id: json['id'] ?? json['place_name'], // Kakao API에는 id가 없으므로 대체
      title: json['place_name'] ?? '이름 없음',
      description: json['road_address_name'] ?? json['address_name'] ?? '주소 없음',
      imageUrl: json['thumbnail_url'] ?? 'https://mosoon.app/images/food/default.png',
      pluginId: pluginId,
      distance: json['distance'] ?? '0',
      placeUrl: json['place_url'] ?? '',
      phone: json['phone'] ?? '',
      category: json['category_name'] ?? '',
    );
  }

  factory Recommendation.fromAI(String line, {String pluginId = "openai"}) {
    final parts = line.split(":");
    final title = parts[0].trim();
    final description = parts.length > 1 ? parts[1].trim() : "";

    return Recommendation(
      id: title,
      title: title,
      description: description,
      imageUrl: 'https://mosoon.app/images/food/default.png',
      pluginId: pluginId,
      distance: '0',
      placeUrl: '',
      phone: '',
      category: '',
    );
  }
  
}