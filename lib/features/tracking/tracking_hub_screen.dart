import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../data/providers/app_providers.dart';

class TrackingHubScreen extends ConsumerWidget {
  const TrackingHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(activitiesProvider.notifier);
    ref.watch(activitiesProvider);

    final categories = [
      {'emoji': '🚗', 'title': 'Travel', 'route': '/track/travel', 'category': 'travel'},
      {'emoji': '🍽', 'title': 'Food', 'route': '/track/food', 'category': 'food'},
      {'emoji': '⚡', 'title': 'Energy', 'route': '/track/energy', 'category': 'energy'},
      {'emoji': '🗑', 'title': 'Waste', 'route': '/track/waste', 'category': 'waste'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Track Activities')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final c = categories[i];
            final monthly = notifier.totalEmissions(category: c['category'] as String, days: 30);
            return EcoCard(
              onTap: () => context.push(c['route'] as String),
              child: Row(
                children: [
                  Text(c['emoji'] as String, style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Text('${monthly.toStringAsFixed(1)} kg CO₂e this month', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
