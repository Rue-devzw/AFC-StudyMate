import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/bible_book.dart';
import 'package:afc_studymate/data/models/bible_ref.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/note.dart';
import 'package:afc_studymate/data/models/verse.dart';
import 'package:afc_studymate/data/providers/user_providers.dart';
import 'package:afc_studymate/data/services/bible_service.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

const _bibleTextPrimary = Color(0xFFEFF3FF);
const _bibleTextSecondary = Color(0xFFB7C4D8);
const _bibleChrome = Color(0xCC111821);
const _bibleChromeBorder = Color(0x55BFD4F6);

class BibleScreen extends HookConsumerWidget {
  const BibleScreen({
    super.key,
    this.initialBook,
    this.initialChapter,
    this.highlightVerse,
    this.initialTranslation,
  });

  static const String routeName = 'bible';

  final String? initialBook;
  final int? initialChapter;
  final int? highlightVerse;
  final Translation? initialTranslation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bibleService = ref.read(bibleServiceProvider);
    final profileAsync = ref.watch(userProfileProvider);

    final translation = useState(Translation.kjv);
    final hasAppliedInitialTranslation = useRef<bool>(false);
    final selectedBookNumber = useState<int?>(null);
    final selectedChapter = useState(initialChapter ?? 1);
    final fontScale = useState<double>(1);
    final readingFontStyle = useState(ReadingFontStyle.serif);
    final hasAppliedInitialSelection = useRef<bool>(false);
    final notesRefreshTick = useState(0);
    final activeHighlightedVerse = useState<int?>(highlightVerse);
    final pendingVerseJump = useState<int?>(null);
    final passageHistory = useState<List<_PassageLocation>>(
      <_PassageLocation>[],
    );
    final passageHistoryIndex = useState<int>(-1);
    final isApplyingHistory = useRef<bool>(false);
    final verseItemKeys = useMemoized(
      () => <int, GlobalKey>{},
      <Object?>[selectedBookNumber.value, selectedChapter.value],
    );

    useEffect(() {
      if (hasAppliedInitialTranslation.value) {
        return null;
      }
      final preferred =
          initialTranslation ?? profileAsync.valueOrNull?.translation;
      if (preferred != null) {
        translation.value = preferred;
        hasAppliedInitialTranslation.value = true;
      }
      return null;
    }, [initialTranslation, profileAsync.valueOrNull?.translation]);

    final booksFuture = useMemoized(
      () => bibleService.getBooks(translation.value),
      <Object?>[translation.value],
    );
    final booksSnapshot = useFuture(booksFuture);

    final normalizedInitialBook = initialBook?.toLowerCase();
    final initialChapterNumber = initialChapter;
    useEffect(
      () {
        final books = booksSnapshot.data;
        if (books == null || books.isEmpty) {
          selectedBookNumber.value = null;
          return null;
        }

        if (!hasAppliedInitialSelection.value) {
          if (normalizedInitialBook != null) {
            final match = books.firstWhereOrNull(
              (book) => book.name.toLowerCase() == normalizedInitialBook,
            );
            if (match != null) {
              selectedBookNumber.value = match.number;
              selectedChapter.value =
                  initialChapterNumber ?? selectedChapter.value;
              hasAppliedInitialSelection.value = true;
              return null;
            }
          }

          final current = selectedBookNumber.value;
          if (current == null ||
              books.firstWhereOrNull((book) => book.number == current) ==
                  null) {
            selectedBookNumber.value = books.first.number;
          }
          hasAppliedInitialSelection.value = true;
        } else {
          final current = selectedBookNumber.value;
          if (current == null ||
              books.firstWhereOrNull((book) => book.number == current) ==
                  null) {
            selectedBookNumber.value = books.first.number;
            selectedChapter.value = 1;
          }
        }
        return null;
      },
      <Object?>[
        booksSnapshot.data,
        normalizedInitialBook,
        initialChapterNumber,
      ],
    );

    final selectedBook = booksSnapshot.data?.firstWhereOrNull(
      (book) => book.number == selectedBookNumber.value,
    );

    useEffect(() {
      final book = selectedBook;
      if (book == null) {
        return null;
      }
      if (isApplyingHistory.value) {
        isApplyingHistory.value = false;
        return null;
      }

      final currentLocation = _PassageLocation(
        bookNumber: book.number,
        chapter: selectedChapter.value,
      );
      final history = passageHistory.value;
      if (history.isNotEmpty &&
          history[passageHistoryIndex.value] == currentLocation) {
        return null;
      }

      final trimmed = history.take(passageHistoryIndex.value + 1).toList();
      trimmed.add(currentLocation);
      passageHistory.value = trimmed;
      passageHistoryIndex.value = trimmed.length - 1;
      return null;
    }, <Object?>[selectedBook?.number, selectedChapter.value]);

    final chapterCountFuture = useMemoized(
      () {
        final book = selectedBook;
        if (book == null) {
          return Future<int>.value(0);
        }
        return bibleService.getChapterCount(book.name, translation.value);
      },
      <Object?>[selectedBook?.number, translation.value],
    );
    final chapterCountSnapshot = useFuture(chapterCountFuture);

    useEffect(() {
      final count = chapterCountSnapshot.data;
      if (count == null || count == 0) {
        return null;
      }
      if (selectedChapter.value > count) {
        selectedChapter.value = 1;
      }
      return null;
    }, <Object?>[chapterCountSnapshot.data]);

    final passageFuture = useMemoized(
      () {
        final book = selectedBook;
        if (book == null) {
          return Future<List<Verse>>.value(<Verse>[]);
        }
        return bibleService.getChapter(
          book.name,
          selectedChapter.value,
          translation.value,
        );
      },
      <Object?>[selectedBook?.number, selectedChapter.value, translation.value],
    );
    final passageSnapshot = useFuture(passageFuture);

    final verses = passageSnapshot.data ?? <Verse>[];
    final notesFuture = useMemoized(
      () {
        final book = selectedBook;
        if (book == null) {
          return Future<List<Note>>.value(<Note>[]);
        }
        return ref
            .read(appDatabaseProvider)
            .getNotes(
              'local_user',
              BibleRef(book: book.name, chapter: selectedChapter.value),
            );
      },
      <Object?>[
        selectedBook?.number,
        selectedChapter.value,
        notesRefreshTick.value,
      ],
    );
    final notesSnapshot = useFuture(notesFuture);
    final allNotesFuture = useMemoized(
      () => ref.read(appDatabaseProvider).getAllNotes('local_user'),
      <Object?>[notesRefreshTick.value],
    );
    final allNotesSnapshot = useFuture(allNotesFuture);
    final notesByVerse = <int, List<Note>>{};
    for (final note in notesSnapshot.data ?? <Note>[]) {
      final verseNo = note.ref.verseStart;
      if (verseNo != null) {
        notesByVerse.putIfAbsent(verseNo, () => <Note>[]).add(note);
      }
    }
    final isLoading =
        booksSnapshot.connectionState != ConnectionState.done ||
        chapterCountSnapshot.connectionState != ConnectionState.done ||
        passageSnapshot.connectionState != ConnectionState.done;

    final title = selectedBook != null
        ? '${selectedBook.name} ${selectedChapter.value}'
        : 'Bible';

    Future<void> openScrollWheelNavigation() async {
      final books = booksSnapshot.data;
      if (books == null || books.isEmpty) {
        return;
      }
      final result = await showModalBottomSheet<_WheelNavigationResult>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => _ScrollWheelNavigationSheet(
          books: books,
          initialBookNumber: selectedBookNumber.value,
          initialChapter: selectedChapter.value,
          initialVerse: activeHighlightedVerse.value,
          translation: translation.value,
          bibleService: bibleService,
        ),
      );
      if (result == null) {
        return;
      }
      selectedBookNumber.value = result.book.number;
      selectedChapter.value = result.chapter;
      if (result.verse != null) {
        activeHighlightedVerse.value = result.verse;
        pendingVerseJump.value = result.verse;
      } else {
        activeHighlightedVerse.value = null;
        pendingVerseJump.value = null;
      }
    }

    void moveHistory(int nextIndex) {
      final history = passageHistory.value;
      if (nextIndex < 0 || nextIndex >= history.length) {
        return;
      }
      final location = history[nextIndex];
      isApplyingHistory.value = true;
      passageHistoryIndex.value = nextIndex;
      selectedBookNumber.value = location.bookNumber;
      selectedChapter.value = location.chapter;
      activeHighlightedVerse.value = null;
      pendingVerseJump.value = null;
    }

    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_bible.png',
      appBar: AppBar(
        titleSpacing: 12,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _bibleTextPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            child: PremiumGlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap:
                    booksSnapshot.hasData &&
                        (booksSnapshot.data?.isNotEmpty ?? false)
                    ? () async {
                        final books = booksSnapshot.data;
                        if (books == null || books.isEmpty) {
                          return;
                        }
                        final result =
                            await showModalBottomSheet<_PassageSelectionResult>(
                              context: context,
                              useRootNavigator: true,
                              isScrollControlled: true,
                              useSafeArea: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return _PassageSelectorSheet(
                                  books: books,
                                  initialBookNumber: selectedBookNumber.value,
                                  initialChapter: selectedChapter.value,
                                  translation: translation.value,
                                  bibleService: bibleService,
                                );
                              },
                            );

                        if (result != null) {
                          selectedBookNumber.value = result.book.number;
                          selectedChapter.value = result.chapter;
                        }
                      }
                    : null,
                child: Row(
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 18,
                      color: _bibleTextPrimary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Passage',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: _bibleTextPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _BibleActionIcon(
            icon: Icons.arrow_back_ios_new,
            tooltip: 'Previous passage',
            onPressed: passageHistoryIndex.value > 0
                ? () => moveHistory(passageHistoryIndex.value - 1)
                : null,
          ),
          _BibleActionIcon(
            icon: Icons.arrow_forward_ios,
            tooltip: 'Next passage',
            onPressed:
                passageHistoryIndex.value >= 0 &&
                    passageHistoryIndex.value < passageHistory.value.length - 1
                ? () => moveHistory(passageHistoryIndex.value + 1)
                : null,
          ),
          _BibleActionIcon(
            icon: Icons.search,
            tooltip: 'Search Bible',
            onPressed: () async {
              final result = await showSearch<BibleRef?>(
                context: context,
                delegate: _BibleSearchDelegate(
                  bibleService: bibleService,
                  translation: translation.value,
                ),
              );
              if (result == null) {
                return;
              }

              final books = booksSnapshot.data;
              final match = books?.firstWhereOrNull(
                (book) => book.name.toLowerCase() == result.book.toLowerCase(),
              );

              if (match == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Unable to open ${result.book} in this translation.',
                    ),
                  ),
                );
                return;
              }

              selectedBookNumber.value = match.number;
              selectedChapter.value = result.chapter;
            },
          ),

          _BibleActionIcon(
            icon: Icons.collections_bookmark,
            tooltip: 'Study library',
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) => _StudyLibrarySheet(
                  notes: allNotesSnapshot.data ?? <Note>[],
                  onOpen: (note) {
                    final books = booksSnapshot.data ?? <BibleBook>[];
                    final match = books.firstWhereOrNull(
                      (book) =>
                          book.name.toLowerCase() ==
                          note.ref.book.toLowerCase(),
                    );
                    if (match == null) {
                      return;
                    }
                    selectedBookNumber.value = match.number;
                    selectedChapter.value = note.ref.chapter;
                    if (note.ref.verseStart != null) {
                      activeHighlightedVerse.value = note.ref.verseStart;
                      pendingVerseJump.value = note.ref.verseStart;
                    }
                    Navigator.of(context).pop();
                  },
                  onDelete: (note) async {
                    await ref.read(appDatabaseProvider).deleteNote(note.id);
                    notesRefreshTick.value++;
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          if (isLoading) const LinearProgressIndicator(minHeight: 2),
          _QuickNavigationBar(
            bookName: selectedBook?.name,
            chapter: selectedChapter.value,
            canGoPrevious: selectedChapter.value > 1,
            canGoNext:
                (chapterCountSnapshot.data ?? 0) > 0 &&
                selectedChapter.value < (chapterCountSnapshot.data ?? 0),
            onPrevious: () {
              if (selectedChapter.value > 1) {
                selectedChapter.value--;
                activeHighlightedVerse.value = null;
              }
            },
            onNext: () {
              final chapterCount = chapterCountSnapshot.data ?? 0;
              if (chapterCount > 0 && selectedChapter.value < chapterCount) {
                selectedChapter.value++;
                activeHighlightedVerse.value = null;
              }
            },
            onJumpToVerse: verses.isEmpty
                ? null
                : () async {
                    final selected = await showModalBottomSheet<int>(
                      context: context,
                      useSafeArea: true,
                      builder: (context) => _VerseJumpSheet(
                        verseCount: verses.length,
                        selectedVerse: activeHighlightedVerse.value,
                      ),
                    );
                    if (selected == null) {
                      return;
                    }
                    activeHighlightedVerse.value = selected;
                    pendingVerseJump.value = selected;
                  },
            onOpenWheel: openScrollWheelNavigation,
            onDisplayOptions: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                useSafeArea: true,
                builder: (context) => _DisplayOptionsSheet(
                  fontScale: fontScale.value,
                  onFontScaleChanged: (value) => fontScale.value = value,
                  fontStyle: readingFontStyle.value,
                  onFontStyleChanged: (value) => readingFontStyle.value = value,
                  translation: translation.value,
                  onTranslationChanged: (value) {
                    translation.value = value;
                    selectedBookNumber.value = null;
                    selectedChapter.value = 1;
                    final profile = profileAsync.valueOrNull;
                    if (profile != null) {
                      ref
                          .read(appDatabaseProvider)
                          .upsertProfile(
                            profile.copyWith(translation: value),
                          );
                    }
                  },
                ),
              );
            },
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (booksSnapshot.hasError) {
                  return _CenteredMessage(
                    'Unable to load books: ${booksSnapshot.error}',
                  );
                }
                if (chapterCountSnapshot.hasError) {
                  return _CenteredMessage(
                    'Unable to load chapters for ${selectedBook?.name ?? 'this book'}: ${chapterCountSnapshot.error}',
                  );
                }
                if (passageSnapshot.hasError) {
                  return _CenteredMessage(
                    'Unable to load passage: ${passageSnapshot.error}',
                  );
                }
                if (booksSnapshot.data?.isEmpty ?? true) {
                  return const _CenteredMessage(
                    'No books available for this translation.',
                  );
                }
                if (verses.isEmpty) {
                  return const _CenteredMessage(
                    'Select a passage to begin reading.',
                  );
                }

                final textStyle = _readingTextStyle(
                  context,
                  fontScale.value,
                  readingFontStyle.value,
                );
                final verseNumberStyle = textStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _bibleTextSecondary.withValues(alpha: 0.9),
                );

                final highlightVerseNumber = activeHighlightedVerse.value;

                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    standardBottomContentPadding(context),
                  ), // Clear floating bottom bar
                  itemBuilder: (context, index) {
                    final verse = verses[index];
                    final verseNotes = notesByVerse[verse.verse] ?? <Note>[];
                    final bookmarkNote = verseNotes.firstWhereOrNull(
                      _isBookmark,
                    );
                    final highlightNote = verseNotes.firstWhereOrNull(
                      _isHighlight,
                    );
                    final inlineNote = verseNotes.firstWhereOrNull(
                      _isPersonalNote,
                    );
                    final verseKey = verseItemKeys.putIfAbsent(
                      verse.verse,
                      GlobalKey.new,
                    );
                    if (pendingVerseJump.value == verse.verse) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final verseContext = verseKey.currentContext;
                        if (verseContext != null) {
                          Scrollable.ensureVisible(
                            verseContext,
                            duration: const Duration(milliseconds: 240),
                            curve: Curves.easeOutCubic,
                            alignment: 0.15,
                          );
                        }
                        if (pendingVerseJump.value == verse.verse) {
                          pendingVerseJump.value = null;
                        }
                      });
                    }
                    final verseText = Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          WidgetSpan(
                            baseline: TextBaseline.alphabetic,
                            alignment: PlaceholderAlignment.aboveBaseline,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Text(
                                '${verse.verse}',
                                style: verseNumberStyle.copyWith(
                                  color: _bibleTextSecondary,
                                  fontSize: (textStyle.fontSize ?? 16) * 0.8,
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: verse.text,
                            style: textStyle.copyWith(
                              color: _bibleTextPrimary,
                              shadows: const [
                                Shadow(
                                  color: Color(0x90000000),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                    final verseBody = InkWell(
                      onTap: () async {
                        final saved = await _showVerseActionSheet(
                          context,
                          ref,
                          verse: verse,
                          existingNotes: verseNotes,
                        );
                        if (saved) {
                          notesRefreshTick.value++;
                        }
                      },
                      onLongPress: () async {
                        final saved = await _showVerseActionSheet(
                          context,
                          ref,
                          verse: verse,
                          existingNotes: verseNotes,
                        );
                        if (saved) {
                          notesRefreshTick.value++;
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: verseText),
                            if (bookmarkNote != null || highlightNote != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 8, top: 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (bookmarkNote != null)
                                      const Icon(
                                        Icons.bookmark,
                                        size: 18,
                                        color: Colors.lightBlueAccent,
                                      ),
                                    if (highlightNote != null)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Icon(
                                          Icons.highlight_alt,
                                          size: 18,
                                          color: Colors.amberAccent,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                    final verseWithInlineNote = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verseBody,
                        if (inlineNote != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.16),
                                ),
                              ),
                              child: Text(
                                _noteBody(inlineNote.text),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.95),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                    if (highlightVerseNumber == null ||
                        verse.verse != highlightVerseNumber) {
                      if (highlightNote != null) {
                        return Container(
                          key: verseKey,
                          child: PremiumGlassCard(
                            borderRadius: BorderRadius.circular(12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: verseWithInlineNote,
                          ),
                        );
                      }
                      return Container(
                        key: verseKey,
                        child: verseWithInlineNote,
                      );
                    }
                    return Container(
                      key: verseKey,
                      child: PremiumGlassCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        child: verseWithInlineNote,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 24),
                  itemCount: verses.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle _readingTextStyle(
  BuildContext context,
  double scale,
  ReadingFontStyle style,
) {
  final base =
      Theme.of(context).textTheme.bodyLarge ??
      const TextStyle(fontSize: 16, height: 1.5);
  final baseSize = base.fontSize ?? 16;
  final fontFamilyFallback = style == ReadingFontStyle.serif
      ? const <String>['Noto Serif', 'Merriweather', 'Times New Roman', 'serif']
      : base.fontFamilyFallback;

  return base.copyWith(
    fontSize: baseSize * scale,
    height: 1.6,
    fontFamilyFallback: fontFamilyFallback,
  );
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: _bibleTextSecondary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

Future<bool> _showVerseActionSheet(
  BuildContext context,
  WidgetRef ref, {
  required Verse verse,
  required List<Note> existingNotes,
}) async {
  final existingBookmark = existingNotes.firstWhereOrNull(_isBookmark);
  final existingHighlight = existingNotes.firstWhereOrNull(_isHighlight);
  final existingPersonal = existingNotes.firstWhereOrNull(_isPersonalNote);

  final action = await showModalBottomSheet<String>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.copy_all_outlined),
            title: const Text('Copy verse text'),
            onTap: () => Navigator.pop(context, 'copy'),
          ),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('Share verse'),
            onTap: () => Navigator.pop(context, 'share'),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_add),
            title: Text(
              existingBookmark == null ? 'Bookmark verse' : 'Update bookmark',
            ),
            onTap: () => Navigator.pop(context, 'bookmark'),
          ),
          ListTile(
            leading: const Icon(Icons.highlight_alt),
            title: Text(
              existingHighlight == null
                  ? 'Highlight verse'
                  : 'Update highlight',
            ),
            onTap: () => Navigator.pop(context, 'highlight'),
          ),
          ListTile(
            leading: const Icon(Icons.sticky_note_2_outlined),
            title: Text(
              existingPersonal == null
                  ? 'Add personal note'
                  : 'Edit personal note',
            ),
            onTap: () => Navigator.pop(context, 'note'),
          ),
          if (existingBookmark != null)
            ListTile(
              leading: const Icon(Icons.bookmark_remove_outlined),
              title: const Text('Remove bookmark'),
              onTap: () => Navigator.pop(context, 'remove_bookmark'),
            ),
          if (existingHighlight != null)
            ListTile(
              leading: const Icon(Icons.highlight_off_outlined),
              title: const Text('Remove highlight'),
              onTap: () => Navigator.pop(context, 'remove_highlight'),
            ),
          if (existingPersonal != null)
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Remove personal note'),
              onTap: () => Navigator.pop(context, 'remove_note'),
            ),
        ],
      ),
    ),
  );

  if (action == null) {
    return false;
  }

  if (action == 'copy') {
    await Clipboard.setData(
      ClipboardData(
        text: '${verse.book} ${verse.chapter}:${verse.verse} ${verse.text}',
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Verse copied.')));
    }
    return false;
  }

  if (action == 'share') {
    await Share.share(
      '${verse.book} ${verse.chapter}:${verse.verse}\n${verse.text}',
    );
    return false;
  }

  final db = ref.read(appDatabaseProvider);
  if (action == 'remove_bookmark' && existingBookmark != null) {
    final bookmarks = existingNotes.where(_isBookmark).toList();
    for (final marker in bookmarks) {
      await db.deleteNote(marker.id);
    }
    return true;
  }

  if (action == 'remove_highlight' && existingHighlight != null) {
    final highlights = existingNotes.where(_isHighlight).toList();
    for (final marker in highlights) {
      await db.deleteNote(marker.id);
    }
    return true;
  }

  if (action == 'remove_note' && existingPersonal != null) {
    final personal = existingNotes.where(_isPersonalNote).toList();
    for (final marker in personal) {
      await db.deleteNote(marker.id);
    }
    return true;
  }

  if (action == 'note') {
    final initial = existingPersonal != null
        ? _noteBody(existingPersonal.text)
        : '';
    final text = await _showPersonalNoteEditor(
      context,
      initialValue: initial,
    );
    if (text == null) {
      return false;
    }
    if (text.trim().isEmpty) {
      if (existingPersonal != null) {
        await db.deleteNote(existingPersonal.id);
        return true;
      }
      return false;
    }

    final note = Note(
      id: existingPersonal?.id ?? const Uuid().v4(),
      userId: 'local_user',
      ref: BibleRef(
        book: verse.book,
        chapter: verse.chapter,
        verseStart: verse.verse,
        verseEnd: verse.verse,
      ),
      text: '[note] ${text.trim()}',
      createdAt: existingPersonal?.createdAt ?? DateTime.now(),
    );
    await db.upsertNote(note);
    return true;
  }

  final isHighlight = action == 'highlight';
  final prefix = isHighlight ? '[highlight]' : '[bookmark]';
  final existing = isHighlight ? existingHighlight : existingBookmark;

  // Clean up any stray duplicates (if any crept in), but strictly preserve the one we're keeping.
  final sameTypeNotes = existingNotes
      .where(isHighlight ? _isHighlight : _isBookmark)
      .toList();
  final keepId = existing?.id;
  for (final duplicate in sameTypeNotes) {
    if (keepId != null && duplicate.id == keepId) {
      continue;
    }
    await db.deleteNote(duplicate.id);
  }

  final note = Note(
    id: keepId ?? const Uuid().v4(),
    userId: 'local_user',
    ref: BibleRef(
      book: verse.book,
      chapter: verse.chapter,
      verseStart: verse.verse,
      verseEnd: verse.verse,
    ),
    text: '$prefix ${verse.text}',
    createdAt: existing?.createdAt ?? DateTime.now(),
  );
  await db.upsertNote(note);
  return true;
}

bool _isBookmark(Note note) => note.text.startsWith('[bookmark]');
bool _isHighlight(Note note) => note.text.startsWith('[highlight]');
bool _isPersonalNote(Note note) => note.text.startsWith('[note]');

String _noteBody(String value) {
  return value
      .replaceFirst('[bookmark]', '')
      .replaceFirst('[highlight]', '')
      .replaceFirst('[note]', '')
      .trim();
}

Future<String?> _showPersonalNoteEditor(
  BuildContext context, {
  required String initialValue,
}) async {
  final controller = TextEditingController(text: initialValue);
  try {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Personal verse note'),
          content: TextField(
            controller: controller,
            maxLines: 6,
            minLines: 3,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Write your observation, prayer, or insight...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  } finally {
    controller.dispose();
  }
}

class _BibleActionIcon extends StatelessWidget {
  const _BibleActionIcon({
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Material(
        color: _bibleChrome,
        borderRadius: BorderRadius.circular(12),
        child: IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          constraints: const BoxConstraints.tightFor(width: 38, height: 38),
          padding: EdgeInsets.zero,
          icon: Icon(icon, color: _bibleTextPrimary, size: 20),
        ),
      ),
    );
  }
}

class _QuickNavigationBar extends StatelessWidget {
  const _QuickNavigationBar({
    required this.bookName,
    required this.chapter,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    required this.onJumpToVerse,
    required this.onOpenWheel,
    required this.onDisplayOptions,
  });

  final String? bookName;
  final int chapter;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Future<void> Function()? onJumpToVerse;
  final Future<void> Function()? onOpenWheel;
  final VoidCallback? onDisplayOptions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: _bibleChrome,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _bibleChromeBorder),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              color: _bibleTextPrimary,
              tooltip: 'Previous chapter',
              onPressed: canGoPrevious ? onPrevious : null,
            ),
            Expanded(
              child: Text(
                '${bookName ?? 'Bible'} $chapter',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _bibleTextPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              color: _bibleTextPrimary,
              tooltip: 'Next chapter',
              onPressed: canGoNext ? onNext : null,
            ),
            const SizedBox(width: 4),
            FilledButton.tonalIcon(
              onPressed: onJumpToVerse,
              icon: const Icon(Icons.pin_drop_outlined),
              style: FilledButton.styleFrom(
                foregroundColor: const Color(0xFF0E1A2B),
                backgroundColor: const Color(0xFFB8C7DB),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
              label: const Text('Verse'),
            ),
            IconButton(
              icon: const Icon(Icons.unfold_more),
              color: _bibleTextPrimary,
              tooltip: 'Wheel navigation',
              onPressed: onOpenWheel,
            ),
            IconButton(
              icon: const Icon(Icons.text_fields),
              color: _bibleTextPrimary,
              tooltip: 'Display options',
              onPressed: onDisplayOptions,
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

class _VerseJumpSheet extends StatelessWidget {
  const _VerseJumpSheet({
    required this.verseCount,
    required this.selectedVerse,
  });

  final int verseCount;
  final int? selectedVerse;

  @override
  Widget build(BuildContext context) {
    final bottomInset = standardBottomContentPadding(context);
    final theme = Theme.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.35),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Jump to verse',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a verse to jump directly to it',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(16, 8, 16, bottomInset),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: verseCount,
              itemBuilder: (context, index) {
                final verseNo = index + 1;
                final isSelected = verseNo == selectedVerse;

                return FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    foregroundColor: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => Navigator.of(context).pop(verseNo),
                  child: Text(
                    '$verseNo',
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StudyLibrarySheet extends StatelessWidget {
  const _StudyLibrarySheet({
    required this.notes,
    required this.onOpen,
    required this.onDelete,
  });

  final List<Note> notes;
  final ValueChanged<Note> onOpen;
  final Future<void> Function(Note note) onDelete;

  @override
  Widget build(BuildContext context) {
    final bottomInset = standardBottomContentPadding(context);
    final bookmarks = notes.where(_isBookmark).toList();
    final highlights = notes.where(_isHighlight).toList();
    final personal = notes.where(_isPersonalNote).toList();

    return DefaultTabController(
      length: 3,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              'Study Library',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const TabBar(
              tabs: [
                Tab(text: 'Bookmarks'),
                Tab(text: 'Highlights'),
                Tab(text: 'Notes'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _MarkerList(
                    notes: bookmarks,
                    emptyLabel: 'No bookmarks yet.',
                    bottomInset: bottomInset,
                    onOpen: onOpen,
                    onDelete: onDelete,
                  ),
                  _MarkerList(
                    notes: highlights,
                    emptyLabel: 'No highlights yet.',
                    bottomInset: bottomInset,
                    onOpen: onOpen,
                    onDelete: onDelete,
                  ),
                  _MarkerList(
                    notes: personal,
                    emptyLabel: 'No personal notes yet.',
                    bottomInset: bottomInset,
                    onOpen: onOpen,
                    onDelete: onDelete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isBookmark(Note note) => note.text.startsWith('[bookmark]');
  bool _isHighlight(Note note) => note.text.startsWith('[highlight]');
}

class _MarkerList extends StatelessWidget {
  const _MarkerList({
    required this.notes,
    required this.emptyLabel,
    required this.bottomInset,
    required this.onOpen,
    required this.onDelete,
  });

  final List<Note> notes;
  final String emptyLabel;
  final double bottomInset;
  final ValueChanged<Note> onOpen;
  final Future<void> Function(Note note) onDelete;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return Center(child: Text(emptyLabel));
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(12, 12, 12, bottomInset),
      itemCount: notes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final note = notes[index];
        final label =
            '${note.ref.book} ${note.ref.chapter}:${note.ref.verseStart ?? ''}';
        final preview = _noteBody(note.text);
        return ListTile(
          tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(label),
          subtitle: Text(
            preview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => onOpen(note),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => onDelete(note),
          ),
        );
      },
    );
  }
}

class _DisplayOptionsSheet extends StatefulWidget {
  const _DisplayOptionsSheet({
    required this.fontScale,
    required this.onFontScaleChanged,
    required this.fontStyle,
    required this.onFontStyleChanged,
    required this.translation,
    required this.onTranslationChanged,
  });

  final double fontScale;
  final ValueChanged<double> onFontScaleChanged;
  final ReadingFontStyle fontStyle;
  final ValueChanged<ReadingFontStyle> onFontStyleChanged;
  final Translation translation;
  final ValueChanged<Translation> onTranslationChanged;

  @override
  State<_DisplayOptionsSheet> createState() => _DisplayOptionsSheetState();
}

class _DisplayOptionsSheetState extends State<_DisplayOptionsSheet> {
  late double _fontScale = widget.fontScale;
  late ReadingFontStyle _fontStyle = widget.fontStyle;
  late Translation _translation = widget.translation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + mediaQuery.viewPadding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Reading preferences', style: theme.textTheme.titleLarge),
          const SizedBox(height: 24),
          Text('Font size', style: theme.textTheme.titleMedium),
          Slider(
            value: _fontScale,
            min: 0.8,
            max: 1.6,
            divisions: 8,
            label: '${(_fontScale * 100).round()}%',
            onChanged: (value) {
              setState(() => _fontScale = value);
              widget.onFontScaleChanged(value);
            },
          ),
          const SizedBox(height: 16),
          Text('Font style', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<ReadingFontStyle>(
            segments: const <ButtonSegment<ReadingFontStyle>>[
              ButtonSegment(
                value: ReadingFontStyle.serif,
                label: Text('Serif'),
              ),
              ButtonSegment(
                value: ReadingFontStyle.sans,
                label: Text('Sans-serif'),
              ),
            ],
            selected: <ReadingFontStyle>{_fontStyle},
            onSelectionChanged: (selection) {
              final value = selection.first;
              setState(() => _fontStyle = value);
              widget.onFontStyleChanged(value);
            },
          ),
          const SizedBox(height: 16),
          Text('Translation', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<Translation>(
            initialValue: _translation,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: Translation.values
                .map(
                  (translation) => DropdownMenuItem<Translation>(
                    value: translation,
                    child: Text(_translationLabel(translation)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() => _translation = value);
              widget.onTranslationChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

String _translationLabel(Translation translation) {
  switch (translation) {
    case Translation.kjv:
      return 'King James Version (KJV)';
    case Translation.shona:
      return 'Shona Bible';
  }
}

class _PassageSelectorSheet extends HookWidget {
  const _PassageSelectorSheet({
    required this.books,
    required this.initialBookNumber,
    required this.initialChapter,
    required this.translation,
    required this.bibleService,
  });

  final List<BibleBook> books;
  final int? initialBookNumber;
  final int initialChapter;
  final Translation translation;
  final BibleService bibleService;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = 16 + mediaQuery.viewPadding.bottom;
    final activeBookNumber = useState<int?>(
      initialBookNumber ?? books.first.number,
    );

    final initialTabIndex = _tabIndexFor(
      activeBookNumber.value ?? books.first.number,
    );
    final tabController = useTabController(
      initialLength: 2,
      initialIndex: initialTabIndex,
    );

    useEffect(() {
      final bookNumber = activeBookNumber.value;
      if (bookNumber != null) {
        final index = _tabIndexFor(bookNumber);
        if (tabController.index != index) {
          tabController.index = index;
        }
      }
      return null;
    }, <Object?>[activeBookNumber.value]);

    final selectedChapter = useState(initialChapter);

    useEffect(() {
      if (activeBookNumber.value == initialBookNumber) {
        selectedChapter.value = initialChapter;
      } else {
        selectedChapter.value = 1;
      }
      return null;
    }, <Object?>[activeBookNumber.value]);

    final activeBook =
        books.firstWhereOrNull(
          (book) => book.number == activeBookNumber.value,
        ) ??
        books.first;

    final chapterCountFuture = useMemoized(
      () => bibleService.getChapterCount(activeBook.name, translation),
      <Object?>[activeBook.number, translation],
    );
    final chapterCountSnapshot = useFuture(chapterCountFuture);

    final oldTestamentBooks = useMemoized(
      () => books.where((book) => book.testament == Testament.old).toList(),
      <Object?>[books],
    );
    final newTestamentBooks = useMemoized(
      () => books
          .where((book) => book.testament == Testament.newTestament)
          .toList(),
      <Object?>[books],
    );

    final handleColor = Colors.white.withValues(alpha: 0.35);

    return SafeArea(
      child: SizedBox(
        height: mediaQuery.size.height * 0.84,
        child: Container(
          decoration: BoxDecoration(
            color: _bibleChrome,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: _bibleChromeBorder),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 12),
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select passage',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: _bibleTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TabBar(
                controller: tabController,
                labelColor: _bibleTextPrimary,
                unselectedLabelColor: _bibleTextSecondary,
                indicatorColor: const Color(0xFFB8C7DB),
                tabs: const <Widget>[
                  Tab(text: 'Old Testament'),
                  Tab(text: 'New Testament'),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: TabBarView(
                        controller: tabController,
                        children: <Widget>[
                          _BookGrid(
                            books: oldTestamentBooks,
                            activeBook: activeBook,
                            onSelected: (book) =>
                                activeBookNumber.value = book.number,
                          ),
                          _BookGrid(
                            books: newTestamentBooks,
                            activeBook: activeBook,
                            onSelected: (book) =>
                                activeBookNumber.value = book.number,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Chapters in ${activeBook.name}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: _bibleTextPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      flex: 4,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Builder(
                          key: ValueKey<int?>(activeBook.number),
                          builder: (context) {
                            if (chapterCountSnapshot.hasError) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'Unable to load chapters for ${activeBook.name}.',
                                    style: const TextStyle(
                                      color: _bibleTextSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            if (chapterCountSnapshot.connectionState !=
                                ConnectionState.done) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final count = chapterCountSnapshot.data ?? 0;
                            if (count == 0) {
                              return const Center(
                                child: Text(
                                  'No chapters available.',
                                  style: TextStyle(color: _bibleTextSecondary),
                                ),
                              );
                            }

                            return _ChapterGrid(
                              chapterCount: count,
                              selectedChapter: selectedChapter.value,
                              onSelected: (chapter) {
                                Navigator.of(context).pop(
                                  _PassageSelectionResult(
                                    book: activeBook,
                                    chapter: chapter,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: bottomInset),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookGrid extends StatelessWidget {
  const _BookGrid({
    required this.books,
    required this.activeBook,
    required this.onSelected,
  });

  final List<BibleBook> books;
  final BibleBook activeBook;
  final ValueChanged<BibleBook> onSelected;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const Center(child: Text('No books available.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        final isSelected = activeBook.number == book.number;
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected
                ? const Color(0xFFB8C7DB)
                : Colors.white.withValues(alpha: 0.08),
            foregroundColor: isSelected
                ? const Color(0xFF0E1A2B)
                : _bibleTextPrimary,
            side: BorderSide(
              color: isSelected
                  ? const Color(0xFFB8C7DB)
                  : Colors.white.withValues(alpha: 0.14),
            ),
          ),
          onPressed: () => onSelected(book),
          child: Text(
            book.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

class _ChapterGrid extends StatelessWidget {
  const _ChapterGrid({
    required this.chapterCount,
    required this.selectedChapter,
    required this.onSelected,
  });

  final int chapterCount;
  final int selectedChapter;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: chapterCount,
      itemBuilder: (context, index) {
        final chapter = index + 1;
        final isSelected = selectedChapter == chapter;
        return FilledButton.tonal(
          style: FilledButton.styleFrom(
            backgroundColor: isSelected
                ? const Color(0xFFB8C7DB)
                : Colors.white.withValues(alpha: 0.08),
            foregroundColor: isSelected
                ? const Color(0xFF0E1A2B)
                : _bibleTextPrimary,
          ),
          onPressed: () => onSelected(chapter),
          child: Text('$chapter'),
        );
      },
    );
  }
}

class _PassageSelectionResult {
  const _PassageSelectionResult({required this.book, required this.chapter});

  final BibleBook book;
  final int chapter;
}

class _WheelNavigationResult {
  const _WheelNavigationResult({
    required this.book,
    required this.chapter,
    this.verse,
  });

  final BibleBook book;
  final int chapter;
  final int? verse;
}

class _ScrollWheelNavigationSheet extends StatefulWidget {
  const _ScrollWheelNavigationSheet({
    required this.books,
    required this.initialBookNumber,
    required this.initialChapter,
    required this.initialVerse,
    required this.translation,
    required this.bibleService,
  });

  final List<BibleBook> books;
  final int? initialBookNumber;
  final int initialChapter;
  final int? initialVerse;
  final Translation translation;
  final BibleService bibleService;

  @override
  State<_ScrollWheelNavigationSheet> createState() =>
      _ScrollWheelNavigationSheetState();
}

class _ScrollWheelNavigationSheetState
    extends State<_ScrollWheelNavigationSheet> {
  late BibleBook _selectedBook;
  late int _selectedChapter;
  late int _selectedVerse;
  int _chapterCount = 1;
  int _verseCount = 1;
  bool _isLoading = true;

  late FixedExtentScrollController _bookController;
  late FixedExtentScrollController _chapterController;
  late FixedExtentScrollController _verseController;

  @override
  void initState() {
    super.initState();
    _selectedBook =
        widget.books.firstWhereOrNull(
          (book) => book.number == widget.initialBookNumber,
        ) ??
        widget.books.first;
    _selectedChapter = widget.initialChapter;
    _selectedVerse = widget.initialVerse ?? 1;

    final initialBookIndex = widget.books.indexWhere(
      (book) => book.number == _selectedBook.number,
    );
    _bookController = FixedExtentScrollController(
      initialItem: initialBookIndex < 0 ? 0 : initialBookIndex,
    );
    _chapterController = FixedExtentScrollController();
    _verseController = FixedExtentScrollController();
    _loadCounts();
  }

  @override
  void dispose() {
    _bookController.dispose();
    _chapterController.dispose();
    _verseController.dispose();
    super.dispose();
  }

  Future<void> _loadCounts() async {
    setState(() => _isLoading = true);
    final chapterCount = await widget.bibleService.getChapterCount(
      _selectedBook.name,
      widget.translation,
    );
    final normalizedChapter = chapterCount <= 0
        ? 1
        : _selectedChapter.clamp(1, chapterCount);
    final verseCount = (await widget.bibleService.getChapter(
      _selectedBook.name,
      normalizedChapter,
      widget.translation,
    )).length;
    final normalizedVerse = verseCount <= 0
        ? 1
        : _selectedVerse.clamp(1, verseCount);

    if (!mounted) {
      return;
    }
    setState(() {
      _chapterCount = chapterCount <= 0 ? 1 : chapterCount;
      _verseCount = verseCount <= 0 ? 1 : verseCount;
      _selectedChapter = normalizedChapter;
      _selectedVerse = normalizedVerse;
      _isLoading = false;
    });

    _jumpToControllers();
  }

  Future<void> _loadVerseCount() async {
    setState(() => _isLoading = true);
    final verseCount = (await widget.bibleService.getChapter(
      _selectedBook.name,
      _selectedChapter,
      widget.translation,
    )).length;
    if (!mounted) {
      return;
    }
    setState(() {
      _verseCount = verseCount <= 0 ? 1 : verseCount;
      if (_selectedVerse > _verseCount) {
        _selectedVerse = _verseCount;
      }
      _isLoading = false;
    });
    _jumpToControllers();
  }

  void _jumpToControllers() {
    if (_chapterController.hasClients) {
      _chapterController.jumpToItem(_selectedChapter - 1);
    }
    if (_verseController.hasClients) {
      _verseController.jumpToItem(_selectedVerse - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final textStyle = theme.textTheme.titleMedium;
    final selectedTextStyle = textStyle?.copyWith(
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.primary,
    );

    return SizedBox(
      height: mediaQuery.size.height * 0.72,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          16 + mediaQuery.viewPadding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.35,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Wheel navigation',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Scroll to select book, chapter, and verse',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: _buildWheel(
                      controller: _bookController,
                      itemCount: widget.books.length,
                      itemBuilder: (index, isSelected) => Text(
                        widget.books[index].name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: isSelected ? selectedTextStyle : textStyle,
                      ),
                      selectedIndex: widget.books.indexWhere(
                        (book) => book.number == _selectedBook.number,
                      ),
                      onSelected: (index) async {
                        setState(() {
                          _selectedBook = widget.books[index];
                          _selectedChapter = 1;
                          _selectedVerse = 1;
                        });
                        await _loadCounts();
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildWheel(
                      controller: _chapterController,
                      itemCount: _chapterCount,
                      itemBuilder: (index, isSelected) => Text(
                        '${index + 1}',
                        textAlign: TextAlign.center,
                        style: isSelected ? selectedTextStyle : textStyle,
                      ),
                      selectedIndex: _selectedChapter - 1,
                      onSelected: (index) async {
                        setState(() {
                          _selectedChapter = index + 1;
                          _selectedVerse = 1;
                        });
                        await _loadVerseCount();
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildWheel(
                      controller: _verseController,
                      itemCount: _verseCount,
                      itemBuilder: (index, isSelected) => Text(
                        '${index + 1}',
                        textAlign: TextAlign.center,
                        style: isSelected ? selectedTextStyle : textStyle,
                      ),
                      selectedIndex: _selectedVerse - 1,
                      onSelected: (index) {
                        setState(() {
                          _selectedVerse = index + 1;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.of(context).pop(
                              _WheelNavigationResult(
                                book: _selectedBook,
                                chapter: _selectedChapter,
                                verse: _selectedVerse,
                              ),
                            );
                          },
                    child: const Text('Go'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required Widget Function(int index, bool isSelected) itemBuilder,
    required int selectedIndex,
    required ValueChanged<int> onSelected,
  }) {
    final clampedSelected = selectedIndex.clamp(0, itemCount - 1);
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 44,
      diameterRatio: 1.6,
      onSelectedItemChanged: onSelected,
      physics: const FixedExtentScrollPhysics(),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          if (index < 0 || index >= itemCount) {
            return null;
          }
          return Center(child: itemBuilder(index, index == clampedSelected));
        },
      ),
    );
  }
}

class _PassageLocation {
  const _PassageLocation({
    required this.bookNumber,
    required this.chapter,
  });

  final int bookNumber;
  final int chapter;

  @override
  int get hashCode => Object.hash(bookNumber, chapter);

  @override
  bool operator ==(Object other) {
    return other is _PassageLocation &&
        other.bookNumber == bookNumber &&
        other.chapter == chapter;
  }
}

class _BibleSearchDelegate extends SearchDelegate<BibleRef?> {
  _BibleSearchDelegate({required this.bibleService, required this.translation})
    : super(searchFieldLabel: 'Search Bible');

  final BibleService bibleService;
  final Translation translation;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildResultList();

  @override
  Widget buildSuggestions(BuildContext context) => _buildResultList();

  Widget _buildResultList() {
    final trimmedQuery = query.trim();
    if (trimmedQuery.length < 3) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Enter at least three characters to search.'),
        ),
      );
    }

    return FutureBuilder<List<VerseSearchHit>>(
      future: bibleService.search(trimmedQuery, translation),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Search failed: ${snapshot.error}'));
        }
        final results = snapshot.data ?? <VerseSearchHit>[];
        if (results.isEmpty) {
          return const Center(child: Text('No verses found.'));
        }
        return ListView.separated(
          itemCount: results.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final hit = results[index];
            return ListTile(
              title: Text(hit.reference),
              subtitle: Text(
                hit.preview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                final reference = _parseReference(hit.reference);
                if (reference == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Unable to open ${hit.reference}'),
                    ),
                  );
                  return;
                }
                close(context, reference);
              },
            );
          },
        );
      },
    );
  }

  BibleRef? _parseReference(String reference) {
    final match = RegExp(r'^(.+)\s+(\d+):(\d+)$').firstMatch(reference.trim());
    if (match == null) {
      return null;
    }

    final book = match.group(1)!.trim();
    final chapter = int.tryParse(match.group(2)!);
    if (chapter == null) {
      return null;
    }

    final verse = int.tryParse(match.group(3)!);
    return BibleRef(
      book: book,
      chapter: chapter,
      verseStart: verse,
      verseEnd: verse,
    );
  }
}

enum ReadingFontStyle { serif, sans }

int _tabIndexFor(int bookNumber) => bookNumber <= 39 ? 0 : 1;
