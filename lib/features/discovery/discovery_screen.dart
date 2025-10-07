import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/lesson.dart';
import '../../data/repositories/lesson_repository.dart';
import '../../widgets/completion_banner.dart';

class DiscoveryScreen extends HookConsumerWidget {
  const DiscoveryScreen({super.key});

  static const String routeName = 'discovery';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryAsync = ref.watch(_discoveryLessonProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Discovery & Daybreak')),
      body: discoveryAsync.when(
        data: (lesson) => lesson == null
            ? const Center(child: Text('Your Discovery lesson unlocks each Wednesday.'))
            : _DiscoveryContent(lesson: lesson),
        error: (error, stackTrace) => Center(child: Text('Unable to load: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

final _discoveryLessonProvider = FutureProvider<Lesson?>((ref) {
  return ref.read(lessonRepositoryProvider).getDiscoveryLesson();
});

class _DiscoveryContent extends StatelessWidget {
  const _DiscoveryContent({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final days = (lesson.payload['daybreak'] as List<dynamic>? ?? <dynamic>[])
        .map((dynamic e) => Map<String, dynamic>.from(e as Map? ?? <String, dynamic>{}))
        .toList();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        Text(lesson.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text(lesson.payload['overview'] as String? ?? 'A fresh journey through Scripture awaits.'),
        const SizedBox(height: 24),
        CompletionBanner(onTap: () {}),
        const SizedBox(height: 24),
        Text('Daybreak readings', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...days.map((day) {
          return Card(
            child: ListTile(
              title: Text(day['title'] as String? ?? 'Daybreak'),
              subtitle: Text(day['reference'] as String? ?? ''),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        }),
      ],
    );
  }
}
