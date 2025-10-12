// import 'package:flutter/material.dart';
// import '../models/recommendation.dart';

// class StrategyCard extends StatelessWidget {
//   final Recommendation recommendation;
//   final IconData icon;
//   final Color backgroundColor;
//   final VoidCallback? onLocationTap;

//   const StrategyCard({
//     required this.recommendation,
//     required this.icon,
//     required this.backgroundColor,
//     this.onLocationTap,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 250),
//       width: 240,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: backgroundColor.withOpacity(0.6), // ✅ 더 밝게 보이도록 조정
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: backgroundColor),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   recommendation.title ?? "제목 없음",
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               if (onLocationTap != null)
//                 IconButton(
//                   icon: const Icon(Icons.map, color: Colors.blue),
//                   tooltip: "카카오맵에서 보기",
//                   onPressed: onLocationTap,
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             recommendation.description ?? "설명이 없습니다.",
//             style: const TextStyle(fontSize: 14),
//             maxLines: 3,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import '../models/recommendation.dart';

// class StrategyCard extends StatelessWidget {
//   final Recommendation recommendation;
//   final IconData icon;
//   final Color backgroundColor;
//   final VoidCallback? onLocationTap;
//   final VoidCallback? onReviewTap;
//   const StrategyCard({
//     required this.recommendation,
//     required this.icon,
//     required this.backgroundColor,
//     this.onLocationTap,
//     this.onReviewTap,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 250),
//       width: 240,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: backgroundColor.withOpacity(0.6),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: backgroundColor),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   recommendation.title ?? "제목 없음",
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               if (onLocationTap != null)
//                 IconButton(
//                   icon: const Icon(Icons.map, color: Colors.blue),
//                   tooltip: "카카오맵에서 보기",
//                   onPressed: onLocationTap,
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             recommendation.description ?? "설명이 없습니다.",
//             style: const TextStyle(fontSize: 14),
//             maxLines: 3,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const Spacer(),
//           if (onReviewTap != null)
//             Align(
//               alignment: Alignment.bottomRight,
//               child: TextButton.icon(
//                 icon: const Icon(Icons.reviews, size: 18),
//                 label: const Text("리뷰 보기"),
//                 onPressed: onReviewTap,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import '../models/recommendation.dart';

// class StrategyCard extends StatelessWidget {
//   final Recommendation recommendation;
//   final IconData icon;
//   final Color backgroundColor;
//   final VoidCallback? onLocationTap;
//   final VoidCallback? onReviewTap;

//   const StrategyCard({
//     required this.recommendation,
//     required this.icon,
//     required this.backgroundColor,
//     this.onLocationTap,
//     this.onReviewTap,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final distanceText = recommendation.distance != null
//         ? int.parse(recommendation.distance!) >= 1000
//             ? "${(int.parse(recommendation.distance!) / 1000).toStringAsFixed(1)}km"
//             : "${recommendation.distance}m"
//         : null;

//     final reviewText = recommendation.reviewCount != null
//         ? "${recommendation.reviewCount}개 리뷰"
//         : null;

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 250),
//       width: 240,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: backgroundColor.withOpacity(0.6),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: backgroundColor),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   recommendation.title,
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               if (onLocationTap != null)
//                 IconButton(
//                   icon: const Icon(Icons.map, color: Colors.blue),
//                   tooltip: "지도에서 보기",
//                   onPressed: onLocationTap,
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             recommendation.description,
//             style: const TextStyle(fontSize: 14),
//             maxLines: 3,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 8),
//           if (distanceText != null)
//             Text("📍 거리: $distanceText", style: const TextStyle(fontSize: 13)),
//           if (reviewText != null)
//             Text("⭐️ $reviewText", style: const TextStyle(fontSize: 13)),
//           const Spacer(),
//           if (onReviewTap != null)
//             Align(
//               alignment: Alignment.bottomRight,
//               child: TextButton.icon(
//                 icon: const Icon(Icons.reviews, size: 18),
//                 label: const Text("리뷰 보기"),
//                 onPressed: onReviewTap,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import '../models/recommendation.dart';

// class StrategyCard extends StatelessWidget {
//   final Recommendation recommendation;
//   final IconData icon;
//   final Color backgroundColor;
//   final VoidCallback? onLocationTap;
//   final VoidCallback? onReviewTap;

//   const StrategyCard({
//     required this.recommendation,
//     required this.icon,
//     required this.backgroundColor,
//     this.onLocationTap,
//     this.onReviewTap,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final distanceText = recommendation.distance != null
//         ? int.parse(recommendation.distance!) >= 1000
//             ? "${(int.parse(recommendation.distance!) / 1000).toStringAsFixed(1)}km"
//             : "${recommendation.distance}m"
//         : null;

//     final reviewText = recommendation.reviewCount != null
//         ? "${recommendation.reviewCount}개 리뷰"
//         : null;

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 250),
//       width: 240,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: backgroundColor.withOpacity(0.6),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: backgroundColor),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   recommendation.title,
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               if (onLocationTap != null)
//                 IconButton(
//                   icon: const Icon(Icons.map, color: Colors.blue),
//                   tooltip: "지도에서 보기",
//                   onPressed: onLocationTap,
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),

//           // ✅ 전략에 따라 description 출력 방식 분기
//           recommendation.source == "openai"
//               ? Expanded(
//                   child: SingleChildScrollView(
//                     child: Text(
//                       recommendation.description,
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   ),
//                 )
//               : Text(
//                   recommendation.description,
//                   style: const TextStyle(fontSize: 14),
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                 ),

//           const SizedBox(height: 8),
//           if (distanceText != null)
//             Text("📍 거리: $distanceText", style: const TextStyle(fontSize: 13)),
//           if (reviewText != null)
//             Text("⭐️ $reviewText", style: const TextStyle(fontSize: 13)),
//           const Spacer(),
//           if (onReviewTap != null)
//             Align(
//               alignment: Alignment.bottomRight,
//               child: TextButton.icon(
//                 icon: const Icon(Icons.reviews, size: 18),
//                 label: const Text("리뷰 보기"),
//                 onPressed: onReviewTap,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../models/recommendation.dart';

class StrategyCard extends StatelessWidget {
  final Recommendation recommendation;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onLocationTap;
  final VoidCallback? onReviewTap;

  const StrategyCard({
    required this.recommendation,
    required this.icon,
    required this.backgroundColor,
    this.onLocationTap,
    this.onReviewTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final distanceText = recommendation.distance != null
        ? int.parse(recommendation.distance!) >= 1000
            ? "${(int.parse(recommendation.distance!) / 1000).toStringAsFixed(1)}km"
            : "${recommendation.distance}m"
        : null;

    final reviewText = recommendation.reviewCount != null
        ? "${recommendation.reviewCount}개 리뷰"
        : null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ 핵심: 높이 자동 조절
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: backgroundColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  recommendation.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onLocationTap != null)
                IconButton(
                  icon: const Icon(Icons.map, color: Colors.blue),
                  tooltip: "지도에서 보기",
                  onPressed: onLocationTap,
                ),
            ],
          ),
          const SizedBox(height: 8),

          // ✅ 전략에 따라 description 출력 방식 분기
          recommendation.source == "openai"
              ? Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      recommendation.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                )
              : Text(
                  recommendation.description,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

          const SizedBox(height: 8),
          if (distanceText != null)
            Text("📍 거리: $distanceText", style: const TextStyle(fontSize: 13)),
          if (reviewText != null)
            Text("⭐️ $reviewText", style: const TextStyle(fontSize: 13)),

          // ✅ Spacer 제거 → 텍스트가 공간을 확보할 수 있도록
          if (onReviewTap != null)
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                icon: const Icon(Icons.reviews, size: 18),
                label: const Text("리뷰 보기"),
                onPressed: onReviewTap,
              ),
            ),
        ],
      ),
    );
  }
}