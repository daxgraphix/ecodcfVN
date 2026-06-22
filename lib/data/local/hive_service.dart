import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';
import '../models/activity_entry.dart';
import '../models/journal_entry.dart';
import '../models/goal_item.dart';
import '../models/challenge_achievement.dart';

class HiveService {
  static const profileBoxName = 'profile_box';
  static const activityBoxName = 'activity_box';
  static const journalBoxName = 'journal_box';
  static const goalBoxName = 'goal_box';
  static const challengeBoxName = 'challenge_box';
  static const achievementBoxName = 'achievement_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(ActivityEntryAdapter());
    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(GoalItemAdapter());
    Hive.registerAdapter(ChallengeItemAdapter());
    Hive.registerAdapter(AchievementItemAdapter());

    await Hive.openBox<UserProfile>(profileBoxName);
    await Hive.openBox<ActivityEntry>(activityBoxName);
    await Hive.openBox<JournalEntry>(journalBoxName);
    await Hive.openBox<GoalItem>(goalBoxName);
    await Hive.openBox<ChallengeItem>(challengeBoxName);
    await Hive.openBox<AchievementItem>(achievementBoxName);

    await _seedDefaults();
  }

  static Future<void> _seedDefaults() async {
    final challengeBox = Hive.box<ChallengeItem>(challengeBoxName);
    if (challengeBox.isEmpty) {
      challengeBox.addAll([
        ChallengeItem(id: 'c1', title: 'Plastic Free Week', description: 'Avoid single-use plastic for 7 days.', rewardXp: 100),
        ChallengeItem(id: 'c2', title: 'Green Commute', description: 'Use eco-friendly transport for 5 trips.', rewardXp: 150),
        ChallengeItem(id: 'c3', title: 'Energy Saver', description: 'Reduce electricity usage by 15% this week.', rewardXp: 200),
        ChallengeItem(id: 'c4', title: 'Zero Waste Weekend', description: 'Produce zero non-recyclable waste for a weekend.', rewardXp: 300),
      ]);
    }

    final achievementBox = Hive.box<AchievementItem>(achievementBoxName);
    if (achievementBox.isEmpty) {
      achievementBox.addAll([
        AchievementItem(id: 'a1', title: 'First Footprint', icon: '🌱', description: 'Logged your first activity.'),
        AchievementItem(id: 'a2', title: 'Recycling Hero', icon: '♻️', description: 'Logged recycling 10 times.'),
        AchievementItem(id: 'a3', title: 'Green Commuter', icon: '🚲', description: 'Used green transport 10 times.'),
        AchievementItem(id: 'a4', title: 'Energy Saver', icon: '⚡', description: 'Reduced energy emissions.'),
        AchievementItem(id: 'a5', title: 'Tree Protector', icon: '🌳', description: 'Offset 100kg of CO2e.'),
        AchievementItem(id: 'a6', title: 'Climate Champion', icon: '🌍', description: 'Reached EcoScore of 90+.'),
      ]);
    }
  }

  static Box<UserProfile> profileBox() => Hive.box<UserProfile>(profileBoxName);
  static Box<ActivityEntry> activityBox() => Hive.box<ActivityEntry>(activityBoxName);
  static Box<JournalEntry> journalBox() => Hive.box<JournalEntry>(journalBoxName);
  static Box<GoalItem> goalBox() => Hive.box<GoalItem>(goalBoxName);
  static Box<ChallengeItem> challengeBox() => Hive.box<ChallengeItem>(challengeBoxName);
  static Box<AchievementItem> achievementBox() => Hive.box<AchievementItem>(achievementBoxName);
}
