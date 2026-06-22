import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../data/providers/app_providers.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(challengesProvider);
    final notifier = ref.read(challengesProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Challenges')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: challenges.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final c = challenges[i];
            return EcoCard(
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.leafGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.eco, color: AppColors.forestGreen),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(c.description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('Reward: ${c.rewardXp} XP', style: const TextStyle(color: AppColors.ecoBlue, fontWeight: FontWeight.w600, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (c.completed)
                    const Icon(Icons.check_circle, color: AppColors.leafGreen)
                  else if (c.joined)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                      onPressed: () => notifier.complete(c),
                      child: const Text('Complete'),
                    )
                  else
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                      onPressed: () => notifier.join(c),
                      child: const Text('Join'),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
