import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/utils/scripture_reference_parser.dart';
import 'package:afc_studymate/widgets/activity_matching.dart';
import 'package:afc_studymate/widgets/primary_pals_generic_activity.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryPalsLessonView extends ConsumerStatefulWidget {
  const PrimaryPalsLessonView({required this.lesson, super.key});

  final Lesson lesson;

  @override
  ConsumerState<PrimaryPalsLessonView> createState() =>
      _PrimaryPalsLessonViewState();
}

class _PrimaryPalsLessonViewState extends ConsumerState<PrimaryPalsLessonView> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final payload = widget.lesson.payload;
    final story = (payload['story'] as List<dynamic>? ?? <dynamic>[])
        .cast<String>();
    final activities = (payload['activities'] as List<dynamic>? ?? <dynamic>[])
        .map((dynamic e) => e as Map<String, dynamic>)
        .toList();

    final pages = <Widget>[
      KeyedSubtree(
        key: const ValueKey('story'),
        child: _StorySection(story: story),
      ),
      ...activities.mapIndexed(
        (index, activity) {
          final type = activity['type'] as String? ?? 'Activity';
          final isMatching =
              type.toLowerCase().contains('match') && activity['data'] != null;

          var parsedInstructions = '';
          final rawInstructions = activity['instructions'];
          if (rawInstructions is String) {
            parsedInstructions = rawInstructions;
          } else if (rawInstructions is List) {
            parsedInstructions = rawInstructions.join('\n\n');
          }

          return KeyedSubtree(
            key: ValueKey('activity_$index'),
            child: isMatching
                ? ActivityMatching(
                    data: Map<String, String>.from(
                      activity['data'] as Map? ?? {},
                    ),
                  )
                : PrimaryPalsGenericActivity(
                    activityType: type,
                    title: activity['title'] as String?,
                    instructions: parsedInstructions,
                  ),
          );
        },
      ),
      KeyedSubtree(
        key: const ValueKey('parents'),
        child: _ParentsCorner(payload: payload),
      ),
    ];

    final labels = <String>[
      'Story Time',
      ...activities.map(
        (activity) => activity['title'] as String? ?? 'Activity',
      ),
      "Parents' Corner",
    ];
    final total = pages.length;
    if (total == 0) {
      return Center(
        child: Text(
          'Lesson content will appear here soon.',
          style: GoogleFonts.nunito(fontSize: 18),
        ),
      );
    }
    final currentIndex = _index % total;
    final currentLabel = labels[currentIndex];

    Color backgroundColor;
    if (currentIndex == 0) {
      backgroundColor = const Color(0xFFFFF9E6);
    } else if (currentIndex == total - 1) {
      backgroundColor = const Color(0xFFFFF0E6);
    } else {
      backgroundColor = const Color(0xFFE6F7FF);
    }

    return ColoredBox(
      color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentLabel,
                    style: GoogleFonts.nunito(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: pages[currentIndex],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _index = (_index - 1) % total;
                    });
                  },
                  child: Text(
                    'Back',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _index = (_index + 1) % total;
                    });
                  },
                  child: Text(
                    'Next',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StorySection extends StatelessWidget {
  const _StorySection({required this.story});

  final List<String> story;

  @override
  Widget build(BuildContext context) {
    final paragraphs = story
        .where((paragraph) => paragraph.trim().isNotEmpty)
        .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 64,
                  color: Colors.orange.shade300,
                ),
              ),
              const SizedBox(height: 24),
              for (final paragraph in paragraphs) ...<Widget>[
                Text.rich(
                  TextSpan(
                    children: ScriptureReferenceParser.buildLinkedTextSpans(
                      context,
                      paragraph,
                      GoogleFonts.nunito(
                        fontSize: 20,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (paragraphs.isEmpty)
                Text(
                  'Story content will be available soon.',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParentsCorner extends StatelessWidget {
  const _ParentsCorner({required this.payload});

  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    final parentGuide =
        payload['parentGuide'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final devotions =
        (parentGuide['familyDevotions'] as List<dynamic>? ?? <dynamic>[])
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.family_restroom,
                        color: Colors.blue.shade400,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tips for Parents',
                          style: GoogleFonts.nunito(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      children: ScriptureReferenceParser.buildLinkedTextSpans(
                        context,
                        parentGuide['parentsCorner'] as String? ??
                            'Tips for this week will appear here.',
                        GoogleFonts.nunito(
                          fontSize: 18,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.red.shade400, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Family Devotions',
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...devotions.map(
            (devotion) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  title: Text(
                    devotion['day'] as String? ?? 'Day',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text.rich(
                      TextSpan(
                        children: ScriptureReferenceParser.buildLinkedTextSpans(
                          context,
                          devotion['prompt'] as String? ?? 'Prompt',
                          GoogleFonts.nunito(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
