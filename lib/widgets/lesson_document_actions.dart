import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/providers/user_providers.dart';
import 'package:afc_studymate/data/repositories/lesson_pdf_repository.dart';
import 'package:afc_studymate/widgets/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LessonDocumentActions extends ConsumerWidget {
  const LessonDocumentActions({
    required this.lesson,
    super.key,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 8),
  });

  final Lesson lesson;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(lessonPdfRepositoryProvider);
    final studentPdf = repository.studentPdfForLesson(lesson);
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final teacherGuide = profile?.role == Role.teacher
        ? repository.teacherGuideForLesson(lesson)
        : null;

    if (studentPdf == null && teacherGuide == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          if (studentPdf != null)
            FilledButton.icon(
              onPressed: () => _openPdf(context, studentPdf),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('View PDF Lesson'),
            ),
          if (teacherGuide != null)
            OutlinedButton.icon(
              onPressed: () => _openPdf(context, teacherGuide),
              icon: const Icon(Icons.school_rounded),
              label: const Text("Teacher's Guide"),
            ),
        ],
      ),
    );
  }

  void _openPdf(BuildContext context, LessonPdfDocument document) {
    context.pushNamed(
      PdfViewerScreen.routeName,
      queryParameters: {
        'path': document.path,
        'title': document.title,
        if (document.initialPage != null)
          'page': document.initialPage.toString(),
      },
    );
  }
}
