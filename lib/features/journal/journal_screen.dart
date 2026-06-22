import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import '../../data/providers/app_providers.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(journalProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.forestGreen,
        onPressed: () => _showAddEntrySheet(context, ref),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: entries.isEmpty
            ? const EmptyState(message: 'No journal entries yet.\nReflect on your sustainability journey!', emoji: '📓')
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final e = entries[i];
                  return EcoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(e.action, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                            Text(DateFormat('MMM d, yyyy').format(e.date), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        if (e.note.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(e.note, style: const TextStyle(color: Colors.grey)),
                        ],
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () => ref.read(journalProvider.notifier).deleteEntry(e),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showAddEntrySheet(BuildContext context, WidgetRef ref) {
    final actionController = TextEditingController();
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('New Journal Entry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              TextField(
                controller: actionController,
                decoration: const InputDecoration(labelText: 'Eco Action', hintText: 'e.g. Biked to work'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notes / Reflection', hintText: 'How did it feel?'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (actionController.text.trim().isEmpty) return;
                    ref.read(journalProvider.notifier).addEntry(actionController.text.trim(), noteController.text.trim());
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save Entry'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
