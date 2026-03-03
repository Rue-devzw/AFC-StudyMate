import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:afc_studymate/widgets/retry_error_card.dart';
import 'package:afc_studymate/widgets/skeleton_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

final _searchCorpusProvider = FutureProvider<List<Lesson>>((ref) async {
  final repository = ref.read(lessonRepositoryProvider);
  final tracks = [
    Track.beginners,
    Track.primaryPals,
    Track.answer,
    Track.search,
    Track.discovery,
    Track.daybreak,
  ];
  final all = <Lesson>[];
  for (final track in tracks) {
    all.addAll(await repository.getLessonsForTrack(track));
  }
  return all;
});

class LessonSearchScreen extends ConsumerStatefulWidget {
  const LessonSearchScreen({super.key});

  static const routeName = 'lessonSearch';

  @override
  ConsumerState<LessonSearchScreen> createState() => _LessonSearchScreenState();
}

class _LessonSearchScreenState extends ConsumerState<LessonSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final corpusAsync = ref.watch(_searchCorpusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Lessons'),
        actions: [
          IconButton(
            tooltip: 'Share search',
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              Share.share(
                _query.isEmpty
                    ? 'Browse lessons in StudyMate.'
                    : 'Searching StudyMate for: "$_query"',
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search title, scripture, devotion text...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _query = value.trim()),
            ),
          ),
          Expanded(
            child: corpusAsync.when(
              data: (corpus) {
                final results = _query.isEmpty
                    ? corpus.take(40).toList()
                    : corpus.where((lesson) {
                        final haystack = _searchableText(lesson).toLowerCase();
                        return haystack.contains(_query.toLowerCase());
                      }).toList();

                if (results.isEmpty) {
                  return const Center(
                    child: Text('No lessons match your search.'),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    standardBottomContentPadding(context),
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final lesson = results[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(lesson.title),
                        subtitle: Text(
                          '${lesson.track.label} • ${lesson.bibleReferences.map((e) => e.displayText).join(", ")}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Share lesson',
                              icon: const Icon(
                                Icons.share_outlined,
                                size: 20,
                              ),
                              onPressed: () {
                                Share.share(
                                  '${lesson.title}\n${lesson.track.label}\n'
                                  '${lesson.bibleReferences.map((e) => e.displayText).join(", ")}',
                                );
                              },
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () => _openLesson(context, lesson),
                      ),
                    );
                  },
                );
              },
              loading: () => ListView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  standardBottomContentPadding(context),
                ),
                children: const [
                  SkeletonCard(),
                  SizedBox(height: 12),
                  SkeletonCard(),
                  SizedBox(height: 12),
                  SkeletonCard(),
                ],
              ),
              error: (error, stackTrace) => RetryErrorCard(
                message: '$error',
                onRetry: () => ref.invalidate(_searchCorpusProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openLesson(BuildContext context, Lesson lesson) {
    switch (lesson.track) {
      case Track.discovery:
        context.pushNamed(
          'discovery',
          queryParameters: {'lessonId': lesson.id},
        );
        return;
      case Track.daybreak:
        context.pushNamed(
          'daybreak',
          pathParameters: {'date': DateTime.now().toIso8601String()},
        );
        return;
      default:
        context.pushNamed(
          'sundaySchoolLessonDetail',
          pathParameters: {'lessonId': lesson.id},
        );
        return;
    }
  }

  String _searchableText(Lesson lesson) {
    final refs = lesson.bibleReferences.map((ref) => ref.displayText).join(' ');
    final payload = _flattenPayload(lesson.payload);
    return '${lesson.title} $refs $payload ${lesson.track.label}';
  }

  String _flattenPayload(dynamic payload) {
    if (payload == null) return '';
    if (payload is String) return payload;
    if (payload is num || payload is bool) return payload.toString();
    if (payload is List) {
      return payload.map(_flattenPayload).join(' ');
    }
    if (payload is Map) {
      return payload.values.map(_flattenPayload).join(' ');
    }
    return '';
  }
}
