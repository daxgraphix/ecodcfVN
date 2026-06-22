import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import 'lessons_data.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sustainability Academy')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const EcoCard(
              child: Row(
                children: [
                  Icon(Icons.wifi_off, color: AppColors.ecoBlue),
                  SizedBox(width: 12),
                  Expanded(child: Text('All lessons are available offline.')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Categories'),
            ...lessons.map((l) => EcoCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  onTap: () => context.push('/learn/lesson/${l.id}'),
                  child: Row(
                    children: [
                      Text(l.emoji, style: const TextStyle(fontSize: 32)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(l.title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
