import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/bible/bible_screen.dart';
import 'features/daybreak/daybreak_screen.dart';
import 'features/discovery/discovery_screen.dart';
import 'features/home/home_shell.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/sunday_school/sunday_school_screen.dart';
import 'features/today/today_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/onboarding',
    routes: <RouteBase>[
      GoRoute(
        path: '/onboarding',
        name: OnboardingScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingScreen();
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state, StatefulNavigationShell shell) {
          return HomeShell(shell: shell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home/today',
                name: TodayScreen.routeName,
                builder: (BuildContext context, GoRouterState state) => const TodayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home/sunday-school',
                name: SundaySchoolScreen.routeName,
                builder: (BuildContext context, GoRouterState state) => const SundaySchoolScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home/discovery',
                name: DiscoveryScreen.routeName,
                builder: (BuildContext context, GoRouterState state) => const DiscoveryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home/bible',
                name: BibleScreen.routeName,
                builder: (BuildContext context, GoRouterState state) => const BibleScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home/profile',
                name: ProfileScreen.routeName,
                builder: (BuildContext context, GoRouterState state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        name: SettingsScreen.routeName,
        builder: (BuildContext context, GoRouterState state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/daybreak/:date',
        name: DaybreakScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final date = DateTime.tryParse(state.pathParameters['date'] ?? '') ?? DateTime.now();
          return DaybreakScreen(date: date);
        },
      ),
    ],
  );
});
