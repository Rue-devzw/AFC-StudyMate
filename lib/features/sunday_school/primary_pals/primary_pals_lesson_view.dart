import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../data/models/lesson.dart';
import '../../../widgets/activity_matching.dart';

class PrimaryPalsLessonView extends StatefulWidget {
  const PrimaryPalsLessonView({required this.lesson, super.key});

  final Lesson lesson;

  @override
  State<PrimaryPalsLessonView> createState() => _PrimaryPalsLessonViewState();
}

class _PrimaryPalsLessonViewState extends State<PrimaryPalsLessonView> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final payload = widget.lesson.payload;
    final story = (payload['story'] as List<dynamic>? ?? <dynamic>[]).cast<String>();
    final activities = (payload['activities'] as List<dynamic>? ?? <dynamic>[])
        .map((dynamic e) => e as Map<String, dynamic>)
        .toList();

    final pages = <Widget>[
      KeyedSubtree(key: const ValueKey('story'), child: _StorySection(story: story)),
      ...activities.mapIndexed(
        (index, activity) => KeyedSubtree(
          key: ValueKey('activity_$index'),
          child: ActivityMatching(
            data: Map<String, String>.from(activity['data'] as Map? ?? {}),
          ),
        ),
      ),
      KeyedSubtree(key: const ValueKey('parents'), child: _ParentsCorner(payload: payload)),
    ];

    final labels = <String>[
      'Story adventure',
      ...activities.map((activity) => activity['title'] as String? ?? 'Activity'),
      'Parent connection',
    ];
    final total = pages.length;
    if (total == 0) {
      return const Center(child: Text('Lesson content will appear here soon.'));
    }
    final currentIndex = _index % total;
    final currentLabel = labels[currentIndex];

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              currentLabel,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: pages[currentIndex],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _index = (_index - 1) % total;
                  });
                },
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _index = (_index + 1) % total;
                  });
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StorySection extends StatelessWidget {
  const _StorySection({required this.story, super.key});

  final List<String> story;

  @override
  Widget build(BuildContext context) {
    final paragraphs = story.where((paragraph) => paragraph.trim().isNotEmpty).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final paragraph in paragraphs) ...<Widget>[
                Text(
                  paragraph,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
              ],
              if (paragraphs.isEmpty)
                Text(
                  'Story content will be available soon.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParentsCorner extends StatelessWidget {
  const _ParentsCorner({required this.payload, super.key});

  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    final parentGuide = payload['parentGuide'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final devotions = (parentGuide['familyDevotions'] as List<dynamic>? ?? <dynamic>[])
        .map((dynamic e) => e as Map<String, dynamic>)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        Text('Parents\' Corner', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text(parentGuide['parentsCorner'] as String? ?? 'Tips for this week will appear here.'),
        const SizedBox(height: 24),
        Text('Family Devotions', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ...devotions.map(
          (devotion) => Card(
            child: ListTile(
              title: Text(devotion['day'] as String? ?? 'Day'),
              subtitle: Text(devotion['prompt'] as String? ?? 'Prompt'),
            ),
          ),
        ),
      ],
    );
  }
}
