import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../data/providers/app_providers.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  int householdSize = 1;
  String vehicleType = 'Car';
  String electricitySource = 'Grid';
  String dietType = 'Mixed';
  String recyclingFrequency = 'Sometimes';

  final vehicleOptions = const ['None', 'Bicycle', 'Motorbike', 'Car', 'Public Transport'];
  final electricityOptions = const ['Grid', 'Solar', 'Mixed'];
  final dietOptions = const ['Vegan', 'Vegetarian', 'Mixed', 'Meat Heavy'];
  final recyclingOptions = const ['Never', 'Sometimes', 'Often', 'Always'];

  Widget _chipGroup(String title, List<String> options, String selected, ValueChanged<String> onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((o) {
            final isSelected = o == selected;
            return ChoiceChip(
              label: Text(o),
              selected: isSelected,
              selectedColor: AppColors.leafGreen.withOpacity(0.25),
              labelStyle: TextStyle(color: isSelected ? AppColors.forestGreen : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              onSelected: (_) => onChange(o),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sustainability Profile')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Let's set up your profile to generate your initial EcoScore.",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    Text('Household', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => setState(() => householdSize = (householdSize - 1).clamp(1, 20)),
                        ),
                        Text('$householdSize ${householdSize == 1 ? "person" : "people"}', style: const TextStyle(fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setState(() => householdSize = (householdSize + 1).clamp(1, 20)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _chipGroup('Transport • Primary Vehicle', vehicleOptions, vehicleType, (v) => setState(() => vehicleType = v)),
                    _chipGroup('Energy • Electricity Source', electricityOptions, electricitySource, (v) => setState(() => electricitySource = v)),
                    _chipGroup('Diet', dietOptions, dietType, (v) => setState(() => dietType = v)),
                    _chipGroup('Waste • Recycling Frequency', recyclingOptions, recyclingFrequency, (v) => setState(() => recyclingFrequency = v)),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(profileProvider.notifier).completeOnboarding(
                          householdSize: householdSize,
                          vehicleType: vehicleType,
                          electricitySource: electricitySource,
                          dietType: dietType,
                          recyclingFrequency: recyclingFrequency,
                        );
                    context.go('/home');
                  },
                  child: const Text('Generate My EcoScore'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
