import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../data/providers/app_providers.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  String range = 'Weekly';

  @override
  Widget build(BuildContext context) {
    final activities = ref.watch(activitiesProvider);
    final notifier = ref.read(activitiesProvider.notifier);

    final travel = notifier.totalEmissions(category: 'travel', days: 30);
    final food = notifier.totalEmissions(category: 'food', days: 30);
    final energy = notifier.totalEmissions(category: 'energy', days: 30);
    final waste = notifier.totalEmissions(category: 'waste', days: 30);
    final total = travel + food + energy + waste;

    final pieData = <_PieSlice>[
      _PieSlice('Travel', travel, AppColors.forestGreen),
      _PieSlice('Food', food, AppColors.leafGreen),
      _PieSlice('Energy', energy, AppColors.ecoBlue),
      _PieSlice('Waste', waste, Colors.orange),
    ];

    final days = range == 'Weekly' ? 7 : (range == 'Monthly' ? 30 : (range == 'Daily' ? 1 : 365));
    final trend = _buildTrend(activities, days);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: EcoCard(
                    onTap: () => context.push('/analytics/ecoscore'),
                    child: const Row(
                      children: [
                        Text('🏆', style: TextStyle(fontSize: 28)),
                        SizedBox(width: 8),
                        Expanded(child: Text('EcoScore Breakdown', style: TextStyle(fontWeight: FontWeight.w600))),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: EcoCard(
                    onTap: () => context.push('/analytics/impact'),
                    child: const Row(
                      children: [
                        Text('🌳', style: TextStyle(fontSize: 28)),
                        SizedBox(width: 8),
                        Expanded(child: Text('Impact Equivalency', style: TextStyle(fontWeight: FontWeight.w600))),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Carbon Overview'),
            Wrap(
              spacing: 8,
              children: ['Daily', 'Weekly', 'Monthly', 'Yearly'].map((r) {
                final isSelected = r == range;
                return ChoiceChip(
                  label: Text(r),
                  selected: isSelected,
                  selectedColor: AppColors.leafGreen.withOpacity(0.25),
                  onSelected: (_) => setState(() => range = r),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            EcoCard(
              child: SizedBox(
                height: 220,
                child: trend.every((e) => e == 0)
                    ? const Center(child: Text('No data yet for this range', style: TextStyle(color: Colors.grey)))
                    : LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [for (int i = 0; i < trend.length; i++) FlSpot(i.toDouble(), trend[i])],
                              isCurved: true,
                              color: AppColors.forestGreen,
                              barWidth: 3,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(show: true, color: AppColors.leafGreen.withOpacity(0.15)),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Emission Breakdown (30 days)'),
            EcoCard(
              child: total == 0
                  ? const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Log activities to see your breakdown', style: TextStyle(color: Colors.grey))))
                  : Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: pieData.where((p) => p.value > 0).map((p) {
                                return PieChartSectionData(
                                  value: p.value,
                                  title: '${(p.value / total * 100).toStringAsFixed(0)}%',
                                  color: p.color,
                                  radius: 70,
                                  titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                );
                              }).toList(),
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: pieData.map((p) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(width: 12, height: 12, decoration: BoxDecoration(color: p.color, shape: BoxShape.circle)),
                                const SizedBox(width: 6),
                                Text('${p.label} ${p.value.toStringAsFixed(0)}kg'),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Reduction Trend'),
            EcoCard(
              child: trend.length < 2 || trend.every((e) => e == 0)
                  ? const Padding(padding: EdgeInsets.all(24), child: Text('Keep logging to see your trend over time.', style: TextStyle(color: Colors.grey)))
                  : Text(
                      trend.last <= trend.first
                          ? "Great job! Your emissions are trending downward. 📉"
                          : "Your emissions are trending upward — check your tips for ways to reduce. 📈",
                      style: const TextStyle(color: Colors.grey),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<double> _buildTrend(List activities, int days) {
    final now = DateTime.now();
    final buckets = <double>[];
    final bucketCount = days <= 1 ? 6 : (days <= 7 ? 7 : (days <= 30 ? 10 : 12));
    final bucketDays = (days / bucketCount).ceil().clamp(1, days);

    for (int i = bucketCount - 1; i >= 0; i--) {
      final end = now.subtract(Duration(days: i * bucketDays));
      final start = end.subtract(Duration(days: bucketDays));
      double sum = 0;
      for (final a in activities) {
        if (a.date.isAfter(start) && a.date.isBefore(end.add(const Duration(seconds: 1)))) {
          sum += a.emissions as double;
        }
      }
      buckets.add(sum);
    }
    return buckets;
  }
}

class _PieSlice {
  final String label;
  final double value;
  final Color color;
  _PieSlice(this.label, this.value, this.color);
}
