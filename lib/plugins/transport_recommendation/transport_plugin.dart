import 'package:uuid/uuid.dart';
import '../../models/recommendation.dart';
import '../../models/persona.dart';
import '../recommendation_plugin/recommendation_plugin.dart';

class TransportRecommendationPlugin implements RecommendationPlugin {
  final _uuid = Uuid();

  @override
  Future<List<Recommendation>> fetchRecommendations(Persona persona) async {
    return [
      _createRecommendation(
        title: '자전거 타기',
        description: '도심 속 친환경 이동 수단',
        imageUrl: 'assets/images/bike.png',
      ),
      _createRecommendation(
        title: '지하철 이용',
        description: '빠르고 효율적인 대중교통',
        imageUrl: 'assets/images/subway.png',
      ),
    ];
  }

  Recommendation _createRecommendation({
    required String title,
    required String description,
    required String imageUrl,
  }) {
    return Recommendation(
      id: _uuid.v4(),
      title: title,
      description: description,
      imageUrl: imageUrl,
      pluginId: 'transport',

      //TOAN : 09/14/2025. Error를 방지하기 위해 임의처리. 이다음에 다시 변경되어야 함.
    // 🔧 확장된 필드들
    distance: "0", // fallback이므로 거리 없음
    placeUrl: "https://map.kakao.com/", // 기본 Kakao 지도 링크 또는 빈 문자열
    phone: "", // 전화번호 없음
    category: "한식 > 찌개류", // 기본 업종 분류
    );
  }
}