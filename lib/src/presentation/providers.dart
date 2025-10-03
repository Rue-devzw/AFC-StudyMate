import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/accounts/account_repository_impl.dart';
import '../data/bible/bible_repository_impl.dart';
import '../data/chat/chat_repository_impl.dart';
import '../data/lessons/lesson_repository_impl.dart';
import '../data/settings/settings_repository_impl.dart';
import '../data/sync/sync_repository_impl.dart';
import '../data/bible/verse_of_the_day_service.dart';
import '../domain/accounts/repositories.dart';
import '../domain/accounts/usecases.dart';
import '../domain/bible/entities.dart';
import '../domain/bible/repositories.dart';
import '../domain/bible/usecases.dart';
import '../domain/chat/repositories.dart';
import '../domain/chat/usecases.dart';
import '../domain/lessons/repositories.dart';
import '../domain/lessons/usecases.dart';
import '../domain/settings/repositories.dart';
import '../domain/settings/usecases.dart';
import '../domain/sync/repositories.dart';
import '../domain/sync/usecases.dart';
import '../domain/settings/entities.dart';
import '../infrastructure/db/app_database.dart';
import '../infrastructure/db/daos/account_dao.dart';
import '../infrastructure/db/daos/bible_dao.dart';
import '../infrastructure/db/daos/chat_dao.dart';
import '../infrastructure/db/daos/lesson_dao.dart';
import '../infrastructure/db/daos/sync_dao.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final bibleDaoProvider = Provider((ref) => BibleDao(ref.watch(appDatabaseProvider)));
final lessonDaoProvider = Provider((ref) => LessonDao(ref.watch(appDatabaseProvider)));
final accountDaoProvider = Provider((ref) => AccountDao(ref.watch(appDatabaseProvider)));
final syncDaoProvider = Provider((ref) => SyncDao(ref.watch(appDatabaseProvider)));
final chatDaoProvider = Provider((ref) => ChatDao(ref.watch(appDatabaseProvider)));

final bibleRepositoryProvider = Provider<BibleRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = ref.watch(bibleDaoProvider);
  return BibleRepositoryImpl(db, dao);
});

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = ref.watch(lessonDaoProvider);
  return LessonRepositoryImpl(db, dao);
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = ref.watch(accountDaoProvider);
  return AccountRepositoryImpl(db, dao);
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = ref.watch(syncDaoProvider);
  return SyncRepositoryImpl(db, dao);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = ref.watch(chatDaoProvider);
  return ChatRepositoryImpl(db, dao);
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

final searchBibleUseCaseProvider = Provider((ref) {
  return SearchBibleUseCase(ref.watch(bibleRepositoryProvider));
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

final getCurrentAccountUseCaseProvider = Provider((ref) {
  return GetCurrentAccountUseCase(ref.watch(accountRepositoryProvider));
});

final watchAccountUseCaseProvider = Provider((ref) {
  return WatchAccountUseCase(ref.watch(accountRepositoryProvider));
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

final selectedTranslationIdProvider = StateProvider<String>((ref) {
  final translationsAsync = ref.watch(translationsProvider);
  return translationsAsync.maybeWhen(
    data: (data) {
      if (data.isEmpty) {
        return 'kjv';
      }
      final preferred = data.firstWhere(
        (translation) => translation.id == 'kjv',
        orElse: () => data.first,
      );
      return preferred.id;
    },
    orElse: () => 'kjv',
  );
});

final booksProvider = FutureProvider((ref) async {
  final translationId = ref.watch(selectedTranslationIdProvider);
  final useCase = ref.watch(getBooksUseCaseProvider);
  return useCase(translationId);
});

final lessonsProvider = StreamProvider((ref) {
  final useCase = ref.watch(watchLessonsUseCaseProvider);
  return useCase();
});

final lessonListProvider = FutureProvider((ref) async {
  final useCase = ref.watch(getLessonsUseCaseProvider);
  return useCase();
});

final verseSearchProvider =
    FutureProvider.family.autoDispose((ref, String query) async {
  if (query.trim().isEmpty) {
    return [];
  }
  final translationId = ref.watch(selectedTranslationIdProvider);
  final useCase = ref.watch(searchBibleUseCaseProvider);
  return useCase(translationId, query, limit: 20);
});

final verseOfTheDayProvider = FutureProvider((ref) async {
  const service = VerseOfTheDayService();
  return service.fetch();
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

class ThemeModeController extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final getThemeMode = ref.read(getThemeModeUseCaseProvider);
    final mode = await getThemeMode();
    return _map(mode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final saveTheme = ref.read(saveThemeModeUseCaseProvider);
    final domainMode = _reverseMap(mode);
    await saveTheme(domainMode);
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
