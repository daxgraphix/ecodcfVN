# EcoDcf 2.0 🌍

Measure • Improve • Offset • Educate • Sustain

A fully offline-first Flutter app for tracking your personal carbon footprint across
**Travel, Food, Energy and Waste**, with an EcoScore, Goals, Challenges, Achievements,
an offline Sustainability Academy, a Journal, and exportable Reports.

## Tech Stack

- **Flutter 3.35+**
- **Riverpod** (`flutter_riverpod`) for state management
- **Hive** for offline local storage (manual TypeAdapters, no codegen required)
- **go_router** with `StatefulShellRoute` for bottom-navigation routing
- **fl_chart** for analytics (line + pie charts)
- **pdf** / **printing** for PDF report export
- **intl** for date formatting

## Getting Started

This zip contains the `lib/` source, `pubspec.yaml`, and `analysis_options.yaml`.
To run it as a full Flutter project:

```bash
# 1. Unzip into a folder, then inside that folder run:
flutter create . --platforms=android,ios

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

`flutter create .` will generate the missing platform folders
(`android/`, `ios/`, `web/`, etc.) without overwriting `lib/` or `pubspec.yaml`.

## Project Structure

```
lib/
├── core/
│   ├── theme/             # AppTheme, colors (Forest Green, Leaf Green, Eco Blue...)
│   ├── widgets/            # EcoCard, ScoreRing, SectionTitle, QuickActionButton...
│   ├── calculations/        # EmissionCalculator - all emission factor math
│   └── router/              # go_router config + bottom nav shell routes
│
├── data/
│   ├── models/              # Hive models: UserProfile, ActivityEntry, JournalEntry,
│   │                         # GoalItem, ChallengeItem, AchievementItem
│   ├── local/                # HiveService - box registration & seeding
│   └── providers/            # Riverpod Notifiers: profile, activities, ecoScore,
│                              # goals, challenges, achievements, journal, theme
│
├── features/
│   ├── onboarding/           # Splash, Onboarding slides, Sustainability Profile Setup
│   ├── shell/                # MainShell (bottom navigation: Home/Track/Analytics/Learn/Profile)
│   ├── dashboard/             # Home Dashboard (EcoScore ring, summary, quick actions, streak, tip)
│   ├── tracking/               # Tracking hub + Travel/Food/Energy/Waste screens
│   ├── analytics/               # Analytics (charts) + Impact Equivalency
│   ├── ecoscore/                 # EcoScore breakdown & levels
│   ├── goals/                     # Goals screen (create/track reduction goals)
│   ├── challenges/                 # Challenges + Achievements
│   ├── learning/                    # Sustainability Academy + Lesson detail + Quiz
│   ├── journal/                      # Daily sustainability diary
│   ├── reports/                       # PDF / CSV / JSON export
│   └── settings/                       # Profile/Settings + About
│
└── main.dart
```

## App Flow

Splash → Onboarding → Sustainability Profile Setup → Home Dashboard
→ (Track Activities | Analytics | Goals | Challenges | Education Hub | Achievements)

## Notes

- All data is stored **locally via Hive** — fully offline, no backend required.
- The EcoScore is computed from the last 30 days of logged activity emissions
  versus reference baselines per category (Travel, Food, Energy, Waste).
- Emission factors used in `EmissionCalculator` are illustrative averages for
  educational purposes.
