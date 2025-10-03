import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

import '../data/accounts/account_repository_impl.dart';
import '../data/bible/annotation_repository_impl.dart';
import '../data/bible/bible_repository_impl.dart';
import '../data/bible/reading_progress_repository_impl.dart';
import '../data/chat/chat_repository_impl.dart';
import '../data/lessons/lesson_repository_impl.dart';
import '../data/settings/settings_repository_impl.dart';
import '../data/sync/sync_repository_impl.dart';
import '../data/bible/verse_of_the_day_service.dart';
import '../domain/accounts/repositories.dart';
import '../domain/accounts/usecases.dart';
import '../domain/annotations/entities.dart';
import '../domain/annotations/repositories.dart';
import '../domain/annotations/usecases.dart';
import '../domain/bible/entities.dart';
import '../domain/bible/reading_progress/entities.dart';
import '../domain/bible/reading_progress/repositories.dart';
import '../domain/bible/reading_progress/usecases.dart';
import '../domain/bible/repositories.dart';
import '../domain/bible/usecases.dart';
import '../domain/bible/import/import_bible_package_usecase.dart';
import '../domain/chat/repositories.dart';
import '../domain/chat/usecases.dart';
import '../domain/lessons/entities.dart';
import '../domain/lessons/progress_dashboard.dart';
import '../domain/lessons/services/lesson_quiz_grader.dart';
import '../domain/lessons/services/lesson_timer_service.dart';
import '../domain/lessons/repositories.dart';
import '../domain/lessons/usecases.dart';
import '../domain/settings/repositories.dart';
import '../domain/settings/usecases.dart';
import '../domain/sync/repositories.dart';
import '../domain/sync/usecases.dart';
import '../domain/settings/entities.dart';
import '../infrastructure/db/app_database.dart';
import '../infrastructure/db/daos/account_dao.dart';
import '../infrastructure/db/daos/annotation_dao.dart';
import '../infrastructure/db/daos/bible_dao.dart';
import '../infrastructure/db/daos/chat_dao.dart';
import '../infrastructure/db/daos/lesson_dao.dart';
import '../infrastructure/db/daos/sync_dao.dart';
import '../infrastructure/lessons/lesson_attachment_cache.dart';
import '../infrastructure/lessons/lesson_cache_invalidator.dart';
import '../infrastructure/lessons/lesson_ingestion_pipeline.dart';
import '../infrastructure/lessons/lesson_source_registry.dart';
import '../infrastructure/lessons/lesson_sync_service.dart';
import '../infrastructure/sync/sync_orchestrator.dart';
import '../infrastructure/accounts/cloud_account_coordinator.dart';
import '../infrastructure/accounts/firebase_auth_service.dart';
import '../utils/iterable_extensions.dart';
import 'settings/bible_import_controller.dart';
import 'settings/data_sync_controller.dart';
import 'settings/lesson_sync_controller.dart';
import 'accounts/cloud_auth_controller.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  String? clientId;
  if (!kIsWeb && Firebase.apps.isNotEmpty) {
    final app = Firebase.app();
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        clientId = app.options.iosClientId;
        break;
      case TargetPlatform.android:
        clientId = app.options.androidClientId;
        break;
      default:
        clientId = null;
    }
  }
  return GoogleSignIn(
    clientId: clientId,
    scopes: const ['email', 'profile'],
  );
});

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService(
    auth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  );
});

final cloudAuthControllerProvider =
    StateNotifierProvider<CloudAuthController, CloudAuthState>((ref) {
  return CloudAuthController(ref.watch(firebaseAuthServiceProvider));
});

final firebaseAuthUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final bibleDaoProvider = Provider((ref) => BibleDao(ref.watch(appDatabaseProvider)));
final lessonDaoProvider = Provider((ref) => LessonDao(ref.watch(appDatabaseProvider)));
final accountDaoProvider = Provider((ref) => AccountDao(ref.watch(appDatabaseProvider)));
final syncDaoProvider = Provider((ref) => SyncDao(ref.watch(appDatabaseProvider)));
final chatDaoProvider = Provider((ref) => ChatDao(ref.watch(appDatabaseProvider)));
final annotationDaoProvider =
    Provider((ref) => AnnotationDao(ref.watch(appDatabaseProvider)));

final lessonSourceRegistryProvider = Provider<LessonSourceRegistry>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LessonSourceRegistry(db);
});

final lessonIngestionPipelineProvider = Provider<LessonIngestionPipeline>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final registry = ref.watch(lessonSourceRegistryProvider);
  final pipeline = LessonIngestionPipeline(db, rootBundle, registry: registry);
  ref.onDispose(pipeline.dispose);
  return pipeline;
});

final lessonSyncServiceProvider = Provider<LessonSyncService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final pipeline = ref.watch(lessonIngestionPipelineProvider);
  final registry = ref.watch(lessonSourceRegistryProvider);
  final attachmentCache = LessonAttachmentCache(db);
  final service = LessonSyncService(
    bundle: rootBundle,
    pipeline: pipeline,
    registry: registry,
    attachmentCache: attachmentCache,
  );
  ref.onDispose(service.dispose);
  return service;
});

final lessonSyncControllerProvider =
    StateNotifierProvider<LessonSyncController, LessonSyncState>((ref) {
  final registry = ref.watch(lessonSourceRegistryProvider);
  final service = ref.watch(lessonSyncServiceProvider);
  final controller = LessonSyncController(registry, service);
  ref.onDispose(controller.dispose);
  return controller;
});

final dataSyncControllerProvider =
    StateNotifierProvider<DataSyncController, DataSyncState>((ref) {
  final orchestrator = ref.watch(syncOrchestratorProvider);
  final repository = ref.watch(syncRepositoryProvider);
  final controller = DataSyncController(orchestrator, repository);
  ref.onDispose(controller.dispose);
  return controller;
});

final bibleRepositoryProvider = Provider<BibleRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = ref.watch(bibleDaoProvider);
  return BibleRepositoryImpl(db, dao);
});

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = ref.watch(lessonDaoProvider);
  final pipeline = ref.watch(lessonIngestionPipelineProvider);
  final syncDao = ref.watch(syncDaoProvider);
  final syncRepository = ref.watch(syncRepositoryProvider);
  return LessonRepositoryImpl(db, dao, pipeline, syncDao, syncRepository);
});

final lessonCacheInvalidatorProvider = Provider<LessonCacheInvalidator>((ref) {
  final service = ref.watch(lessonSyncServiceProvider);
  final invalidator = LessonCacheInvalidator(service);
  invalidator.start();
  ref.onDispose(invalidator.dispose);
  return invalidator;
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = ref.watch(accountDaoProvider);
  return AccountRepositoryImpl(db, dao);
});

final watchAccountsUseCaseProvider = Provider((ref) {
  return WatchAccountsUseCase(ref.watch(accountRepositoryProvider));
});

final getAccountsUseCaseProvider = Provider((ref) {
  return GetAccountsUseCase(ref.watch(accountRepositoryProvider));
});

final setActiveAccountUseCaseProvider = Provider((ref) {
  return SetActiveAccountUseCase(ref.watch(accountRepositoryProvider));
});

class CohortOption {
  const CohortOption({
    required this.id,
    this.title,
    this.lessonClass,
  });

  final String id;
  final String? title;
  final String? lessonClass;

  String get displayName {
    if (title != null && title!.isNotEmpty) {
      return title!;
    }
    if (lessonClass != null && lessonClass!.isNotEmpty) {
      return lessonClass!;
    }
    return id;
  }
}

final cohortOptionsProvider = FutureProvider<List<CohortOption>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final rows = await db.select(db.lessonFeeds).get();
  final options = <String, CohortOption>{};
  for (final row in rows) {
    final id = row.id;
    final title = row.cohort ?? row.id;
    options[id] = CohortOption(
      id: id,
      title: title,
      lessonClass: row.lessonClass,
    );
  }
  final list = options.values.toList()
    ..sort((a, b) => a.displayName.compareTo(b.displayName));
  return list;
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = ref.watch(syncDaoProvider);
  return SyncRepositoryImpl(db, dao);
});

final syncRemoteDataSourceProvider =
    Provider<SyncRemoteDataSource>((ref) => const NoopSyncRemoteDataSource());

final syncOrchestratorProvider = Provider<SyncOrchestrator>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final syncRepository = ref.watch(syncRepositoryProvider);
  final accountRepository = ref.watch(accountRepositoryProvider);
  final remote = ref.watch(syncRemoteDataSourceProvider);
  final syncDao = ref.watch(syncDaoProvider);
  final orchestrator = SyncOrchestrator(
    db: db,
    syncRepository: syncRepository,
    accountRepository: accountRepository,
    remoteDataSource: remote,
    syncDao: syncDao,
  );
  ref.onDispose(orchestrator.dispose);
  return orchestrator;
});

final cloudAccountCoordinatorProvider =
    Provider<CloudAccountCoordinator>((ref) {
  return CloudAccountCoordinator(
    ref.watch(accountRepositoryProvider),
    ref.watch(syncRepositoryProvider),
  );
});

final cloudAccountBindingProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<User?>>(firebaseAuthUserProvider, (previous, next) {
    next.whenData((user) {
      final coordinator = ref.read(cloudAccountCoordinatorProvider);
      unawaited(coordinator.handleAuthState(user));
    });
  });
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = ref.watch(chatDaoProvider);
  final syncDao = ref.watch(syncDaoProvider);
  final syncRepository = ref.watch(syncRepositoryProvider);
  return ChatRepositoryImpl(db, dao, syncDao, syncRepository);
});
final annotationRepositoryProvider = Provider<AnnotationRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = ref.watch(annotationDaoProvider);
  final syncDao = ref.watch(syncDaoProvider);
  final syncRepository = ref.watch(syncRepositoryProvider);
  return AnnotationRepositoryImpl(db, dao, syncDao, syncRepository);
});
final readingProgressRepositoryProvider =
    Provider<ReadingProgressRepository>((ref) {
  final repository = ReadingProgressRepositoryImpl();
  ref.onDispose(repository.dispose);
  return repository;
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl();
});

final getTranslationsUseCaseProvider = Provider((ref) {
  return GetTranslationsUseCase(ref.watch(bibleRepositoryProvider));
});

final getBooksUseCaseProvider = Provider((ref) {
  return GetBooksUseCase(ref.watch(bibleRepositoryProvider));
});

final getChapterUseCaseProvider = Provider((ref) {
  return GetChapterUseCase(ref.watch(bibleRepositoryProvider));
});

final watchChapterUseCaseProvider = Provider((ref) {
  return WatchChapterUseCase(ref.watch(bibleRepositoryProvider));
});

final searchVersesUseCaseProvider = Provider((ref) {
  return SearchVersesUseCase(ref.watch(bibleRepositoryProvider));
});

final importBiblePackageUseCaseProvider = Provider((ref) {
  return ImportBiblePackageUseCase(ref.watch(bibleRepositoryProvider));
});

final watchBookmarksForChapterUseCaseProvider = Provider((ref) {
  return WatchBookmarksForChapterUseCase(
    ref.watch(annotationRepositoryProvider),
  );
});

final toggleBookmarkUseCaseProvider = Provider((ref) {
  return ToggleBookmarkUseCase(ref.watch(annotationRepositoryProvider));
});

final watchHighlightsForChapterUseCaseProvider = Provider((ref) {
  return WatchHighlightsForChapterUseCase(
    ref.watch(annotationRepositoryProvider),
  );
});

final saveHighlightUseCaseProvider = Provider((ref) {
  return SaveHighlightUseCase(ref.watch(annotationRepositoryProvider));
});

final removeHighlightUseCaseProvider = Provider((ref) {
  return RemoveHighlightUseCase(ref.watch(annotationRepositoryProvider));
});

final watchNotesForChapterUseCaseProvider = Provider((ref) {
  return WatchNotesForChapterUseCase(ref.watch(annotationRepositoryProvider));
});

final saveNoteUseCaseProvider = Provider((ref) {
  return SaveNoteUseCase(ref.watch(annotationRepositoryProvider));
});

final deleteNoteUseCaseProvider = Provider((ref) {
  return DeleteNoteUseCase(ref.watch(annotationRepositoryProvider));
});

final undoNoteUseCaseProvider = Provider((ref) {
  return UndoNoteUseCase(ref.watch(annotationRepositoryProvider));
});

final getNoteHistoryUseCaseProvider = Provider((ref) {
  return GetNoteHistoryUseCase(ref.watch(annotationRepositoryProvider));
});

final watchReadingProgressUseCaseProvider = Provider((ref) {
  return WatchReadingProgressUseCase(
    ref.watch(readingProgressRepositoryProvider),
  );
});

final getLastReadingPositionUseCaseProvider = Provider((ref) {
  return GetLastReadingPositionUseCase(
    ref.watch(readingProgressRepositoryProvider),
  );
});

final saveReadingProgressUseCaseProvider = Provider((ref) {
  return SaveReadingProgressUseCase(
    ref.watch(readingProgressRepositoryProvider),
  );
});

final watchLessonsUseCaseProvider = Provider((ref) {
  return WatchLessonsUseCase(ref.watch(lessonRepositoryProvider));
});

final getLessonsUseCaseProvider = Provider((ref) {
  return GetLessonsUseCase(ref.watch(lessonRepositoryProvider));
});

final getLessonUseCaseProvider = Provider((ref) {
  return GetLessonUseCase(ref.watch(lessonRepositoryProvider));
});

final watchLessonProgressUseCaseProvider = Provider((ref) {
  return WatchLessonProgressUseCase(ref.watch(lessonRepositoryProvider));
});

final updateProgressUseCaseProvider = Provider((ref) {
  return UpdateProgressUseCase(ref.watch(lessonRepositoryProvider));
});

final lessonTimerServiceProvider =
    Provider.autoDispose.family<LessonTimerService, String>((ref, lessonId) {
  final service = LessonTimerService();
  ref.onDispose(service.dispose);
  return service;
});

final lessonQuizGraderProvider = Provider((ref) {
  return const LessonQuizGrader();
});

class LessonProgressRequest {
  const LessonProgressRequest({
    required this.userId,
    required this.lessonId,
  });

  final String userId;
  final String lessonId;
}

final lessonProgressProvider = StreamProvider.autoDispose
    .family<LessonProgress?, LessonProgressRequest>((ref, request) {
  final useCase = ref.watch(watchLessonProgressUseCaseProvider);
  return useCase(request.userId).map((progressList) {
    return progressList.firstWhereOrNull(
      (progress) => progress.lessonId == request.lessonId,
    );
  });
});

final lessonProgressDashboardProvider =
    StreamProvider.autoDispose<LessonProgressDashboardData>((ref) {
  final userId = ref.watch(activeUserIdProvider);
  if (userId == null) {
    return Stream.value(const LessonProgressDashboardData(
      snapshots: [],
      completedCount: 0,
      inProgressCount: 0,
      notStartedCount: 0,
      totalTimeSpentSeconds: 0,
      averageQuizScore: 0,
      classSummaries: [],
      completionsByDay: <DateTime, int>{},
    ));
  }
  final lessonsStream = ref.watch(watchLessonsUseCaseProvider)(
    filter: LessonQuery(userId: userId),
  );
  final progressStream =
      ref.watch(watchLessonProgressUseCaseProvider)(userId);

  return Rx.combineLatest2<List<Lesson>, List<LessonProgress>,
      LessonProgressDashboardData>(
    lessonsStream,
    progressStream,
    (lessons, progress) {
      final snapshots = <LessonProgressSnapshot>[];
      final classBuckets = <String, List<LessonProgressSnapshot>>{};
      var completed = 0;
      var inProgress = 0;
      var notStarted = 0;
      var totalTime = 0;
      final quizScores = <double>[];
      final completionsByDay = <DateTime, int>{};

      for (final lesson in lessons) {
        final entry =
            progress.firstWhereOrNull((item) => item.lessonId == lesson.id);
        final snapshot =
            LessonProgressSnapshot(lesson: lesson, progress: entry);
        snapshots.add(snapshot);
        classBuckets.putIfAbsent(lesson.lessonClass, () => []).add(snapshot);
        if (entry == null) {
          notStarted += 1;
          continue;
        }
        totalTime += entry.timeSpentSeconds;
        if (entry.quizScore != null) {
          quizScores.add(entry.quizScore!);
        }
        switch (entry.status) {
          case 'completed':
            completed += 1;
            if (entry.completedAt != null) {
              final completedAt = entry.completedAt!;
              final date = DateTime(
                completedAt.year,
                completedAt.month,
                completedAt.day,
              );
              completionsByDay[date] =
                  (completionsByDay[date] ?? 0) + 1;
            }
            break;
          case 'in_progress':
            inProgress += 1;
            break;
          default:
            notStarted += 1;
            break;
        }
      }

      final classSummaries = <LessonClassSummary>[];
      classBuckets.forEach((lessonClass, entries) {
        final totalLessons = entries.length;
        var classCompleted = 0;
        var classInProgress = 0;
        var classNotStarted = 0;
        var classTime = 0;
        final classScores = <double>[];

        for (final snapshot in entries) {
          final progressEntry = snapshot.progress;
          if (progressEntry == null) {
            classNotStarted += 1;
            continue;
          }
          classTime += progressEntry.timeSpentSeconds;
          if (progressEntry.quizScore != null) {
            classScores.add(progressEntry.quizScore!);
          }
          switch (progressEntry.status) {
            case 'completed':
              classCompleted += 1;
              break;
            case 'in_progress':
              classInProgress += 1;
              break;
            default:
              classNotStarted += 1;
              break;
          }
        }

        final averageScore = classScores.isEmpty
            ? 0.0
            : classScores.reduce((a, b) => a + b) / classScores.length;

        classSummaries.add(
          LessonClassSummary(
            lessonClass: lessonClass,
            totalLessons: totalLessons,
            completedLessons: classCompleted,
            inProgressLessons: classInProgress,
            notStartedLessons: classNotStarted,
            totalTimeSpentSeconds: classTime,
            averageQuizScore: averageScore,
          ),
        );
      });

      classSummaries.sort(
        (a, b) => a.lessonClass.compareTo(b.lessonClass),
      );

      final averageQuizScore = quizScores.isEmpty
          ? 0.0
          : quizScores.reduce((a, b) => a + b) / quizScores.length;

      return LessonProgressDashboardData(
        snapshots: snapshots,
        completedCount: completed,
        inProgressCount: inProgress,
        notStartedCount: notStarted,
        totalTimeSpentSeconds: totalTime,
        averageQuizScore: averageQuizScore,
        classSummaries: classSummaries,
        completionsByDay: completionsByDay,
      );
    },
  );
});

final getCurrentAccountUseCaseProvider = Provider((ref) {
  return GetCurrentAccountUseCase(ref.watch(accountRepositoryProvider));
});

final watchAccountUseCaseProvider = Provider((ref) {
  return WatchAccountUseCase(ref.watch(accountRepositoryProvider));
});

final activeAccountProvider = StreamProvider<LocalAccount?>((ref) {
  return ref.watch(watchAccountUseCaseProvider)();
});

final accountsProvider = StreamProvider<List<LocalAccount>>((ref) {
  return ref.watch(watchAccountsUseCaseProvider)();
});

final activeUserIdProvider = Provider<String?>((ref) {
  final account = ref.watch(activeAccountProvider);
  return account.maybeWhen(
    data: (value) => value?.id,
    orElse: () => null,
  );
});

final saveAccountUseCaseProvider = Provider((ref) {
  return SaveAccountUseCase(ref.watch(accountRepositoryProvider));
});

final deleteAccountUseCaseProvider = Provider((ref) {
  return DeleteAccountUseCase(ref.watch(accountRepositoryProvider));
});

final watchSyncQueueUseCaseProvider = Provider((ref) {
  return WatchSyncQueueUseCase(ref.watch(syncRepositoryProvider));
});

final enqueueSyncOperationUseCaseProvider = Provider((ref) {
  return EnqueueSyncOperationUseCase(ref.watch(syncRepositoryProvider));
});

final markSyncAttemptUseCaseProvider = Provider((ref) {
  return MarkSyncAttemptUseCase(ref.watch(syncRepositoryProvider));
});

final removeSyncOperationUseCaseProvider = Provider((ref) {
  return RemoveSyncOperationUseCase(ref.watch(syncRepositoryProvider));
});

final watchChatMessagesUseCaseProvider = Provider((ref) {
  return WatchChatMessagesUseCase(ref.watch(chatRepositoryProvider));
});

final sendChatMessageUseCaseProvider = Provider((ref) {
  return SendChatMessageUseCase(ref.watch(chatRepositoryProvider));
});

final flagChatMessageUseCaseProvider = Provider((ref) {
  return FlagChatMessageUseCase(ref.watch(chatRepositoryProvider));
});

final deleteChatMessageUseCaseProvider = Provider((ref) {
  return DeleteChatMessageUseCase(ref.watch(chatRepositoryProvider));
});

final getThemeModeUseCaseProvider = Provider((ref) {
  return GetThemeModeUseCase(ref.watch(settingsRepositoryProvider));
});

final saveThemeModeUseCaseProvider = Provider((ref) {
  return SaveThemeModeUseCase(ref.watch(settingsRepositoryProvider));
});

final translationsProvider = FutureProvider((ref) async {
  final useCase = ref.watch(getTranslationsUseCaseProvider);
  final translations = await useCase();
  if (translations.isEmpty) {
    throw StateError('No translations available');
  }
  return translations;
});

class SelectedTranslationsNotifier extends StateNotifier<List<String>> {
  SelectedTranslationsNotifier() : super(const ['kjv']);

  void setPrimary(String translationId) {
    final current = state.toList();
    current.remove(translationId);
    current.insert(0, translationId);
    state = List.unmodifiable(current);
  }

  void toggle(String translationId) {
    final current = state.toList();
    if (current.contains(translationId)) {
      if (current.length == 1) {
        return;
      }
      current.remove(translationId);
    } else {
      current.add(translationId);
    }
    state = List.unmodifiable(current);
  }

  void setAll(Iterable<String> translationIds) {
    final list = translationIds.isEmpty
        ? const ['kjv']
        : translationIds.toSet().toList();
    state = List.unmodifiable(list);
  }
}

final selectedTranslationIdsProvider =
    StateNotifierProvider<SelectedTranslationsNotifier, List<String>>(
  (ref) => SelectedTranslationsNotifier(),
);

final selectedTranslationIdProvider = Provider<String>((ref) {
  final ids = ref.watch(selectedTranslationIdsProvider);
  if (ids.isEmpty) {
    return 'kjv';
  }
  return ids.first;
});

class LessonFilterState {
  const LessonFilterState({
    this.selectedClass,
    this.age,
    this.completion = LessonCompletionFilter.all,
    required this.userId,
  });

  final String? selectedClass;
  final int? age;
  final LessonCompletionFilter completion;
  final String userId;

  LessonFilterState copyWith({
    String? selectedClass,
    bool resetClass = false,
    int? age,
    bool resetAge = false,
    LessonCompletionFilter? completion,
    String? userId,
  }) {
    return LessonFilterState(
      selectedClass:
          resetClass ? null : selectedClass ?? this.selectedClass,
      age: resetAge ? null : age ?? this.age,
      completion: completion ?? this.completion,
      userId: userId ?? this.userId,
    );
  }

  LessonQuery toQuery() {
    return LessonQuery(
      classes: selectedClass == null ? null : {selectedClass!},
      age: age,
      completion: completion,
      userId: userId,
    );
  }
}

class LessonFiltersNotifier extends StateNotifier<LessonFilterState> {
  LessonFiltersNotifier(String userId)
      : super(LessonFilterState(userId: userId));

  void setUser(String userId) {
    state = state.copyWith(userId: userId);
  }

  void setClass(String? lessonClass) {
    state = state.copyWith(selectedClass: lessonClass, resetClass: lessonClass == null);
  }

  void setAge(int? age) {
    state = state.copyWith(age: age, resetAge: age == null);
  }

  void setCompletion(LessonCompletionFilter completion) {
    state = state.copyWith(completion: completion);
  }
}

final lessonFiltersProvider =
    StateNotifierProvider<LessonFiltersNotifier, LessonFilterState>((ref) {
  final userId = ref.watch(activeUserIdProvider) ?? '';
  final notifier = LessonFiltersNotifier(userId);
  ref.listen<String?>(activeUserIdProvider, (previous, next) {
    if (next != null) {
      notifier.setUser(next);
    }
  });
  return notifier;
});

final booksProvider = FutureProvider((ref) async {
  final translationId = ref.watch(selectedTranslationIdProvider);
  final useCase = ref.watch(getBooksUseCaseProvider);
  return useCase(translationId);
});

final booksForTranslationProvider = FutureProvider.autoDispose
    .family<List<BibleBook>, String>((ref, translationId) async {
  final useCase = ref.watch(getBooksUseCaseProvider);
  return useCase(translationId);
});

final lessonsProvider = StreamProvider((ref) {
  ref.watch(lessonCacheInvalidatorProvider);
  final filters = ref.watch(lessonFiltersProvider);
  final useCase = ref.watch(watchLessonsUseCaseProvider);
  return useCase(filter: filters.toQuery());
});

final lessonListProvider = FutureProvider((ref) async {
  final filters = ref.watch(lessonFiltersProvider);
  final useCase = ref.watch(getLessonsUseCaseProvider);
  return useCase(filter: filters.toQuery());
});

class VerseSearchRequest {
  const VerseSearchRequest({
    required this.translationId,
    required this.query,
    this.bookId,
    this.limit = 20,
  });

  final String translationId;
  final String query;
  final int? bookId;
  final int limit;
}

final verseSearchResultsProvider = FutureProvider.autoDispose
    .family<List<BibleSearchResult>, VerseSearchRequest>((ref, request) async {
  if (request.query.trim().isEmpty) {
    return const [];
  }
  final useCase = ref.watch(searchVersesUseCaseProvider);
  return useCase(
    translationId: request.translationId,
    query: request.query,
    bookId: request.bookId,
    limit: request.limit,
  );
});

final verseOfTheDayProvider = FutureProvider((ref) async {
  const service = VerseOfTheDayService();
  return service.fetch();
});

final bibleImportControllerProvider =
    StateNotifierProvider<BibleImportController, BibleImportState>((ref) {
  final useCase = ref.watch(importBiblePackageUseCaseProvider);
  return BibleImportController(useCase);
});

class ChapterRequest {
  const ChapterRequest({
    required this.translationId,
    required this.bookId,
    required this.chapter,
  });

  final String translationId;
  final int bookId;
  final int chapter;
}

final chapterProvider =
    FutureProvider.family.autoDispose<List<BibleVerse>, ChapterRequest>((ref, request) async {
  final useCase = ref.watch(getChapterUseCaseProvider);
  return useCase(request.translationId, request.bookId, request.chapter);
});

class ParallelChapterRequest {
  const ParallelChapterRequest({
    required this.translationIds,
    required this.bookId,
    required this.chapter,
  });

  final List<String> translationIds;
  final int bookId;
  final int chapter;
}

class ParallelVerseRow {
  ParallelVerseRow({
    required this.verseNumber,
    required Map<String, BibleVerse> versesByTranslation,
  }) : versesByTranslation = Map.unmodifiable(versesByTranslation);

  final int verseNumber;
  final Map<String, BibleVerse> versesByTranslation;
}

final parallelChapterProvider = StreamProvider.autoDispose
    .family<List<ParallelVerseRow>, ParallelChapterRequest>((ref, request) {
  final watchChapter = ref.watch(watchChapterUseCaseProvider);
  final translationIds = request.translationIds.isEmpty
      ? [ref.watch(selectedTranslationIdProvider)]
      : request.translationIds;
  if (translationIds.isEmpty) {
    return Stream.value(const []);
  }
  final streams = translationIds
      .map((id) => watchChapter(id, request.bookId, request.chapter))
      .toList();
  return Rx.combineLatestList<List<BibleVerse>>(streams).map(
    (chapters) => _mergeParallelVerses(translationIds, chapters),
  );
});

List<ParallelVerseRow> _mergeParallelVerses(
  List<String> translationIds,
  List<List<BibleVerse>> chapters,
) {
  final verseMap = <int, Map<String, BibleVerse>>{};
  for (var i = 0; i < translationIds.length; i++) {
    final translationId = translationIds[i];
    final verses = chapters.length > i ? chapters[i] : const <BibleVerse>[];
    for (final verse in verses) {
      final bucket = verseMap.putIfAbsent(verse.verse, () => {});
      bucket[translationId] = verse;
    }
  }
  final keys = verseMap.keys.toList()..sort();
  return [
    for (final key in keys)
      ParallelVerseRow(
        verseNumber: key,
        versesByTranslation: verseMap[key]!,
      ),
  ];
}

class AnnotationRequest {
  const AnnotationRequest({
    required this.userId,
    required this.translationId,
    required this.bookId,
    required this.chapter,
  });

  final String userId;
  final String translationId;
  final int bookId;
  final int chapter;
}

final chapterBookmarksProvider = StreamProvider.autoDispose
    .family<List<Bookmark>, AnnotationRequest>((ref, request) {
  final useCase = ref.watch(watchBookmarksForChapterUseCaseProvider);
  return useCase(
    request.userId,
    request.translationId,
    request.bookId,
    request.chapter,
  );
});

final chapterHighlightsProvider = StreamProvider.autoDispose
    .family<List<Highlight>, AnnotationRequest>((ref, request) {
  final useCase = ref.watch(watchHighlightsForChapterUseCaseProvider);
  return useCase(
    request.userId,
    request.translationId,
    request.bookId,
    request.chapter,
  );
});

final chapterNotesProvider = StreamProvider.autoDispose
    .family<List<Note>, AnnotationRequest>((ref, request) {
  final useCase = ref.watch(watchNotesForChapterUseCaseProvider);
  return useCase(
    request.userId,
    request.translationId,
    request.bookId,
    request.chapter,
  );
});

final readingProgressProvider = StreamProvider<ReadingPosition?>((ref) {
  final userId = ref.watch(activeUserIdProvider);
  if (userId == null) {
    return Stream.value(null);
  }
  final useCase = ref.watch(watchReadingProgressUseCaseProvider);
  return useCase(userId);
});

class ThemeModeController extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final userId = ref.watch(activeUserIdProvider);
    if (userId == null) {
      return ThemeMode.system;
    }
    final getThemeMode = ref.read(getThemeModeUseCaseProvider);
    final mode = await getThemeMode(userId);
    return _map(mode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final domainMode = _reverseMap(mode);
    final userId = ref.read(activeUserIdProvider);
    if (userId != null) {
      final saveTheme = ref.read(saveThemeModeUseCaseProvider);
      await saveTheme(userId, domainMode);
    }
    state = AsyncValue.data(mode);
  }

  ThemeMode _map(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
      default:
        return ThemeMode.system;
    }
  }

  AppThemeMode _reverseMap(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return AppThemeMode.light;
      case ThemeMode.dark:
        return AppThemeMode.dark;
      case ThemeMode.system:
      default:
        return AppThemeMode.system;
    }
  }
}

final themeModeControllerProvider =
    AsyncNotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);
