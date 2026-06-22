import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../core/calculations/emission_calculator.dart';
import '../../data/providers/app_providers.dart';

class ImpactEquivalencyScreen extends ConsumerWidget {
  const ImpactEquivalencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(activitiesProvider.notifier);
    ref.watch(activitiesProvider);
    final monthlyKg = notifier.totalEmissions(days: 30);

    final carKm = EmissionCalculator.equivalentCarKm(monthlyKg);
    final phoneCharges = EmissionCalculator.equivalentPhoneCharges(monthlyKg);
    final trees = EmissionCalculator.equivalentTrees(monthlyKg);

    return Scaffold(
      appBar: AppBar(title: const Text('Impact Equivalency')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            EcoCard(
              child: Column(
                children: [
                  const Text('Your last 30 days of emissions equal', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text('${monthlyKg.toStringAsFixed(1)} kg CO₂e', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.forestGreen)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _equivalencyCard('🚗', 'Driving a car', '${carKm.toStringAsFixed(0)} km'),
            _equivalencyCard('📱', 'Charging a phone', '${phoneCharges.toStringAsFixed(0)} times'),
            _equivalencyCard('🌳', 'Trees needed for a year to absorb this', '${trees.toStringAsFixed(1)} trees'),
            const SizedBox(height: 16),
            const EcoCard(
              child: Text(
                'This makes emissions understandable by translating abstract numbers into everyday actions. '
                'Reducing your monthly footprint by even 10% can mean planting fewer trees worth of carbon, or driving far less!',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _equivalencyCard(String emoji, String label, String value) {
    return EcoCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.forestGreen)),
        ],
      ),
    );
  }
}
