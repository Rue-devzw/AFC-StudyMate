import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'data/services/app_bootstrap_service.dart';
import 'features/bible/bible_screen.dart';
import 'features/daybreak/daybreak_screen.dart';
import 'features/discovery/discovery_screen.dart';
import 'features/journal/journal_screen.dart';
import 'features/home/home_shell.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/sunday_school/all_lessons/sunday_school_all_lessons_screen.dart';
import 'features/sunday_school/all_lessons/sunday_school_lesson_detail_screen.dart';
import 'features/sunday_school/sunday_school_screen.dart';
import 'features/today/today_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final isFirstRun = ref.read(appBootstrapServiceProvider).isFirstRun;

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: isFirstRun ? '/onboarding' : '/home/today',
    routes: <RouteBase>[
      GoRoute(
        path: '/onboarding',
        name: OnboardingScreen.routeName,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage(
              child: OnboardingScreen(),
            ),
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell shell,
            ) {
              return HomeShell(shell: shell);
            },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home/today',
                name: TodayScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    FadeTransitionPage(child: TodayScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home/sunday-school',
                name: SundaySchoolScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    FadeTransitionPage(child: SundaySchoolScreen()),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'all-lessons',
                    name: SundaySchoolAllLessonsScreen.routeName,
                    builder: (BuildContext context, GoRouterState state) =>
                        const SundaySchoolAllLessonsScreen(),
                  ),
                  GoRoute(
                    path: 'lessons/:lessonId',
                    name: SundaySchoolLessonDetailScreen.routeName,
                    builder: (BuildContext context, GoRouterState state) {
                      final lessonId = state.pathParameters['lessonId'];
                      if (lessonId == null) {
                        return const SundaySchoolAllLessonsScreen();
                      }
                      return SundaySchoolLessonDetailScreen(lessonId: lessonId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home/journal',
                name: JournalScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    FadeTransitionPage(child: JournalScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home/bible',
                name: BibleScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final params = state.uri.queryParameters;
                  final chapter = int.tryParse(params['chapter'] ?? '');
                  final verse = int.tryParse(params['verse'] ?? '');
                  return FadeTransitionPage(
                    child: BibleScreen(
                      initialBook: params['book'],
                      initialChapter: chapter,
                      highlightVerse: verse,
                    ),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home/profile',
                name: ProfileScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    FadeTransitionPage(child: ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        name: SettingsScreen.routeName,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsScreen(),
      ),
      GoRoute(
        path: '/daybreak/:date',
        name: DaybreakScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final date =
              DateTime.tryParse(state.pathParameters['date'] ?? '') ??
              DateTime.now();
          return DaybreakScreen(date: date);
        },
      ),
      GoRoute(
        path: '/discovery',
        name: DiscoveryScreen.routeName,
        builder: (BuildContext context, GoRouterState state) =>
            const DiscoveryScreen(),
      ),
    ],
  );
});

class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage({required Widget child})
    : super(
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: animation,
              child: child,
            ),
      );
}
