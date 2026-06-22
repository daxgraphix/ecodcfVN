import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../core/calculations/emission_calculator.dart';
import '../../data/providers/app_providers.dart';

class _TransportOption {
  final String emoji;
  final String label;
  const _TransportOption(this.emoji, this.label);
}

const _options = [
  _TransportOption('🚶', 'Walking'),
  _TransportOption('🚲', 'Bicycle'),
  _TransportOption('🚌', 'Bus'),
  _TransportOption('🚗', 'Car'),
  _TransportOption('✈', 'Flight'),
  _TransportOption('🚕', 'Ride Share'),
];

class TravelScreen extends ConsumerStatefulWidget {
  const TravelScreen({super.key});

  @override
  ConsumerState<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends ConsumerState<TravelScreen> {
  String selected = 'Car';
  double distance = 10;
  double frequency = 3;

  @override
  Widget build(BuildContext context) {
    final monthly = EmissionCalculator.travelEmissions(selected, distance, frequency);
    final entries = ref.watch(activitiesProvider).where((e) => e.category == 'travel').toList().reversed.take(5).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Travel')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SectionTitle(title: 'Transportation Type'),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.1,
              children: _options.map((o) {
                final isSelected = o.label == selected;
                return GestureDetector(
                  onTap: () => setState(() => selected = o.label),
                  child: Card(
                    color: isSelected ? AppColors.leafGreen.withOpacity(0.2) : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: isSelected ? AppColors.forestGreen : Colors.transparent, width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(o.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 4),
                        Text(o.label, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Distance per trip (km)'),
            EcoCard(
              child: Column(
                children: [
                  Text('${distance.toStringAsFixed(0)} km', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Slider(
                    value: distance,
                    min: 0,
                    max: 200,
                    divisions: 200,
                    activeColor: AppColors.forestGreen,
                    onChanged: (v) => setState(() => distance = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Frequency per week'),
            EcoCard(
              child: Column(
                children: [
                  Text('${frequency.toStringAsFixed(0)}x per week', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Slider(
                    value: frequency,
                    min: 0,
                    max: 14,
                    divisions: 14,
                    activeColor: AppColors.forestGreen,
                    onChanged: (v) => setState(() => frequency = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            EcoCard(
              child: Column(
                children: [
                  const Text('Estimated Monthly Emissions', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text('${monthly.toStringAsFixed(1)} kg CO₂e', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.forestGreen)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(activitiesProvider.notifier).addEntry(
                        category: 'travel',
                        subtype: selected,
                        value: distance,
                        emissions: monthly,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Travel activity logged!')));
                },
                child: const Text('Log Activity'),
              ),
            ),
            const SizedBox(height: 24),
            if (entries.isNotEmpty) ...[
              const SectionTitle(title: 'Recent Entries'),
              ...entries.map((e) => EcoCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(child: Text('${e.subtype} • ${e.value.toStringAsFixed(0)} km')),
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
