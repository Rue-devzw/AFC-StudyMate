import 'dart:async';
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
const _bibleSurface = Color(0xCC18212C);
const _bibleSurfaceStrong = Color(0xE61A2430);
const _bibleAccent = Color(0xFF9FD7FF);
const _bibleAccentSoft = Color(0x33249BFF);
const _bibleHighlightSurface = Color(0x22F6C454);
const _bibleNoteSurface = Color(0x14FFFFFF);

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
    final palette = PremiumSurfaceScope.of(context);
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
    final chapterNotes = notesSnapshot.data ?? <Note>[];
    final chapterBookmarks = chapterNotes.where(_isBookmark).length;
    final chapterPersonalNotes = chapterNotes.where(_isPersonalNote).length;
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
      backgroundSlot: PremiumBackgroundSlots.bible,
      appBar: AppBar(
        titleSpacing: 6,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: palette.backdropPrimaryText,
            fontWeight: FontWeight.w800,
            fontSize: 16,
            letterSpacing: 0,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
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
            translationLabel: _translationLabel(translation.value),
            verseCount: verses.length,
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
            onSelectPassage:
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
            onOpenWheel: openScrollWheelNavigation,
            onDisplayOptions: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                useSafeArea: true,
                backgroundColor: Colors.transparent,
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

                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    standardBottomContentPadding(context),
                  ),
                  child: SizedBox.expand(
                    child: PremiumGlassCard(
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(28),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                            child: _ReaderStatusStrip(
                              chapterNotes: chapterPersonalNotes,
                              chapterBookmarks: chapterBookmarks,
                            ),
                          ),
                          const Divider(height: 1, color: _bibleChromeBorder),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                18,
                                18,
                                18,
                                24,
                              ),
                              itemCount: verses.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 14),
                              itemBuilder: (context, index) {
                                final verse = verses[index];
                                final verseNotes =
                                    notesByVerse[verse.verse] ?? <Note>[];
                                final bookmarkNote = verseNotes
                                    .firstWhereOrNull(
                                      _isBookmark,
                                    );
                                final highlightNote = verseNotes
                                    .firstWhereOrNull(_isHighlight);
                                final inlineNote = verseNotes.firstWhereOrNull(
                                  _isPersonalNote,
                                );
                                final verseKey = verseItemKeys.putIfAbsent(
                                  verse.verse,
                                  GlobalKey.new,
                                );
                                if (pendingVerseJump.value == verse.verse) {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    final verseContext =
                                        verseKey.currentContext;
                                    if (verseContext != null) {
                                      Scrollable.ensureVisible(
                                        verseContext,
                                        duration: const Duration(
                                          milliseconds: 240,
                                        ),
                                        curve: Curves.easeOutCubic,
                                        alignment: 0.15,
                                      );
                                    }
                                    if (pendingVerseJump.value == verse.verse) {
                                      pendingVerseJump.value = null;
                                    }
                                  });
                                }

                                final hasReaderHighlight =
                                    highlightVerseNumber == verse.verse;

                                return _VerseReadingCard(
                                  key: verseKey,
                                  verse: verse,
                                  textStyle: textStyle,
                                  verseNumberStyle: verseNumberStyle,
                                  bookmarkNote: bookmarkNote,
                                  highlightNote: highlightNote,
                                  inlineNote: inlineNote,
                                  isFocused: hasReaderHighlight,
                                  onPressed: () async {
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
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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

class _ReaderStatusStrip extends StatelessWidget {
  const _ReaderStatusStrip({
    required this.chapterNotes,
    required this.chapterBookmarks,
  });

  final int chapterNotes;
  final int chapterBookmarks;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          _CompactReaderMetaChip(
            icon: Icons.sticky_note_2_outlined,
            label: '$chapterNotes notes',
          ),
          const SizedBox(width: 8),
          _CompactReaderMetaChip(
            icon: Icons.bookmark_outline_rounded,
            label: '$chapterBookmarks bookmarks',
          ),
          const SizedBox(width: 8),
          const _CompactReaderMetaChip(
            icon: Icons.touch_app_outlined,
            label: 'Tap verse for actions',
          ),
        ],
      ),
    );
  }
}

class _CompactReaderMetaChip extends StatelessWidget {
  const _CompactReaderMetaChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = PremiumSurfaceScope.of(context);
    final isDarkBackdrop = palette.backdropPrimaryText.computeLuminance() > 0.7;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: isDarkBackdrop
            ? const Color(0x40111821)
            : const Color(0xFFF3EAD1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDarkBackdrop ? _bibleChromeBorder : const Color(0xFFE0CFA1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: isDarkBackdrop
                ? _bibleTextSecondary
                : const Color(0xFF5B4A2F),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isDarkBackdrop
                  ? _bibleTextSecondary
                  : const Color(0xFF5B4A2F),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerseReadingCard extends StatelessWidget {
  const _VerseReadingCard({
    required this.verse,
    required this.textStyle,
    required this.verseNumberStyle,
    required this.bookmarkNote,
    required this.highlightNote,
    required this.inlineNote,
    required this.isFocused,
    required this.onPressed,
    super.key,
  });

  final Verse verse;
  final TextStyle textStyle;
  final TextStyle verseNumberStyle;
  final Note? bookmarkNote;
  final Note? highlightNote;
  final Note? inlineNote;
  final bool isFocused;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = PremiumSurfaceScope.of(context);
    final isDarkBackdrop = palette.backdropPrimaryText.computeLuminance() > 0.7;
    final theme = Theme.of(context);
    final verseText = Text(
      verse.text,
      style: textStyle.copyWith(
        color: isDarkBackdrop ? _bibleTextPrimary : const Color(0xFF2A241A),
        shadows: isDarkBackdrop
            ? const [
                Shadow(
                  color: Color(0x90000000),
                  blurRadius: 2,
                ),
              ]
            : null,
      ),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: highlightNote != null
            ? (isDarkBackdrop
                  ? _bibleHighlightSurface
                  : const Color(0x1AF6C454))
            : (isDarkBackdrop
                  ? const Color(0xCC18212C)
                  : const Color(0xFFF8F1DE)),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isFocused
              ? _bibleAccent
              : (isDarkBackdrop ? _bibleChromeBorder : const Color(0xFFD7C7A0)),
          width: isFocused ? 1.3 : 1,
        ),
        boxShadow: <BoxShadow>[
          if (!isDarkBackdrop)
            const BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          if (isFocused)
            const BoxShadow(
              color: Color(0x33249BFF),
              blurRadius: 22,
              offset: Offset(0, 12),
            ),
        ],
      ),
      child: InkWell(
        onTap: onPressed,
        onLongPress: onPressed,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isFocused
                          ? _bibleAccentSoft
                          : (isDarkBackdrop
                                ? _bibleSurface
                                : const Color(0xFF454D57)),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDarkBackdrop
                            ? _bibleChromeBorder
                            : const Color(0xFF566171),
                      ),
                    ),
                    child: Text(
                      '${verse.verse}',
                      style: verseNumberStyle.copyWith(
                        color: isFocused
                            ? _bibleAccent
                            : (isDarkBackdrop
                                  ? _bibleTextSecondary
                                  : const Color(0xFFE9EEF8)),
                        fontWeight: FontWeight.w800,
                        fontSize: (textStyle.fontSize ?? 16) * 0.72,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: verseText),
                  if (bookmarkNote != null || highlightNote != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 2),
                      child: Column(
                        children: [
                          if (bookmarkNote != null)
                            const Icon(
                              Icons.bookmark_rounded,
                              size: 18,
                              color: _bibleAccent,
                            ),
                          if (highlightNote != null)
                            const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Icon(
                                Icons.highlight_alt_rounded,
                                size: 18,
                                color: Color(0xFFF6D566),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
              if (inlineNote != null) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDarkBackdrop
                        ? _bibleSurfaceStrong
                        : const Color(0xFFF2E6C7),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDarkBackdrop
                          ? _bibleChromeBorder
                          : const Color(0xFFD7C7A0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal note',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: _bibleAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _noteBody(inlineNote!.text),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDarkBackdrop
                              ? _bibleTextPrimary
                              : const Color(0xFF2A241A),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ReaderActionButton extends StatelessWidget {
  const _ReaderActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.emphasized = false,
    this.compact = false,
  });

  final IconData icon;
  final String label;
  final FutureOr<void> Function()? onPressed;
  final bool emphasized;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final background = emphasized ? _bibleAccentSoft : _bibleNoteSurface;
    final foreground = emphasized ? _bibleTextPrimary : _bibleTextSecondary;
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onPressed == null ? null : () => onPressed!(),
        borderRadius: BorderRadius.circular(compact ? 16 : 18),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 14,
            vertical: compact ? 10 : 12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: compact ? 17 : 18, color: foreground),
              SizedBox(width: compact ? 6 : 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 14 : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = PremiumSurfaceScope.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          style:
              Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(
                color: palette.backdropSecondaryText,
              ),
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
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final mediaQuery = MediaQuery.of(context);
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: mediaQuery.size.height * 0.82,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: _bibleSurfaceStrong,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                18,
                12,
                18,
                22 + mediaQuery.viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _bibleTextSecondary.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '${verse.book} ${verse.chapter}:${verse.verse}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: _bibleTextPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    verse.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _bibleTextSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  _VerseActionTile(
                    icon: Icons.copy_all_outlined,
                    title: 'Copy verse text',
                    subtitle: 'Keep this verse on your clipboard',
                    onTap: () => Navigator.pop(context, 'copy'),
                  ),
                  _VerseActionTile(
                    icon: Icons.share_outlined,
                    title: 'Share verse',
                    subtitle: 'Send it to someone else quickly',
                    onTap: () => Navigator.pop(context, 'share'),
                  ),
                  _VerseActionTile(
                    icon: Icons.bookmark_add_rounded,
                    title: existingBookmark == null
                        ? 'Bookmark verse'
                        : 'Update bookmark',
                    subtitle: 'Save it in your study library',
                    onTap: () => Navigator.pop(context, 'bookmark'),
                  ),
                  _VerseActionTile(
                    icon: Icons.highlight_alt_rounded,
                    title: existingHighlight == null
                        ? 'Highlight verse'
                        : 'Update highlight',
                    subtitle: 'Mark it visually in the chapter',
                    onTap: () => Navigator.pop(context, 'highlight'),
                  ),
                  _VerseActionTile(
                    icon: Icons.sticky_note_2_outlined,
                    title: existingPersonal == null
                        ? 'Add personal note'
                        : 'Edit personal note',
                    subtitle: 'Capture your reflection or observation',
                    onTap: () => Navigator.pop(context, 'note'),
                  ),
                  if (existingBookmark != null)
                    _VerseActionTile(
                      icon: Icons.bookmark_remove_outlined,
                      title: 'Remove bookmark',
                      subtitle: 'Clear this saved marker',
                      destructive: true,
                      onTap: () => Navigator.pop(context, 'remove_bookmark'),
                    ),
                  if (existingHighlight != null)
                    _VerseActionTile(
                      icon: Icons.highlight_off_outlined,
                      title: 'Remove highlight',
                      subtitle: 'Return the verse to normal reading',
                      destructive: true,
                      onTap: () => Navigator.pop(context, 'remove_highlight'),
                    ),
                  if (existingPersonal != null)
                    _VerseActionTile(
                      icon: Icons.delete_outline,
                      title: 'Remove personal note',
                      subtitle: 'Delete your saved note for this verse',
                      destructive: true,
                      onTap: () => Navigator.pop(context, 'remove_note'),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
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
  return showDialog<String>(
    context: context,
    builder: (context) {
      return _PersonalNoteEditorDialog(initialValue: initialValue);
    },
  );
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

class _PersonalNoteEditorDialog extends StatefulWidget {
  const _PersonalNoteEditorDialog({required this.initialValue});

  final String initialValue;

  @override
  State<_PersonalNoteEditorDialog> createState() =>
      _PersonalNoteEditorDialogState();
}

class _PersonalNoteEditorDialogState extends State<_PersonalNoteEditorDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personal verse note'),
      content: TextField(
        controller: _controller,
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
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _VerseActionTile extends StatelessWidget {
  const _VerseActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? const Color(0xFFFFB3B3) : _bibleTextPrimary;
    final subtitleColor = destructive
        ? const Color(0xFFFFD6D6)
        : _bibleTextSecondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: _bibleNoteSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: _bibleChromeBorder),
        ),
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: subtitleColor),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _QuickNavigationBar extends StatelessWidget {
  const _QuickNavigationBar({
    required this.bookName,
    required this.chapter,
    required this.translationLabel,
    required this.verseCount,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    required this.onJumpToVerse,
    required this.onSelectPassage,
    required this.onOpenWheel,
    required this.onDisplayOptions,
  });

  final String? bookName;
  final int chapter;
  final String translationLabel;
  final int verseCount;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Future<void> Function()? onJumpToVerse;
  final Future<void> Function()? onSelectPassage;
  final Future<void> Function()? onOpenWheel;
  final VoidCallback? onDisplayOptions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: _bibleSurface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _bibleChromeBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            children: [
              Row(
                children: [
                  _ChapterChromeButton(
                    icon: Icons.chevron_left_rounded,
                    tooltip: 'Previous chapter',
                    onPressed: canGoPrevious ? onPrevious : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${bookName ?? 'Bible'} $chapter',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _bibleTextPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$translationLabel • $verseCount verses',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _bibleTextSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _ChapterChromeButton(
                    icon: Icons.chevron_right_rounded,
                    tooltip: 'Next chapter',
                    onPressed: canGoNext ? onNext : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ReaderActionButton(
                      icon: Icons.menu_book_rounded,
                      label: 'Passage',
                      onPressed: onSelectPassage,
                      emphasized: true,
                      compact: true,
                    ),
                    const SizedBox(width: 8),
                    _ReaderActionButton(
                      icon: Icons.pin_drop_outlined,
                      label: 'Verse',
                      onPressed: onJumpToVerse,
                      compact: true,
                    ),
                    const SizedBox(width: 8),
                    _ReaderActionButton(
                      icon: Icons.unfold_more_rounded,
                      label: 'Wheel',
                      onPressed: onOpenWheel,
                      compact: true,
                    ),
                    const SizedBox(width: 8),
                    _ReaderActionButton(
                      icon: Icons.text_fields_rounded,
                      label: 'Display',
                      onPressed: onDisplayOptions,
                      compact: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterChromeButton extends StatelessWidget {
  const _ChapterChromeButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _bibleChrome,
      borderRadius: BorderRadius.circular(16),
      child: IconButton(
        icon: Icon(icon, color: _bibleTextPrimary),
        tooltip: tooltip,
        onPressed: onPressed,
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

    return Container(
      height: MediaQuery.of(context).size.height * 0.58,
      decoration: const BoxDecoration(
        color: _bibleSurfaceStrong,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: _bibleTextSecondary.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Jump to verse',
            style: theme.textTheme.titleLarge?.copyWith(
              color: _bibleTextPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a verse and we will move the reader straight to it.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: _bibleTextSecondary,
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
                        ? _bibleAccent
                        : _bibleNoteSurface,
                    foregroundColor: isSelected
                        ? const Color(0xFF0F1E33)
                        : _bibleTextPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: const BorderSide(color: _bibleChromeBorder),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => Navigator.of(context).pop(verseNo),
                  child: Text(
                    '$verseNo',
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
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

class _StudyLibrarySheet extends StatefulWidget {
  const _StudyLibrarySheet({
    required this.notes,
    required this.onOpen,
    required this.onDelete,
  });

  final List<Note> notes;
  final ValueChanged<Note> onOpen;
  final Future<void> Function(Note note) onDelete;

  @override
  State<_StudyLibrarySheet> createState() => _StudyLibrarySheetState();
}

class _StudyLibrarySheetState extends State<_StudyLibrarySheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  )..addListener(_handleTabChange);

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChange)
      ..dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = standardBottomContentPadding(context);
    final bookmarks = widget.notes.where(_isBookmark).toList();
    final highlights = widget.notes.where(_isHighlight).toList();
    final personal = widget.notes.where(_isPersonalNote).toList();
    final tabs = <List<Note>>[bookmarks, highlights, personal];
    final activeCount = tabs[_tabController.index].length;
    final maxHeight = MediaQuery.of(context).size.height * 0.75;
    final bodyHeight = activeCount == 0
        ? 132.0
        : (activeCount * 108.0).clamp(132.0, 380.0);
    const headerHeight = 164.0;
    final sheetHeight = (headerHeight + bodyHeight + bottomInset).clamp(
      320.0,
      maxHeight,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      height: sheetHeight,
      decoration: const BoxDecoration(
        color: _bibleSurfaceStrong,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: _bibleTextSecondary.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Study Library',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: _bibleTextPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Reopen saved verses, notes, and highlights from your reading journey.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xDDE3ECFF),
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TabBar(
            controller: _tabController,
            labelColor: _bibleTextPrimary,
            unselectedLabelColor: const Color(0x99D8E2F2),
            indicatorColor: _bibleAccent,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            tabs: const [
              Tab(text: 'Bookmarks'),
              Tab(text: 'Highlights'),
              Tab(text: 'Notes'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _MarkerList(
                  notes: bookmarks,
                  emptyLabel: 'No bookmarks yet.',
                  bottomInset: bottomInset,
                  onOpen: widget.onOpen,
                  onDelete: widget.onDelete,
                ),
                _MarkerList(
                  notes: highlights,
                  emptyLabel: 'No highlights yet.',
                  bottomInset: bottomInset,
                  onOpen: widget.onOpen,
                  onDelete: widget.onDelete,
                ),
                _MarkerList(
                  notes: personal,
                  emptyLabel: 'No personal notes yet.',
                  bottomInset: bottomInset,
                  onOpen: widget.onOpen,
                  onDelete: widget.onDelete,
                ),
              ],
            ),
          ),
        ],
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
      return Center(
        child: Text(
          emptyLabel,
          style:
              Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(
                color: const Color(0xDDE3ECFF),
                fontWeight: FontWeight.w500,
              ),
        ),
      );
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
          tileColor: const Color(0x241E2A39),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: _bibleChromeBorder),
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: _bibleTextPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            preview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xDDE3ECFF),
              height: 1.45,
            ),
          ),
          onTap: () => onOpen(note),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Color(0xDDE3ECFF),
            ),
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
    return Container(
      decoration: const BoxDecoration(
        color: _bibleSurfaceStrong,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          16,
          24,
          24 + mediaQuery.viewPadding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: _bibleTextSecondary.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Reading preferences',
              style: theme.textTheme.titleLarge?.copyWith(
                color: _bibleTextPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Shape the Bible reader for comfort, clarity, and focus.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _bibleTextSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Font size',
              style: theme.textTheme.titleMedium?.copyWith(
                color: _bibleTextPrimary,
              ),
            ),
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
            Text(
              'Font style',
              style: theme.textTheme.titleMedium?.copyWith(
                color: _bibleTextPrimary,
              ),
            ),
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
            Text(
              'Translation',
              style: theme.textTheme.titleMedium?.copyWith(
                color: _bibleTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Translation>(
              initialValue: _translation,
              dropdownColor: _bibleSurfaceStrong,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: _bibleTextPrimary,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: _bibleNoteSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
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
