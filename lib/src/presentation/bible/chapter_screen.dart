import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/annotations/entities.dart';
import '../../domain/bible/entities.dart';
import '../../domain/bible/reading_progress/entities.dart';
import '../providers.dart';

const _highlightPalette = <String>[
  '#FFF59D',
  '#FFE082',
  '#FFCDD2',
  '#C5CAE9',
  '#C8E6C9',
];

class ChapterScreen extends ConsumerStatefulWidget {
  const ChapterScreen({
    super.key,
    required this.book,
    required this.chapter,
  });

  final BibleBook book;
  final int chapter;

  @override
  ConsumerState<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends ConsumerState<ChapterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final translationIds = ref.watch(selectedTranslationIdsProvider);
    final translationsAsync = ref.watch(translationsProvider);
    final translationsById = translationsAsync.maybeWhen(
      data: (data) => {for (final translation in data) translation.id: translation},
      orElse: () => <String, BibleTranslation>{},
    );
    final userId = ref.watch(activeUserIdProvider);
    if (userId == null || userId.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final parallelAsync = ref.watch(
      parallelChapterProvider(
        ParallelChapterRequest(
          translationIds: translationIds,
          bookId: widget.book.id,
          chapter: widget.chapter,
        ),
      ),
    );

    final bookmarkLookup = <String, Map<int, Bookmark>>{};
    final highlightLookup = <String, Map<int, Highlight>>{};
    final noteLookup = <String, Map<int, Note>>{};

    for (final translationId in translationIds) {
      final request = AnnotationRequest(
        userId: userId,
        translationId: translationId,
        bookId: widget.book.id,
        chapter: widget.chapter,
      );
      final bookmarks = ref.watch(chapterBookmarksProvider(request));
      final highlights = ref.watch(chapterHighlightsProvider(request));
      final notes = ref.watch(chapterNotesProvider(request));
      bookmarkLookup[translationId] = bookmarks.maybeWhen(
        data: (list) => {for (final item in list) item.location.verse: item},
        orElse: () => <int, Bookmark>{},
      );
      highlightLookup[translationId] = highlights.maybeWhen(
        data: (list) => {for (final item in list) item.location.verse: item},
        orElse: () => <int, Highlight>{},
      );
      noteLookup[translationId] = notes.maybeWhen(
        data: (list) => {for (final item in list) item.location.verse: item},
        orElse: () => <int, Note>{},
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${widget.book.name} ${widget.chapter}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sticky_note_2_outlined),
            tooltip: 'Annotations',
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: _AnnotationDrawer(book: widget.book, chapter: widget.chapter),
      body: parallelAsync.when(
        data: (rows) {
          if (rows.isEmpty) {
            return const Center(child: Text('No verses available for this chapter.'));
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    for (final translationId in translationIds)
                      Expanded(
                        child: Text(
                          translationsById[translationId]?.name ?? translationId,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: rows.length,
                  itemBuilder: (context, index) {
                    final row = rows[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final translationId in translationIds) ...[
                            Expanded(
                              child: _VerseColumn(
                                translationId: translationId,
                                verse: row.versesByTranslation[translationId],
                                isPrimary: translationId == translationIds.first,
                                bookmark: bookmarkLookup[translationId]?[row.verseNumber],
                                highlight: highlightLookup[translationId]?[row.verseNumber],
                                note: noteLookup[translationId]?[row.verseNumber],
                                onLongPress: (verse) {
                                  if (verse == null) {
                                    return;
                                  }
                                  final bookmark = bookmarkLookup[translationId]?[verse.verse];
                                  final highlight = highlightLookup[translationId]?[verse.verse];
                                  final note = noteLookup[translationId]?[verse.verse];
                                  _showVerseActions(
                                    context,
                                    verse,
                                    bookmark,
                                    highlight,
                                    note,
                                    userId,
                                  );
                                },
                              ),
                            ),
                            if (translationId != translationIds.last)
                              const SizedBox(width: 12),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Failed to load chapter: $error'),
        ),
      ),
    );
  }
  Future<void> _showVerseActions(
    BuildContext context,
    BibleVerse verse,
    Bookmark? bookmark,
    Highlight? highlight,
    Note? note,
    String userId,
  ) async {
    final location = VerseLocation(
      translationId: verse.translationId,
      bookId: verse.bookId,
      chapter: verse.chapter,
      verse: verse.verse,
    );
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  Icon(bookmark == null ? Icons.bookmark_add_outlined : Icons.bookmark_remove),
              title: Text(bookmark == null ? 'Add bookmark' : 'Remove bookmark'),
              onTap: () async {
                Navigator.pop(sheetContext);
                await _toggleBookmark(context, location);
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens_outlined),
              title: const Text('Highlight verse'),
              onTap: () async {
                Navigator.pop(sheetContext);
                await _pickHighlightColour(context, location, highlight);
              },
            ),
            if (highlight != null)
              ListTile(
                leading: const Icon(Icons.format_color_reset),
                title: const Text('Remove highlight'),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await ref
                      .read(removeHighlightUseCaseProvider)(userId, highlight.id);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Highlight removed.')),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.note_alt_outlined),
              title: Text(note == null ? 'Add note' : 'Edit note'),
              onTap: () async {
                Navigator.pop(sheetContext);
                await _editNote(context, location, note);
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_open),
              title: const Text('Manage annotations'),
              onTap: () {
                Navigator.pop(sheetContext);
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleBookmark(BuildContext context, VerseLocation location) async {
    final userId = ref.read(activeUserIdProvider);
    if (userId == null || userId.isEmpty) {
      return;
    }
    final result = await ref.read(toggleBookmarkUseCaseProvider)(userId, location);
    if (!mounted) return;
    if (result != null) {
      await _updateReadingProgress(location);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark added.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark removed.')),
      );
    }
  }

  Future<void> _pickHighlightColour(
    BuildContext context,
    VerseLocation location,
    Highlight? existing,
  ) async {
    final userId = ref.read(activeUserIdProvider);
    if (userId == null || userId.isEmpty) {
      return;
    }
    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Choose highlight colour'),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final hex in _highlightPalette)
                  GestureDetector(
                    onTap: () => Navigator.pop(dialogContext, hex),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _colourFromHex(hex),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black26),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    if (selected == null) {
      return;
    }
    await ref.read(saveHighlightUseCaseProvider)(
      userId,
      Highlight(
        id: existing?.id ?? '',
        location: location,
        colour: selected,
        createdAt: DateTime.now(),
      ),
    );
    await _updateReadingProgress(location);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Highlight saved.')),
    );
  }

  Future<void> _editNote(
    BuildContext context,
    VerseLocation location,
    Note? note,
  ) async {
    final userId = ref.read(activeUserIdProvider);
    if (userId == null || userId.isEmpty) {
      return;
    }
    final controller = TextEditingController(text: note?.text ?? '');
    try {
      final result = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(note == null ? 'Add note' : 'Edit note'),
          content: TextField(
            controller: controller,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Note',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        ),
      );
      if (result == null) {
        return;
      }
      if (result.isEmpty) {
        if (note != null) {
          await ref.read(deleteNoteUseCaseProvider)(userId, note.id);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Note removed.')),
          );
        }
        return;
      }
      await ref.read(saveNoteUseCaseProvider)(userId, location, result);
      await _updateReadingProgress(location);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note saved.')),
      );
    } finally {
      controller.dispose();
    }
  }

  Future<void> _updateReadingProgress(VerseLocation location) {
    final userId = ref.read(activeUserIdProvider);
    if (userId == null || userId.isEmpty) {
      return Future.value();
    }
    final saveProgress = ref.read(saveReadingProgressUseCaseProvider);
    return saveProgress(
      userId,
      ReadingPosition(
        translationId: location.translationId,
        bookId: location.bookId,
        chapter: location.chapter,
        verse: location.verse,
        updatedAt: DateTime.now(),
      ),
    );
  }
}
class _VerseColumn extends StatelessWidget {
  const _VerseColumn({
    required this.translationId,
    required this.verse,
    required this.isPrimary,
    required this.bookmark,
    required this.highlight,
    required this.note,
    required this.onLongPress,
  });

  final String translationId;
  final BibleVerse? verse;
  final bool isPrimary;
  final Bookmark? bookmark;
  final Highlight? highlight;
  final Note? note;
  final ValueChanged<BibleVerse?> onLongPress;

  @override
  Widget build(BuildContext context) {
    final highlightColour = highlight != null ? _colourFromHex(highlight!.colour) : null;
    return GestureDetector(
      onLongPress: () => onLongPress(verse),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: highlightColour?.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPrimary
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: verse == null
            ? const Center(child: Text('—'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${verse!.verse}.',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (bookmark != null) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.bookmark,
                          size: 18,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    verse!.text,
                    style:
                        Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                  if (note != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.sticky_note_2_outlined, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            note!.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _AnnotationDrawer extends ConsumerWidget {
  const _AnnotationDrawer({required this.book, required this.chapter});

  final BibleBook book;
  final int chapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translationIds = ref.watch(selectedTranslationIdsProvider);
    final translations = ref.watch(translationsProvider).maybeWhen(
      data: (data) => {for (final translation in data) translation.id: translation},
      orElse: () => <String, BibleTranslation>{},
    );
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text('${book.name} $chapter'),
              subtitle: const Text('Annotations'),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                children: [
                  for (final translationId in translationIds)
                    _TranslationAnnotationSection(
                      book: book,
                      chapter: chapter,
                      translationId: translationId,
                      translationName:
                          translations[translationId]?.name ?? translationId,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TranslationAnnotationSection extends ConsumerWidget {
  const _TranslationAnnotationSection({
    required this.book,
    required this.chapter,
    required this.translationId,
    required this.translationName,
  });

  final BibleBook book;
  final int chapter;
  final String translationId;
  final String translationName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(activeUserIdProvider);
    if (userId == null || userId.isEmpty) {
      return const SizedBox.shrink();
    }
    final request = AnnotationRequest(
      userId: userId,
      translationId: translationId,
      bookId: book.id,
      chapter: chapter,
    );
    final bookmarksAsync = ref.watch(chapterBookmarksProvider(request));
    final highlightsAsync = ref.watch(chapterHighlightsProvider(request));
    final notesAsync = ref.watch(chapterNotesProvider(request));

    final bookmarks = bookmarksAsync.maybeWhen(
      data: (data) => data,
      orElse: () => const <Bookmark>[],
    );
    final highlights = highlightsAsync.maybeWhen(
      data: (data) => data,
      orElse: () => const <Highlight>[],
    );
    final notes = notesAsync.maybeWhen(
      data: (data) => data,
      orElse: () => const <Note>[],
    );

    return ExpansionTile(
      title: Text(translationName),
      subtitle: Text('${book.name} $chapter'),
      children: [
        if (bookmarks.isEmpty && highlights.isEmpty && notes.isEmpty)
          const ListTile(
            title: Text('No annotations yet'),
          ),
        if (bookmarks.isNotEmpty) ...[
          const ListTile(title: Text('Bookmarks')),
          for (final bookmark in bookmarks)
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: Text('Verse ${bookmark.location.verse}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  await ref.read(toggleBookmarkUseCaseProvider)(
                    userId,
                    bookmark.location,
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Bookmark removed from verse ${bookmark.location.verse}.',
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
        if (highlights.isNotEmpty) ...[
          const ListTile(title: Text('Highlights')),
          for (final highlight in highlights)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: _colourFromHex(highlight.colour),
              ),
              title: Text('Verse ${highlight.location.verse}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  await ref
                      .read(removeHighlightUseCaseProvider)(userId, highlight.id);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Highlight removed from verse ${highlight.location.verse}.',
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
        if (notes.isNotEmpty) ...[
          const ListTile(title: Text('Notes')),
          for (final note in notes) _NoteListTile(note: note),
        ],
      ],
    );
  }
}

class _NoteListTile extends ConsumerWidget {
  const _NoteListTile({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(activeUserIdProvider);
    if (userId == null || userId.isEmpty) {
      return const SizedBox.shrink();
    }
    return ExpansionTile(
      title: Text('Verse ${note.location.verse} · v${note.version}'),
      subtitle: Text(note.text),
      children: [
        ButtonBar(
          alignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.undo),
              tooltip: 'Undo to previous version',
              onPressed: note.canUndo
                  ? () async {
                      await ref.read(undoNoteUseCaseProvider)(userId, note.id);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Note reverted.')),
                      );
                    }
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                await ref.read(deleteNoteUseCaseProvider)(userId, note.id);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note deleted.')),
                );
              },
            ),
          ],
        ),
        for (final history in note.history)
          ListTile(
            dense: true,
            title: Text('Version ${history.version}'),
            subtitle: Text(history.text),
            trailing: Text(history.updatedAt.toLocal().toString()),
          ),
      ],
    );
  }
}

Color _colourFromHex(String hex) {
  final buffer = StringBuffer();
  if (hex.length == 6 || hex.length == 7) buffer.write('ff');
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
