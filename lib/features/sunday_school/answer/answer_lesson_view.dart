import 'dart:async';

import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/utils/scripture_reference_parser.dart';
import 'package:afc_studymate/widgets/pdf_viewer_screen.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AnswerLessonView extends ConsumerStatefulWidget {
  const AnswerLessonView({required this.lesson, super.key});

  final Lesson lesson;

  @override
  ConsumerState<AnswerLessonView> createState() => _AnswerLessonViewState();
}

class _AnswerLessonViewState extends ConsumerState<AnswerLessonView> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final payload = widget.lesson.payload;
    final story = (payload['story'] as List<dynamic>? ?? <dynamic>[])
        .cast<String>();
    final keyVerse = payload['keyVerse'] as Map<String, dynamic>?;
    final activities = (payload['activities'] as List<dynamic>? ?? <dynamic>[])
        .map((dynamic e) => e as Map<String, dynamic>)
        .toList();

    final pages = <Widget>[
      KeyedSubtree(
        key: const ValueKey('story'),
        child: _StorySection(
          story: story,
          keyVerse: keyVerse,
          lessonId: widget.lesson.id,
        ),
      ),
      if (activities.isNotEmpty)
        ...activities.mapIndexed(
          (index, activity) {
            // Reusing existing components where applicable or standard text
            // "The Answer" activities are often discussion-based or paper-based.
            return KeyedSubtree(
              key: ValueKey('activity_$index'),
              child: _ActivitySection(activity: activity),
            );
          },
        ),
    ];

    final labels = <String>[
      'Lesson Text',
      ...activities.map(
        (activity) => activity['title'] as String? ?? 'Activity',
      ),
    ];

    final total = pages.length;
    if (total == 0) {
      return Center(
        child: Text(
          'Lesson content will appear here soon.',
          style: GoogleFonts.inter(fontSize: 18),
        ),
      );
    }
    final currentIndex = _index % total;
    final currentLabel = labels[currentIndex];

    // Clean, structured study aesthetic for 4th-8th grade
    // Using classic whites, deep blues and mature layout
    return ColoredBox(
      color: const Color(0xFFF8F9FA),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentLabel,
                    style: GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2C3E50),
                      letterSpacing: -0.5,
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
              children: [
                if (total > 1)
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2C3E50),
                      side: const BorderSide(color: Color(0xFFB0BEC5)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _index = (_index - 1) % total;
                      });
                    },
                    child: Text(
                      'Back',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                const Spacer(),
                if (total > 1)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C3E50),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _index = (_index + 1) % total;
                      });
                    },
                    child: Text(
                      'Next',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
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
  const _StorySection({
    required this.story,
    required this.lessonId, this.keyVerse,
  });

  final List<String> story;
  final Map<String, dynamic>? keyVerse;
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final paragraphs = story
        .where((paragraph) => paragraph.trim().isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.icon(
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 20),
                label: const Text('View Full PDF Lesson'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3E50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  var pdfPath = 'assets/pdfs/answer/unit_01.pdf';
                  final match = RegExp(r'answer_(\d+)').firstMatch(lessonId);
                  if (match != null) {
                    final lessonNum = int.parse(match.group(1)!);
                    final unitNum = ((lessonNum - 1) ~/ 13) + 1;
                    final unitStr = unitNum.toString().padLeft(2, '0');
                    pdfPath = 'assets/pdfs/answer/unit_$unitStr.pdf';
                  }

                  unawaited(
                    context.pushNamed(
                      PdfViewerScreen.routeName,
                      queryParameters: {
                        'path': pdfPath,
                        'title': 'The Answer: Full Lesson',
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (keyVerse != null)
            Card(
              elevation: 0,
              color: const Color(0xFFEAF2F8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.blue.shade100),
              ),
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.format_quote_rounded,
                          color: Colors.blue.shade700,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          keyVerse!['title'] as String? ?? 'KEY VERSE',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text.rich(
                      TextSpan(
                        children: ScriptureReferenceParser.buildLinkedTextSpans(
                          context,
                          keyVerse!['text'] as String? ?? '',
                          GoogleFonts.merriweather(
                            fontSize: 18,
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final paragraph in paragraphs) ...[
                    Text.rich(
                      TextSpan(
                        children: ScriptureReferenceParser.buildLinkedTextSpans(
                          context,
                          paragraph,
                          GoogleFonts.inter(
                            fontSize: 18,
                            height: 1.7,
                            color: const Color(0xFF34495E),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (paragraphs.isEmpty)
                    Text(
                      'Story content will be available soon.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivitySection extends StatelessWidget {
  const _ActivitySection({required this.activity});

  final Map<String, dynamic> activity;

  @override
  Widget build(BuildContext context) {
    final title = activity['title'] as String? ?? 'Activity';
    final type = activity['type'] as String? ?? '';
    final instructions = activity['instructions'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ColoredBox(
                    color: const Color(0xFFF1F5F8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        _getIconForType(type),
                        size: 32,
                        color: const Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ColoredBox(
                color: const Color(0xFFF9FAFB),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: ScriptureReferenceParser.buildLinkedTextSpans(
                        context,
                        instructions.isNotEmpty
                            ? instructions
                            : 'Complete the activity in your student material '
                                  'book.',
                        GoogleFonts.inter(
                          fontSize: 16,
                          height: 1.6,
                          color: const Color(0xFF4A5568),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '📝 Grab your pen and workbook to complete this section.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    final lowerType = type.toLowerCase();
    if (lowerType.contains('word') || lowerType.contains('crossword')) {
      return Icons.abc_rounded;
    } else if (lowerType.contains('maze')) {
      return Icons.route_rounded;
    } else if (lowerType.contains('puzzle')) {
      return Icons.extension_rounded;
    } else if (lowerType.contains('connect') || lowerType.contains('thought')) {
      return Icons.bubble_chart_rounded;
    }
    return Icons.assignment_rounded;
  }
}
