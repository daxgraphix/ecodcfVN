import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../core/calculations/emission_calculator.dart';
import '../../data/providers/app_providers.dart';

class _FoodOption {
  final String emoji;
  final String label;
  final String description;
  const _FoodOption(this.emoji, this.label, this.description);
}

const _foodOptions = [
  _FoodOption('🥗', 'Vegan', 'Plant-based, lowest impact'),
  _FoodOption('🌽', 'Vegetarian', 'No meat, includes dairy & eggs'),
  _FoodOption('🍗', 'Mixed', 'Balanced diet with some meat'),
  _FoodOption('🥩', 'Meat Heavy', 'Meat in most meals'),
];

class FoodScreen extends ConsumerStatefulWidget {
  const FoodScreen({super.key});

  @override
  ConsumerState<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends ConsumerState<FoodScreen> {
  late String selected;
  String wasteLevel = 'Medium';

  @override
  void initState() {
    super.initState();
    selected = ref.read(profileProvider).dietType;
  }

  @override
  Widget build(BuildContext context) {
    final monthly = EmissionCalculator.foodEmissions(selected, wasteLevel);
    final score = EmissionCalculator.scoreFromEmissions(monthly, 150);
    final entries = ref.watch(activitiesProvider).where((e) => e.category == 'food').toList().reversed.take(5).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Food')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SectionTitle(title: 'Diet Category'),
            ..._foodOptions.map((o) {
              final isSelected = o.label == selected;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: EcoCard(
                  onTap: () => setState(() => selected = o.label),
                  child: Row(
                    children: [
                      Text(o.emoji, style: const TextStyle(fontSize: 32)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(o.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(o.description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      if (isSelected) const Icon(Icons.check_circle, color: AppColors.leafGreen),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            const SectionTitle(title: 'Food Waste Level'),
            EcoCard(
              child: Row(
                children: ['Low', 'Medium', 'High'].map((level) {
                  final isSelected = wasteLevel == level;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => wasteLevel = level),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.leafGreen.withOpacity(0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? AppColors.forestGreen : Colors.grey.withOpacity(0.3)),
                        ),
                        child: Text(level, textAlign: TextAlign.center, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            EcoCard(
              child: Column(
                children: [
                  const Text('Food Impact Score', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(score.toStringAsFixed(0), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.forestGreen)),
                  const SizedBox(height: 4),
                  Text('${monthly.toStringAsFixed(1)} kg CO₂e estimated this month', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(activitiesProvider.notifier).addEntry(
                        category: 'food',
                        subtype: selected,
                        value: 1,
                        emissions: monthly,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Food log saved!')));
                },
                child: const Text('Log Today\'s Diet'),
              ),
            ),
            const SizedBox(height: 24),
            if (entries.isNotEmpty) ...[
              const SectionTitle(title: 'Recent Entries'),
              ...entries.map((e) => EcoCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(child: Text(e.subtype)),
                        Text('${e.emissions.toStringAsFixed(1)} kg', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
