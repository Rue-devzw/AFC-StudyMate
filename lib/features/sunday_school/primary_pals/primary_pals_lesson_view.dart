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
      _StorySection(story: story),
      ...activities.map((activity) => ActivityMatching(data: Map<String, String>.from(activity['data'] as Map? ?? {}))),
      _ParentsCorner(payload: payload),
    ];

    return Column(
      children: <Widget>[
        Expanded(child: pages[_index % pages.length]),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _index = (_index - 1) % pages.length;
                  });
                },
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _index = (_index + 1) % pages.length;
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
  const _StorySection({required this.story});

  final List<String> story;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: story.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            story[index],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      },
    );
  }
}

class _ParentsCorner extends StatelessWidget {
  const _ParentsCorner({required this.payload});

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
