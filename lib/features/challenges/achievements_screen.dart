import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/app_providers.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: achievements.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, i) {
            final a = achievements[i];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: a.unlocked ? 1 : 0.25,
                      child: Text(a.icon, style: const TextStyle(fontSize: 48)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      a.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: a.unlocked ? AppColors.forestGreen : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      a.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    if (!a.unlocked)
                      const Icon(Icons.lock_outline, size: 16, color: Colors.grey)
                    else
                      const Icon(Icons.check_circle, size: 16, color: AppColors.leafGreen),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
