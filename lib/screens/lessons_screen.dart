import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/lesson.dart';
import '../services/data_service.dart';
import 'lesson_detail_screen.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<LessonGroup>>(
        future: DataService.getLessonGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No lessons found.'));
          } else {
            final lessonGroups = snapshot.data!;
            return AnimationLimiter(
              child: ListView.builder(
                itemCount: lessonGroups.length,
                itemBuilder: (context, index) {
                  final lessonGroup = lessonGroups[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          clipBehavior: Clip.antiAlias,
                          child: ExpansionTile(
                            leading: Image.network(
                              'https://picsum.photos/seed/${lessonGroup.title}/100',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              lessonGroup.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            children: lessonGroup.lessons.map((lesson) {
                              return ListTile(
                                title: Text(lesson.title),
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
            );
          }
        },
      ),
    );
  }
}
