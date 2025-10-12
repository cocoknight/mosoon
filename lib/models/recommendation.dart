class Recommendation {
  final String title;
  final String description;
  final String source; // ✅ 전략 ID (예: "kakao", "openai")

   // ✅ 추가 필드
  final String? placeUrl;     // 카카오맵 상세 페이지 링크
  final String? distance;     // 거리 (미터 단위 문자열)
  final int? reviewCount;     // 리뷰 수 (일부 장소에만 제공됨)



  Recommendation({
    required this.title,
    required this.description,
    required this.source,
    this.placeUrl,
    this.distance,
    this.reviewCount,
  });

  factory Recommendation.fromKakao(Map<String, dynamic> json) {
    return Recommendation(
       title: json["place_name"],
      description: json["road_address_name"] ?? "",
      source: "kakao",
      placeUrl: json["place_url"],
      distance: json["distance"],
      reviewCount: json["review_count"] is int ? json["review_count"] : null,
    );
  }

   factory Recommendation.fromAI(String line) {
    // 번호 제거 (예: "1. " 또는 "2. ")
    final cleanLine = line.replaceFirst(RegExp(r'^\d+\.\s*'), '');

    // ":" 기준으로 제목과 설명 분리
    final parts = cleanLine.split(":");
    final title = parts.first.trim();
    final description = parts.length > 1
        ? parts.sublist(1).join(":").trim()
        : "AI 추천"; // fallback 설명

    return Recommendation(
      title: title,
      description: description,
      source: "openai",
    );
  }

}