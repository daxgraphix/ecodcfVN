import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/eco_widgets.dart';
import 'lessons_data.dart';

class LessonDetailScreen extends StatefulWidget {
  final String lessonId;
  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool showQuiz = false;
  final Map<int, int?> answers = {};
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    final lesson = lessons.firstWhere((l) => l.id == widget.lessonId, orElse: () => lessons.first);

    int score = 0;
    if (submitted) {
      for (int i = 0; i < lesson.quiz.length; i++) {
        if (answers[i] == lesson.quiz[i].correctIndex) score++;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(lesson.category)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(child: Text(lesson.emoji, style: const TextStyle(fontSize: 64))),
            const SizedBox(height: 12),
            Text(lesson.title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            if (!showQuiz) ...[
              EcoCard(child: Text(lesson.content, style: const TextStyle(fontSize: 15, height: 1.5))),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() => showQuiz = true),
                  child: const Text('Take the Quiz'),
                ),
              ),
            ] else ...[
              ...lesson.quiz.asMap().entries.map((entry) {
                final i = entry.key;
                final q = entry.value;
                return EcoCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${i + 1}. ${q.question}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...q.options.asMap().entries.map((opt) {
                        final j = opt.key;
                        final isSelected = answers[i] == j;
                        Color? color;
                        if (submitted) {
                          if (j == q.correctIndex) {
                            color = AppColors.leafGreen.withOpacity(0.3);
                          } else if (isSelected) {
                            color = Colors.red.withOpacity(0.2);
                          }
                        } else if (isSelected) {
                          color = AppColors.leafGreen.withOpacity(0.15);
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: GestureDetector(
                            onTap: submitted ? null : () => setState(() => answers[i] = j),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                              ),
                              child: Text(opt.value),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
              if (!submitted)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: answers.length == lesson.quiz.length ? () => setState(() => submitted = true) : null,
                    child: const Text('Submit Quiz'),
                  ),
                )
              else
                EcoCard(
                  child: Column(
                    children: [
                      Text('You scored $score / ${lesson.quiz.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.forestGreen)),
                      const SizedBox(height: 8),
                      Text(score == lesson.quiz.length ? 'Perfect score! 🎉' : 'Review the lesson and try again anytime.', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
