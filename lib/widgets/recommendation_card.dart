import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recommendation.dart';


class RecommendationCard extends StatefulWidget {
  final Recommendation recommendation;
  const RecommendationCard({required this.recommendation, Key? key}) : super(key: key);

  @override
  State<RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<RecommendationCard> with TickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final rec = widget.recommendation;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  rec.imageUrl,
                  height: 100,
                  width: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, size: 100),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rec.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(rec.description, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 8),
                    if (_expanded) ...[
                      if (rec.distance.isNotEmpty)
                        Text("거리: ${rec.distance}m", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      if (rec.category.isNotEmpty)
                        Text("업종: ${rec.category}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      if (rec.phone.isNotEmpty)
                        Text("전화: ${rec.phone}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse(rec.placeUrl)),
                        child: const Text("지도 보기 →", style: TextStyle(color: Colors.blue, fontSize: 12)),
                      ),
                    ],
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => setState(() => _expanded = !_expanded),
                        child: Text(_expanded ? "간단히 보기" : "자세히 보기"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
