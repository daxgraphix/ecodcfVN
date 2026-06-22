import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../core/calculations/emission_calculator.dart';
import '../../data/providers/app_providers.dart';

class _WasteOption {
  final String emoji;
  final String label;
  const _WasteOption(this.emoji, this.label);
}

const _wasteOptions = [
  _WasteOption('🥤', 'Plastic'),
  _WasteOption('🍃', 'Organic'),
  _WasteOption('📄', 'Paper'),
  _WasteOption('🍾', 'Glass'),
  _WasteOption('🔌', 'E-waste'),
];

class WasteScreen extends ConsumerStatefulWidget {
  const WasteScreen({super.key});

  @override
  ConsumerState<WasteScreen> createState() => _WasteScreenState();
}

class _WasteScreenState extends ConsumerState<WasteScreen> {
  final Map<String, double> kgPerWeek = {
    'Plastic': 1.0,
    'Organic': 2.0,
    'Paper': 1.0,
    'Glass': 0.5,
    'E-waste': 0.1,
  };

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(activitiesProvider).where((e) => e.category == 'waste').toList().reversed.take(5).toList();

    double totalMonthly = 0;
    for (final o in _wasteOptions) {
      totalMonthly += EmissionCalculator.wasteEmissions(o.label, kgPerWeek[o.label] ?? 0);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Waste')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SectionTitle(title: 'Weekly Waste Segregation (kg)'),
            ..._wasteOptions.map((o) {
              final value = kgPerWeek[o.label]!;
              final emissions = EmissionCalculator.wasteEmissions(o.label, value);
              return EcoCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(o.emoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(o.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        const Spacer(),
                        Text('${value.toStringAsFixed(1)} kg/wk', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.forestGreen)),
                      ],
                    ),
                    Slider(
                      value: value,
                      min: 0,
                      max: 10,
                      activeColor: AppColors.forestGreen,
                      onChanged: (v) => setState(() => kgPerWeek[o.label] = v),
                    ),
                    Text('≈ ${emissions.toStringAsFixed(1)} kg CO₂e / month', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            EcoCard(
              child: Column(
                children: [
                  const Text('Total Waste Impact', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text('${totalMonthly.toStringAsFixed(1)} kg CO₂e / month', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.forestGreen)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(activitiesProvider.notifier).addEntry(
                        category: 'waste',
                        subtype: 'Weekly Segregation',
                        value: kgPerWeek.values.fold(0.0, (a, b) => a + b),
                        emissions: totalMonthly,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Waste data logged!')));
                },
                child: const Text('Log Waste Data'),
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
