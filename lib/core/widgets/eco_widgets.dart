import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ScoreRing extends StatelessWidget {
  final double score; // 0-100
  final double size;
  const ScoreRing({super.key, required this.score, this.size = 140});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: size * 0.08,
              backgroundColor: Colors.grey.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(
                score >= 70
                    ? AppColors.leafGreen
                    : score >= 40
                        ? AppColors.ecoBlue
                        : Colors.orange,
              ),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score.toStringAsFixed(0),
                style: TextStyle(fontSize: size * 0.26, fontWeight: FontWeight.bold, color: AppColors.forestGreen),
              ),
              Text('/ 100', style: TextStyle(fontSize: size * 0.1, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class EcoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  const EcoCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.margin = EdgeInsets.zero, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;
  const SectionTitle({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          if (trailing != null) Text(trailing!, style: const TextStyle(color: AppColors.ecoBlue, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;
  const QuickActionButton({super.key, required this.emoji, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return EcoCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String message;
  final String emoji;
  const EmptyState({super.key, required this.message, this.emoji = '🌱'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
