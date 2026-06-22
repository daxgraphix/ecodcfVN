import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../data/providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final themeMode = ref.watch(themeModeProvider);
    final eco = ref.watch(ecoScoreProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            EcoCard(
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(color: AppColors.leafGreen.withOpacity(0.2), shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const Text('🌱', style: TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(eco.level, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('EcoScore: ${eco.overall.toStringAsFixed(0)} • ${profile.xp} XP', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Household Profile'),
            EcoCard(
              child: Column(
                children: [
                  _infoRow('Household Size', '${profile.householdSize}'),
                  _infoRow('Vehicle Type', profile.vehicleType),
                  _infoRow('Electricity Source', profile.electricitySource),
                  _infoRow('Diet', profile.dietType),
                  _infoRow('Recycling Frequency', profile.recyclingFrequency),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Engagement'),
            _navTile(context, '🎯', 'Goals', () => context.push('/profile/goals')),
            _navTile(context, '🏆', 'Challenges', () => context.push('/profile/challenges')),
            _navTile(context, '🥇', 'Achievements', () => context.push('/profile/achievements')),
            _navTile(context, '📓', 'Journal', () => context.push('/profile/journal')),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Utility'),
            _navTile(context, '📄', 'Reports', () => context.push('/profile/reports')),
            EcoCard(
              margin: const EdgeInsets.only(bottom: 12),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Dark Mode'),
                value: themeMode == ThemeMode.dark,
                activeColor: AppColors.forestGreen,
                onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
              ),
            ),
            _navTile(context, 'ℹ️', 'About EcoDcf', () => context.push('/profile/about')),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _navTile(BuildContext context, String emoji, String label, VoidCallback onTap) {
    return EcoCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onTap,
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
