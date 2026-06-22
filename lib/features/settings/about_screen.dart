import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Center(child: Text('🌍', style: TextStyle(fontSize: 72))),
            const SizedBox(height: 12),
            const Center(
              child: Text('EcoDcf 2.0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.forestGreen)),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Measure • Improve • Offset • Educate • Sustain', style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 20),
            const EcoCard(
              child: Text(
                'EcoDcf helps you understand your personal carbon footprint across travel, food, energy, and waste. '
                'Track your daily activities, get your personalized EcoScore, set sustainability goals, complete '
                'challenges, and learn through our offline Sustainability Academy.\n\n'
                'All your data is stored locally on your device for full privacy and offline access.',
                style: TextStyle(height: 1.5),
              ),
            ),
            const SizedBox(height: 16),
            const EcoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Version', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('2.0.0', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
