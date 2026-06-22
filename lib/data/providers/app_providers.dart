import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../local/hive_service.dart';
import '../models/user_profile.dart';
import '../models/activity_entry.dart';
import '../models/journal_entry.dart';
import '../models/goal_item.dart';
import '../models/challenge_achievement.dart';
import '../../core/calculations/emission_calculator.dart';

const _uuid = Uuid();

// ---------------- Theme ----------------
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  void toggle() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

// ---------------- Profile ----------------
class ProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    final box = HiveService.profileBox();
    if (box.isEmpty) {
      final p = UserProfile();
      box.add(p);
      return p;
    }
    return box.getAt(0)!;
  }

  void update(UserProfile Function(UserProfile current) updater) {
    final updated = updater(state);
    state = updated;
    final box = HiveService.profileBox();
    if (box.isEmpty) {
      box.add(updated);
    } else {
      box.putAt(0, updated);
    }
  }

  void completeOnboarding({
    required int householdSize,
    required String vehicleType,
    required String electricitySource,
    required String dietType,
    required String recyclingFrequency,
  }) {
    update((p) => UserProfile(
          householdSize: householdSize,
          vehicleType: vehicleType,
          electricitySource: electricitySource,
          dietType: dietType,
          recyclingFrequency: recyclingFrequency,
          onboarded: true,
          ecoStreak: p.ecoStreak,
          lastActiveDate: p.lastActiveDate,
          xp: p.xp,
        ));
  }

  void registerActivityToday() {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';
    if (state.lastActiveDate == todayStr) return;

    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayStr = '${yesterday.year}-${yesterday.month}-${yesterday.day}';

    int newStreak;
    if (state.lastActiveDate == yesterdayStr) {
      newStreak = state.ecoStreak + 1;
    } else {
      newStreak = 1;
    }

    update((p) => UserProfile(
          householdSize: p.householdSize,
          vehicleType: p.vehicleType,
          electricitySource: p.electricitySource,
          dietType: p.dietType,
          recyclingFrequency: p.recyclingFrequency,
          onboarded: p.onboarded,
          ecoStreak: newStreak,
          lastActiveDate: todayStr,
          xp: p.xp,
        ));
  }

  void addXp(int amount) {
    update((p) => UserProfile(
          householdSize: p.householdSize,
          vehicleType: p.vehicleType,
          electricitySource: p.electricitySource,
          dietType: p.dietType,
          recyclingFrequency: p.recyclingFrequency,
          onboarded: p.onboarded,
          ecoStreak: p.ecoStreak,
          lastActiveDate: p.lastActiveDate,
          xp: p.xp + amount,
        ));
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserProfile>(ProfileNotifier.new);

// ---------------- Activities ----------------
class ActivitiesNotifier extends Notifier<List<ActivityEntry>> {
  @override
  List<ActivityEntry> build() {
    return HiveService.activityBox().values.toList();
  }

  void _refresh() {
    state = HiveService.activityBox().values.toList();
  }

  void addEntry({
    required String category,
    required String subtype,
    required double value,
    required double emissions,
  }) {
    final entry = ActivityEntry(
      id: _uuid.v4(),
      category: category,
      subtype: subtype,
      value: value,
      emissions: emissions,
      date: DateTime.now(),
    );
    HiveService.activityBox().add(entry);
    _refresh();
    ref.read(profileProvider.notifier).registerActivityToday();
    ref.read(achievementsProvider.notifier).evaluateAchievements();
    ref.read(goalsProvider.notifier).evaluateGoals();
  }

  List<ActivityEntry> forCategory(String category) =>
      state.where((e) => e.category == category).toList();

  double totalEmissions({String? category, int? days}) {
    var items = state;
    if (category != null) {
      items = items.where((e) => e.category == category).toList();
    }
    if (days != null) {
      final cutoff = DateTime.now().subtract(Duration(days: days));
      items = items.where((e) => e.date.isAfter(cutoff)).toList();
    }
    return items.fold(0.0, (sum, e) => sum + e.emissions);
  }
}

final activitiesProvider = NotifierProvider<ActivitiesNotifier, List<ActivityEntry>>(ActivitiesNotifier.new);

// ---------------- EcoScore ----------------
class EcoScoreData {
  final double travelScore;
  final double foodScore;
  final double energyScore;
  final double wasteScore;
  final double overall;
  final String level;

  EcoScoreData({
    required this.travelScore,
    required this.foodScore,
    required this.energyScore,
    required this.wasteScore,
    required this.overall,
    required this.level,
  });
}

final ecoScoreProvider = Provider<EcoScoreData>((ref) {
  final activities = ref.watch(activitiesProvider);

  double monthlyFor(String category) {
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    return activities
        .where((e) => e.category == category && e.date.isAfter(cutoff))
        .fold(0.0, (sum, e) => sum + e.emissions);
  }

  // Baselines represent an "average" footprint per category per month (kg CO2e)
  const baselines = {
    'travel': 120.0,
    'food': 150.0,
    'energy': 100.0,
    'waste': 40.0,
  };

  final travelScore = EmissionCalculator.scoreFromEmissions(monthlyFor('travel'), baselines['travel']!);
  final foodScore = EmissionCalculator.scoreFromEmissions(monthlyFor('food'), baselines['food']!);
  final energyScore = EmissionCalculator.scoreFromEmissions(monthlyFor('energy'), baselines['energy']!);
  final wasteScore = EmissionCalculator.scoreFromEmissions(monthlyFor('waste'), baselines['waste']!);

  final overall = (travelScore + foodScore + energyScore + wasteScore) / 4;

  String level;
  if (overall >= 90) {
    level = '🌎 Sustainability Champion';
  } else if (overall >= 70) {
    level = '🌳 Eco Advocate';
  } else if (overall >= 50) {
    level = '🌿 Green Explorer';
  } else {
    level = '🌱 Beginner';
  }

  return EcoScoreData(
    travelScore: travelScore,
    foodScore: foodScore,
    energyScore: energyScore,
    wasteScore: wasteScore,
    overall: overall,
    level: level,
  );
});

// ---------------- Journal ----------------
class JournalNotifier extends Notifier<List<JournalEntry>> {
  @override
  List<JournalEntry> build() => HiveService.journalBox().values.toList().reversed.toList();

  void addEntry(String action, String note) {
    final entry = JournalEntry(id: _uuid.v4(), date: DateTime.now(), action: action, note: note);
    HiveService.journalBox().add(entry);
    state = HiveService.journalBox().values.toList().reversed.toList();
  }

  void deleteEntry(JournalEntry entry) {
    entry.delete();
    state = HiveService.journalBox().values.toList().reversed.toList();
  }
}

final journalProvider = NotifierProvider<JournalNotifier, List<JournalEntry>>(JournalNotifier.new);

// ---------------- Goals ----------------
class GoalsNotifier extends Notifier<List<GoalItem>> {
  @override
  List<GoalItem> build() => HiveService.goalBox().values.toList();

  void _refresh() => state = HiveService.goalBox().values.toList();

  void addGoal(String title, String category, int targetPercent) {
    final goal = GoalItem(
      id: _uuid.v4(),
      title: title,
      category: category,
      targetPercent: targetPercent,
      createdAt: DateTime.now(),
    );
    HiveService.goalBox().add(goal);
    _refresh();
  }

  void deleteGoal(GoalItem goal) {
    goal.delete();
    _refresh();
  }

  void evaluateGoals() {
    final eco = ref.read(ecoScoreProvider);
    for (final goal in HiveService.goalBox().values) {
      double score;
      switch (goal.category) {
        case 'Travel':
          score = eco.travelScore;
          break;
        case 'Food':
          score = eco.foodScore;
          break;
        case 'Energy':
          score = eco.energyScore;
          break;
        case 'Waste':
          score = eco.wasteScore;
          break;
        default:
          score = eco.overall;
      }
      final progress = (score / 100).clamp(0.0, 1.0);
      goal.progress = progress;
      goal.achieved = progress * 100 >= goal.targetPercent + 50; // arbitrary completion heuristic
      goal.save();
    }
    _refresh();
  }
}

final goalsProvider = NotifierProvider<GoalsNotifier, List<GoalItem>>(GoalsNotifier.new);

// ---------------- Challenges ----------------
class ChallengesNotifier extends Notifier<List<ChallengeItem>> {
  @override
  List<ChallengeItem> build() => HiveService.challengeBox().values.toList();

  void _refresh() => state = HiveService.challengeBox().values.toList();

  void join(ChallengeItem item) {
    item.joined = true;
    item.save();
    _refresh();
  }

  void complete(ChallengeItem item) {
    if (item.completed) return;
    item.completed = true;
    item.save();
    ref.read(profileProvider.notifier).addXp(item.rewardXp);
    _refresh();
  }
}

final challengesProvider = NotifierProvider<ChallengesNotifier, List<ChallengeItem>>(ChallengesNotifier.new);

// ---------------- Achievements ----------------
class AchievementsNotifier extends Notifier<List<AchievementItem>> {
  @override
  List<AchievementItem> build() => HiveService.achievementBox().values.toList();

  void _refresh() => state = HiveService.achievementBox().values.toList();

  void evaluateAchievements() {
    final activities = HiveService.activityBox().values.toList();
    final eco = ref.read(ecoScoreProvider);

    void unlock(String id) {
      final item = HiveService.achievementBox().values.firstWhere((a) => a.id == id, orElse: () => AchievementItem(id: '', title: '', icon: '', description: ''));
      if (item.id.isEmpty || item.unlocked) return;
      item.unlocked = true;
      item.save();
    }

    if (activities.isNotEmpty) unlock('a1');
    if (activities.where((a) => a.category == 'waste').length >= 10) unlock('a2');
    if (activities.where((a) => a.category == 'travel' && ['Walking', 'Bicycle', 'Bus'].contains(a.subtype)).length >= 10) unlock('a3');
    if (eco.energyScore >= 70) unlock('a4');
    final totalOffset = activities.fold(0.0, (s, a) => s + (a.category == 'waste' || a.category == 'energy' ? 0 : 0));
    if (totalOffset >= 100) unlock('a5');
    if (eco.overall >= 90) unlock('a6');

    _refresh();
  }
}

final achievementsProvider = NotifierProvider<AchievementsNotifier, List<AchievementItem>>(AchievementsNotifier.new);
