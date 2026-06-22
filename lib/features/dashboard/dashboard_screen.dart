import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../data/providers/app_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _dailyTip(double overall) {
    if (overall >= 80) {
      return "You're doing great! Keep walking or cycling for short trips to maintain your streak.";
    } else if (overall >= 50) {
      return 'Use public transport twice this week to save approximately 4kg CO₂.';
    } else {
      return 'Try switching one meat-based meal a week for a vegetarian option to cut your footprint.';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final eco = ref.watch(ecoScoreProvider);
    final activities = ref.watch(activitiesProvider);
    final notifier = ref.read(activitiesProvider.notifier);

    final today = notifier.totalEmissions(days: 1);
    final week = notifier.totalEmissions(days: 7);
    final month = notifier.totalEmissions(days: 30);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoDcf'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6_outlined),
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            EcoCard(
              onTap: () => context.go('/analytics/ecoscore'),
              child: Row(
                children: [
                  ScoreRing(score: eco.overall, size: 110),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Today's EcoScore", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(eco.level, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text('Tap to view full breakdown', style: TextStyle(color: AppColors.ecoBlue, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Carbon Summary'),
            Row(
              children: [
                Expanded(child: _summaryCard('Today', today)),
                const SizedBox(width: 12),
                Expanded(child: _summaryCard('This Week', week)),
                const SizedBox(width: 12),
                Expanded(child: _summaryCard('This Month', month)),
              ],
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Quick Actions'),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                QuickActionButton(emoji: '🚗', label: 'Travel', onTap: () => context.go('/track/travel')),
                QuickActionButton(emoji: '🍽', label: 'Food', onTap: () => context.go('/track/food')),
                QuickActionButton(emoji: '⚡', label: 'Energy', onTap: () => context.go('/track/energy')),
                QuickActionButton(emoji: '🗑', label: 'Waste', onTap: () => context.go('/track/waste')),
              ],
            ),
            const SizedBox(height: 16),
            EcoCard(
              child: Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${profile.ecoStreak} Days Green', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('Keep logging your activities daily!', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                  Text('${profile.xp} XP', style: const TextStyle(color: AppColors.ecoBlue, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            EcoCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Daily Tip', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(_dailyTip(eco.overall), style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (activities.isEmpty)
              const EmptyState(message: 'No activities logged yet.\nStart tracking to see your impact!'),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String label, double kg) {
    return EcoCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 6),
          Text('${kg.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.forestGreen)),
          const Text('kg CO₂e', style: TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
