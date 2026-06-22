import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../data/providers/app_providers.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eco = ref.watch(ecoScoreProvider);
    final activities = ref.watch(activitiesProvider);
    final goals = ref.watch(goalsProvider);
    final achievements = ref.watch(achievementsProvider);
    final notifier = ref.read(activitiesProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            EcoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Report Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _row('EcoScore', eco.overall.toStringAsFixed(0)),
                  _row('Level', eco.level),
                  _row('Total Emissions (30d)', '${notifier.totalEmissions(days: 30).toStringAsFixed(1)} kg CO₂e'),
                  _row('Total Activities Logged', '${activities.length}'),
                  _row('Goals', '${goals.length}'),
                  _row('Achievements Unlocked', '${achievements.where((a) => a.unlocked).length} / ${achievements.length}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Export'),
            EcoCard(
              margin: const EdgeInsets.only(bottom: 12),
              onTap: () => _exportPdf(context, ref),
              child: const Row(
                children: [
                  Icon(Icons.picture_as_pdf_outlined, color: AppColors.forestGreen),
                  SizedBox(width: 12),
                  Expanded(child: Text('Export as PDF')),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
            EcoCard(
              margin: const EdgeInsets.only(bottom: 12),
              onTap: () => _exportCsv(context, ref),
              child: const Row(
                children: [
                  Icon(Icons.table_chart_outlined, color: AppColors.ecoBlue),
                  SizedBox(width: 12),
                  Expanded(child: Text('Export as CSV')),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
            EcoCard(
              onTap: () => _exportJson(context, ref),
              child: const Row(
                children: [
                  Icon(Icons.data_object_outlined, color: Colors.orange),
                  SizedBox(width: 12),
                  Expanded(child: Text('Export as JSON')),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Future<void> _exportPdf(BuildContext context, WidgetRef ref) async {
    final eco = ref.read(ecoScoreProvider);
    final activities = ref.read(activitiesProvider);
    final goals = ref.read(goalsProvider);
    final achievements = ref.read(achievementsProvider);

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('EcoDcf Sustainability Report')),
          pw.Text('Generated: ${DateFormat('MMM d, yyyy HH:mm').format(DateTime.now())}'),
          pw.SizedBox(height: 12),
          pw.Text('EcoScore: ${eco.overall.toStringAsFixed(0)} (${eco.level})'),
          pw.Text('Travel Score: ${eco.travelScore.toStringAsFixed(0)}'),
          pw.Text('Food Score: ${eco.foodScore.toStringAsFixed(0)}'),
          pw.Text('Energy Score: ${eco.energyScore.toStringAsFixed(0)}'),
          pw.Text('Waste Score: ${eco.wasteScore.toStringAsFixed(0)}'),
          pw.SizedBox(height: 16),
          pw.Header(level: 1, child: pw.Text('Goals')),
          ...goals.map((g) => pw.Text('- ${g.title} (${g.category}, target ${g.targetPercent}%, progress ${(g.progress * 100).toStringAsFixed(0)}%)')),
          pw.SizedBox(height: 16),
          pw.Header(level: 1, child: pw.Text('Achievements')),
          ...achievements.where((a) => a.unlocked).map((a) => pw.Text('- ${a.title}')),
          pw.SizedBox(height: 16),
          pw.Header(level: 1, child: pw.Text('Activity Log')),
          pw.TableHelper.fromTextArray(
            headers: ['Date', 'Category', 'Type', 'Emissions (kg CO2e)'],
            data: activities.map((e) => [
                  DateFormat('MMM d, yyyy').format(e.date),
                  e.category,
                  e.subtype,
                  e.emissions.toStringAsFixed(1),
                ]).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final activities = ref.read(activitiesProvider);
    final buffer = StringBuffer('Date,Category,Type,Value,Emissions(kgCO2e)\n');
    for (final e in activities) {
      buffer.writeln('${DateFormat('yyyy-MM-dd').format(e.date)},${e.category},${e.subtype},${e.value},${e.emissions.toStringAsFixed(2)}');
    }
    _showExportDialog(context, 'CSV Export', buffer.toString());
  }

  Future<void> _exportJson(BuildContext context, WidgetRef ref) async {
    final eco = ref.read(ecoScoreProvider);
    final activities = ref.read(activitiesProvider);
    final goals = ref.read(goalsProvider);
    final achievements = ref.read(achievementsProvider);

    final map = {
      'ecoScore': {
        'overall': eco.overall,
        'travel': eco.travelScore,
        'food': eco.foodScore,
        'energy': eco.energyScore,
        'waste': eco.wasteScore,
        'level': eco.level,
      },
      'activities': activities
          .map((e) => {
                'date': e.date.toIso8601String(),
                'category': e.category,
                'subtype': e.subtype,
                'value': e.value,
                'emissions': e.emissions,
              })
          .toList(),
      'goals': goals
          .map((g) => {
                'title': g.title,
                'category': g.category,
                'targetPercent': g.targetPercent,
                'progress': g.progress,
                'achieved': g.achieved,
              })
          .toList(),
      'achievements': achievements.map((a) => {'title': a.title, 'unlocked': a.unlocked}).toList(),
    };

    const encoder = JsonEncoder.withIndent('  ');
    _showExportDialog(context, 'JSON Export', encoder.convert(map));
  }

  void _showExportDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(content, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
      ),
    );
  }
}
