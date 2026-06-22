import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../data/providers/app_providers.dart';
import '../../data/models/goal_item.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.forestGreen,
        onPressed: () => _showAddGoalSheet(context, ref),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: goals.isEmpty
            ? const EmptyState(message: 'No goals yet.\nSet a goal to start improving your impact!', emoji: '🎯')
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: goals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final g = goals[i];
                  return EcoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(g.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                            if (g.achieved) const Icon(Icons.emoji_events, color: Colors.amber)
                            else IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              onPressed: () => ref.read(goalsProvider.notifier).deleteGoal(g),
                            ),
                          ],
                        ),
                        Text('${g.category} • Target: reduce by ${g.targetPercent}%', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: g.progress,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: Colors.grey.withOpacity(0.15),
                          valueColor: AlwaysStoppedAnimation(g.achieved ? AppColors.leafGreen : AppColors.ecoBlue),
                        ),
                        const SizedBox(height: 4),
                        Text('${(g.progress * 100).toStringAsFixed(0)}% progress', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showAddGoalSheet(BuildContext context, WidgetRef ref) {
    String category = 'Travel';
    int target = 10;
    final titleControllers = {
      'Travel': 'Walk More / Use Less Car',
      'Food': 'Reduce Meat Consumption',
      'Energy': 'Use Less Electricity',
      'Waste': 'Recycle More',
      'Overall': 'Reduce Overall Footprint',
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('New Goal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),
                const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: titleControllers.keys.map((c) {
                    return ChoiceChip(
                      label: Text(c),
                      selected: category == c,
                      selectedColor: AppColors.leafGreen.withOpacity(0.25),
                      onSelected: (_) => setState(() => category = c),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Reduction Target', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [10, 20, 30].map((t) {
                    return ChoiceChip(
                      label: Text('$t%'),
                      selected: target == t,
                      selectedColor: AppColors.leafGreen.withOpacity(0.25),
                      onSelected: (_) => setState(() => target = t),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(goalsProvider.notifier).addGoal(titleControllers[category]!, category, target);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Create Goal'),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
