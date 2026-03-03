import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/teacher_guide.dart';
import 'package:afc_studymate/data/services/app_bootstrap_service.dart';
import 'package:afc_studymate/features/bible/bible_screen.dart';
import 'package:afc_studymate/features/daybreak/daybreak_screen.dart';
import 'package:afc_studymate/features/discovery/discovery_archive_screen.dart';
import 'package:afc_studymate/features/discovery/discovery_screen.dart';
import 'package:afc_studymate/features/home/home_shell.dart';
import 'package:afc_studymate/features/journal/journal_screen.dart';
import 'package:afc_studymate/features/memory_verse/memory_verse_screen.dart';
import 'package:afc_studymate/features/onboarding/onboarding_screen.dart';
import 'package:afc_studymate/features/profile/profile_screen.dart';
import 'package:afc_studymate/features/settings/settings_screen.dart';
import 'package:afc_studymate/features/sunday_school/all_lessons/sunday_school_all_lessons_screen.dart';
import 'package:afc_studymate/features/sunday_school/all_lessons/sunday_school_lesson_detail_screen.dart';
import 'package:afc_studymate/features/sunday_school/class_roster_screen.dart';
import 'package:afc_studymate/features/sunday_school/search/lesson_search_screen.dart';
import 'package:afc_studymate/features/sunday_school/sunday_school_screen.dart';
import 'package:afc_studymate/features/sunday_school/teacher_guide_view.dart';
import 'package:afc_studymate/features/sunday_school/teacher_guides_screen.dart';
import 'package:afc_studymate/features/today/today_screen.dart';
import 'package:afc_studymate/widgets/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (
              context,
              state,
              shell,
            ) {
              return HomeShell(shell: shell);
            },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home/today',
                name: TodayScreen.routeName,
                pageBuilder: (context, state) =>
                    FadeTransitionPage(child: const TodayScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home/sunday-school',
                name: SundaySchoolScreen.routeName,
                pageBuilder: (context, state) =>
                    FadeTransitionPage(child: const SundaySchoolScreen()),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'all-lessons',
                    name: SundaySchoolAllLessonsScreen.routeName,
                    builder: (context, state) =>
                        const SundaySchoolAllLessonsScreen(),
                  ),
                  GoRoute(
                    path: 'lessons/:lessonId',
                    name: SundaySchoolLessonDetailScreen.routeName,
                    builder: (context, state) {
                      final lessonId = state.pathParameters['lessonId'];
                      if (lessonId == null) {
                        return const SundaySchoolAllLessonsScreen();
                      }
                      return SundaySchoolLessonDetailScreen(lessonId: lessonId);
                    },
                  ),
                  GoRoute(
                    path: 'teacher-guides',
                    name: TeacherGuidesScreen.routeName,
                    builder: (context, state) => const TeacherGuidesScreen(),
                  ),
                  GoRoute(
                    path: 'search',
                    name: LessonSearchScreen.routeName,
                    builder: (context, state) => const LessonSearchScreen(),
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
                pageBuilder: (context, state) =>
                    FadeTransitionPage(child: const JournalScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home/bible',
                name: BibleScreen.routeName,
                pageBuilder: (context, state) {
                  final params = state.uri.queryParameters;
                  final chapter = int.tryParse(params['chapter'] ?? '');
                  final verse = int.tryParse(params['verse'] ?? '');
                  final translationName = params['translation'];
                  Translation? translation;
                  for (final value in Translation.values) {
                    if (value.name == translationName) {
                      translation = value;
                      break;
                    }
                  }
                  return FadeTransitionPage(
                    child: BibleScreen(
                      initialBook: params['book'],
                      initialChapter: chapter,
                      highlightVerse: verse,
                      initialTranslation: translation,
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
                pageBuilder: (context, state) =>
                    FadeTransitionPage(child: const ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        name: SettingsScreen.routeName,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/daybreak/:date',
        name: DaybreakScreen.routeName,
        builder: (context, state) {
          final date =
              DateTime.tryParse(state.pathParameters['date'] ?? '') ??
              DateTime.now();
          return DaybreakScreen(date: date);
        },
      ),
      GoRoute(
        path: '/discovery',
        name: DiscoveryScreen.routeName,
        builder: (context, state) => DiscoveryScreen(
          lessonId: state.uri.queryParameters['lessonId'],
        ),
      ),
      GoRoute(
        path: '/discovery/archive',
        name: DiscoveryArchiveScreen.routeName,
        builder: (context, state) => const DiscoveryArchiveScreen(),
      ),
      GoRoute(
        path: '/memory-verses',
        name: MemoryVerseScreen.routeName,
        builder: (context, state) => const MemoryVerseScreen(),
      ),
      GoRoute(
        path: '/pdf-viewer',
        name: PdfViewerScreen.routeName,
        builder: (context, state) {
          final pdfPath = state.uri.queryParameters['path'] ?? '';
          final title = state.uri.queryParameters['title'];
          final pageStr = state.uri.queryParameters['page'];
          final initialPage = int.tryParse(pageStr ?? '');
          return PdfViewerScreen(
            pdfPath: pdfPath,
            title: title,
            initialPage: initialPage,
          );
        },
      ),
      GoRoute(
        path: '/teacher-guide',
        name: 'teacher-guide',
        builder: (context, state) {
          final guide = state.extra as TeacherGuide?;
          final title = state.uri.queryParameters['title'] ?? "Teacher's Guide";
          if (guide == null) {
            return const Scaffold(
              body: Center(child: Text('Error loading guide')),
            );
          }
          return TeacherGuideView(
            guide: guide,
            title: title,
          );
        },
      ),
      GoRoute(
        path: '/class-roster',
        name: ClassRosterScreen.routeName,
        builder: (context, state) => const ClassRosterScreen(),
      ),
    ],
  );
});

class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage({required super.child})
    : super(
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: animation,
              child: child,
            ),
      );
}
