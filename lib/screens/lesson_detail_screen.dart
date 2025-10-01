import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/lesson.dart';

class LessonDetailScreen extends StatelessWidget {
  final Lesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      backgroundColor: theme.colorScheme.surface, // Use the light blue background
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: lesson.title,
              child: Image.network(
                'https://picsum.photos/seed/${lesson.title}/600/400',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.introduction,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Lesson Sections',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  ...lesson.sections.map(
                    (section) => Card(
                      elevation: 1.0,
                      color: theme.cardColor.withOpacity(0.95),
                      margin: const EdgeInsets.only(bottom: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(section.title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 18,
                                  color: const Color(0xFFFFAB40), // Accent color
                                  fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(height: 10),
                            Text(
                              section.content,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 15,
                                height: 1.5, // improved line spacing for readability
                              ),
                            ),
                            if (section.url != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final Uri url = Uri.parse(section.url!);
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Could not launch ${section.url}'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Read More'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
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
