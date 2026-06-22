import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/profile_setup_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/tracking/travel_screen.dart';
import '../../features/tracking/food_screen.dart';
import '../../features/tracking/energy_screen.dart';
import '../../features/tracking/waste_screen.dart';
import '../../features/tracking/tracking_hub_screen.dart';
import '../../features/analytics/analytics_screen.dart';
import '../../features/analytics/impact_equivalency_screen.dart';
import '../../features/ecoscore/ecoscore_screen.dart';
import '../../features/goals/goals_screen.dart';
import '../../features/challenges/challenges_screen.dart';
import '../../features/challenges/achievements_screen.dart';
import '../../features/learning/learn_screen.dart';
import '../../features/learning/lesson_detail_screen.dart';
import '../../features/journal/journal_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/about_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
    GoRoute(path: '/profile-setup', builder: (c, s) => const ProfileSetupScreen()),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (c, s) => const DashboardScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/track', builder: (c, s) => const TrackingHubScreen(), routes: [
            GoRoute(path: 'travel', builder: (c, s) => const TravelScreen()),
            GoRoute(path: 'food', builder: (c, s) => const FoodScreen()),
            GoRoute(path: 'energy', builder: (c, s) => const EnergyScreen()),
            GoRoute(path: 'waste', builder: (c, s) => const WasteScreen()),
          ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/analytics', builder: (c, s) => const AnalyticsScreen(), routes: [
            GoRoute(path: 'impact', builder: (c, s) => const ImpactEquivalencyScreen()),
            GoRoute(path: 'ecoscore', builder: (c, s) => const EcoScoreScreen()),
          ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/learn', builder: (c, s) => const LearnScreen(), routes: [
            GoRoute(path: 'lesson/:id', builder: (c, s) => LessonDetailScreen(lessonId: s.pathParameters['id']!)),
          ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/profile', builder: (c, s) => const SettingsScreen(), routes: [
            GoRoute(path: 'goals', builder: (c, s) => const GoalsScreen()),
            GoRoute(path: 'challenges', builder: (c, s) => const ChallengesScreen()),
            GoRoute(path: 'achievements', builder: (c, s) => const AchievementsScreen()),
            GoRoute(path: 'journal', builder: (c, s) => const JournalScreen()),
            GoRoute(path: 'reports', builder: (c, s) => const ReportsScreen()),
            GoRoute(path: 'about', builder: (c, s) => const AboutScreen()),
          ]),
        ]),
      ],
    ),
  ],
);
