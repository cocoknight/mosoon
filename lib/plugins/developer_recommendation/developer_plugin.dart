import 'package:uuid/uuid.dart';
import '../../models/recommendation.dart';
import '../../models/persona.dart';
import '../recommendation_plugin/recommendation_plugin.dart';

class DeveloperRecommendationPlugin implements RecommendationPlugin {
  final _uuid = Uuid();

  @override
  Future<List<Recommendation>> fetchRecommendations(Persona persona) async {
    return [
      _createRecommendation(
        title: 'Flutter 학습',
        description: '크로스 플랫폼 앱 개발을 위한 프레임워크',
        imageUrl: 'assets/images/flutter.png',
      ),
      _createRecommendation(
        title: 'Git 마스터하기',
        description: '버전 관리의 핵심 도구',
        imageUrl: 'assets/images/git.png',
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
      pluginId: 'developer',

      //TOAN : 09/14/2025. Error를 방지하기 위해 임의처리. 이다음에 다시 변경되어야 함.
    // 🔧 확장된 필드들
    distance: "0", // fallback이므로 거리 없음
    placeUrl: "https://map.kakao.com/", // 기본 Kakao 지도 링크 또는 빈 문자열
    phone: "", // 전화번호 없음
    category: "한식 > 찌개류", // 기본 업종 분류
    );
  }
}