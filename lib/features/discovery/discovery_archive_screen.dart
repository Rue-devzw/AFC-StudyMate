import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/features/discovery/discovery_screen.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:afc_studymate/widgets/retry_error_card.dart';
import 'package:afc_studymate/widgets/skeleton_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

final _discoveryLessonsProvider = FutureProvider<List<Lesson>>((ref) async {
  final lessons = await ref
      .read(lessonRepositoryProvider)
      .getLessonsForTrack(Track.discovery);
  return lessons.where(_isIndexableDiscoveryLesson).toList();
});

class DiscoveryArchiveScreen extends ConsumerStatefulWidget {
  const DiscoveryArchiveScreen({super.key});

  static const routeName = 'discoveryArchive';

  @override
  ConsumerState<DiscoveryArchiveScreen> createState() =>
      _DiscoveryArchiveScreenState();
}

class _DiscoveryArchiveScreenState extends ConsumerState<DiscoveryArchiveScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessonsAsync = ref.watch(_discoveryLessonsProvider);
    final horizontalPadding = responsiveHorizontalPadding(context);

    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_discovery.png',
      appBar: AppBar(
        title: const Text(
          'Discovery Index',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: lessonsAsync.when(
        data: (lessons) {
          final filteredLessons = _filterLessons(lessons, _query);
          if (lessons.isEmpty) {
            return const Center(
              child: Text(
                'No Discovery lessons available.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              16,
              horizontalPadding,
              standardBottomContentPadding(context),
            ),
            children: [
              AppTextField(
                controller: _searchController,
                hintText: 'Search by lesson title, number, or reference',
                onChanged: (value) {
                  setState(() {
                    _query = value.trim();
                  });
                },
              ),
              const SizedBox(height: 12),
              Text(
                '${filteredLessons.length} lesson${filteredLessons.length == 1 ? '' : 's'}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              if (filteredLessons.isEmpty)
                const PremiumGlassCard(
                  child: Text(
                    'No lessons match your search.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              else
                for (var index = 0; index < filteredLessons.length; index++)
                  _DiscoveryIndexTile(
                    lesson: filteredLessons[index],
                    fallbackNumber: index + 1,
                  ),
            ],
          );
        },
        loading: () => ListView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            16,
            horizontalPadding,
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
          onRetry: () => ref.invalidate(_discoveryLessonsProvider),
        ),
      ),
    );
  }
}

class _DiscoveryIndexTile extends StatelessWidget {
  const _DiscoveryIndexTile({required this.lesson, required this.fallbackNumber});

  final Lesson lesson;
  final int fallbackNumber;

  @override
  Widget build(BuildContext context) {
    final lessonNumber = (lesson.weekIndex ?? (fallbackNumber - 1)) + 1;
    final references = lesson.bibleReferences.map((e) => e.displayText).join(', ');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumGlassCard(
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          title: Text(
            'Lesson $lessonNumber: ${lesson.title}',
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            references.isNotEmpty ? references : 'No reference',
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Share lesson',
                icon: const Icon(
                  Icons.share_outlined,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () {
                  Share.share(
                    'Discovery Lesson $lessonNumber: ${lesson.title}\n$references',
                  );
                },
              ),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
          onTap: () {
            context.pushNamed(
              DiscoveryScreen.routeName,
              queryParameters: {'lessonId': lesson.id},
            );
          },
        ),
      ),
    );
  }
}

List<Lesson> _filterLessons(List<Lesson> lessons, String query) {
  if (query.isEmpty) {
    return lessons;
  }
  final normalized = query.toLowerCase();
  return lessons.where((lesson) {
    final lessonNumber = ((lesson.weekIndex ?? 0) + 1).toString();
    final title = lesson.title.toLowerCase();
    final references = lesson.bibleReferences
        .map((e) => e.displayText.toLowerCase())
        .join(' ');
    return lessonNumber.contains(normalized) ||
        title.contains(normalized) ||
        references.contains(normalized);
  }).toList();
}

bool _isIndexableDiscoveryLesson(Lesson lesson) {
  final title = lesson.title.trim().toUpperCase();
  if (title == 'UNIT') {
    return false;
  }
  final questions = lesson.payload['questions'] as List<dynamic>? ?? <dynamic>[];
  return lesson.bibleReferences.isNotEmpty || questions.isNotEmpty;
}
