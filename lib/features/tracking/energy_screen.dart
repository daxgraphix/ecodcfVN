import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../core/calculations/emission_calculator.dart';
import '../../data/providers/app_providers.dart';

class EnergyScreen extends ConsumerStatefulWidget {
  const EnergyScreen({super.key});

  @override
  ConsumerState<EnergyScreen> createState() => _EnergyScreenState();
}

class _EnergyScreenState extends ConsumerState<EnergyScreen> {
  double electricity = 150;
  bool solar = false;
  double cookingGas = 10;
  double charcoal = 0;
  double firewood = 0;

  Widget _inputCard({required String emoji, required String label, required String unit, required double value, required double max, required ValueChanged<double> onChanged}) {
    return EcoCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const Spacer(),
              Text('${value.toStringAsFixed(0)} $unit', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.forestGreen)),
            ],
          ),
          Slider(
            value: value,
            min: 0,
            max: max,
            activeColor: AppColors.forestGreen,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthly = EmissionCalculator.energyEmissions(
      electricityKwh: electricity,
      solar: solar,
      cookingGasKg: cookingGas,
      charcoalKg: charcoal,
      firewoodKg: firewood,
    );
    final entries = ref.watch(activitiesProvider).where((e) => e.category == 'energy').toList().reversed.take(5).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Energy')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            EcoCard(
              child: Column(
                children: [
                  const Text('🏠', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 8),
                  const Text('Tell us about your home energy use', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            EcoCard(
              margin: const EdgeInsets.only(bottom: 12),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('☀️ My electricity is from solar', style: TextStyle(fontWeight: FontWeight.w600)),
                value: solar,
                activeColor: AppColors.forestGreen,
                onChanged: (v) => setState(() => solar = v),
              ),
            ),
            _inputCard(emoji: '🔌', label: 'Electricity', unit: 'kWh/mo', value: electricity, max: 600, onChanged: (v) => setState(() => electricity = v)),
            _inputCard(emoji: '🔥', label: 'Cooking Gas (LPG)', unit: 'kg/mo', value: cookingGas, max: 50, onChanged: (v) => setState(() => cookingGas = v)),
            _inputCard(emoji: '⚫', label: 'Charcoal', unit: 'kg/mo', value: charcoal, max: 50, onChanged: (v) => setState(() => charcoal = v)),
            _inputCard(emoji: '🪵', label: 'Firewood', unit: 'kg/mo', value: firewood, max: 50, onChanged: (v) => setState(() => firewood = v)),
            const SizedBox(height: 8),
            EcoCard(
              child: Column(
                children: [
                  const Text('Energy Carbon Impact', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text('${monthly.toStringAsFixed(1)} kg CO₂e / month', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.forestGreen)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(activitiesProvider.notifier).addEntry(
                        category: 'energy',
                        subtype: solar ? 'Solar Mix' : 'Grid Mix',
                        value: electricity,
                        emissions: monthly,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Energy usage logged!')));
                },
                child: const Text('Log Energy Usage'),
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
