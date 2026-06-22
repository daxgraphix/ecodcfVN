import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../data/providers/app_providers.dart';

class EcoScoreScreen extends ConsumerWidget {
  const EcoScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eco = ref.watch(ecoScoreProvider);

    final levels = [
      {'emoji': '🌱', 'label': 'Beginner', 'min': 0},
      {'emoji': '🌿', 'label': 'Green Explorer', 'min': 50},
      {'emoji': '🌳', 'label': 'Eco Advocate', 'min': 70},
      {'emoji': '🌎', 'label': 'Sustainability Champion', 'min': 90},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('EcoScore')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(child: ScoreRing(score: eco.overall, size: 180)),
            const SizedBox(height: 12),
            Center(
              child: Text(eco.level, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.forestGreen)),
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Category Scores'),
            _categoryRow('🚗', 'Travel Score', eco.travelScore),
            _categoryRow('🍽', 'Food Score', eco.foodScore),
            _categoryRow('⚡', 'Energy Score', eco.energyScore),
            _categoryRow('🗑', 'Waste Score', eco.wasteScore),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Levels'),
            ...levels.map((l) {
              final isCurrent = eco.overall >= (l['min'] as int) &&
                  (levels.indexOf(l) == levels.length - 1 || eco.overall < (levels[levels.indexOf(l) + 1]['min'] as int));
              return EcoCard(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Text(l['emoji'] as String, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(l['label'] as String, style: TextStyle(fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal))),
                    Text('${l['min']}+', style: const TextStyle(color: Colors.grey)),
                    if (isCurrent) const Padding(padding: EdgeInsets.only(left: 8), child: Icon(Icons.check_circle, color: AppColors.leafGreen)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _categoryRow(String emoji, String label, double score) {
    return EcoCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          SizedBox(
            width: 120,
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: Colors.grey.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation(AppColors.leafGreen),
            ),
          ),
          const SizedBox(width: 8),
          Text(score.toStringAsFixed(0)),
        ],
      ),
    );
  }
}
