import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/lesson.dart';
import '../services/data_service.dart';
import 'lesson_detail_screen.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Lesson> lessons = DataService.getLessons();
    final Map<String, List<Lesson>> groupedLessons = {};

    for (var lesson in lessons) {
      if (!groupedLessons.containsKey(lesson.ageGroup)) {
        groupedLessons[lesson.ageGroup] = [];
      }
      groupedLessons[lesson.ageGroup]!.add(lesson);
    }

    return Scaffold(
      body: AnimationLimiter(
        child: ListView.builder(
          itemCount: groupedLessons.length,
          itemBuilder: (context, index) {
            final String ageGroup = groupedLessons.keys.elementAt(index);
            final List<Lesson> groupLessons = groupedLessons[ageGroup]!;

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ExpansionTile(
                      title: Text(
                        ageGroup,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      children: groupLessons.map((lesson) {
                        return ListTile(
                          title: Text(lesson.title),
                          subtitle: Text(lesson.date),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LessonDetailScreen(lesson: lesson),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
