import 'package:afc_studymate/data/models/teacher_guide.dart';
import 'package:afc_studymate/widgets/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class TeacherGuideView extends StatelessWidget {
  const TeacherGuideView({
    required this.guide,
    required this.title,
    super.key,
  });

  final TeacherGuide guide;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Guide',
            onPressed: () {
              final preview = guide.content.length > 200
                  ? '${guide.content.substring(0, 200)}...'
                  : guide.content;
              Share.share('$title\n\n$preview');
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'View Full PDF',
            onPressed: () {
              context.pushNamed(
                PdfViewerScreen.routeName,
                queryParameters: {
                  'path': guide.pdfPath,
                  'title': '$title PDF',
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withAlpha(50),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.school,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "This is the extracted text from the Teacher's Guide PDF. For the original formatting and illustrations, tap the PDF icon in the top right.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              guide.content.isEmpty
                  ? 'No text could be extracted for this lesson.'
                  : guide.content,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: FilledButton.icon(
                onPressed: () {
                  context.pushNamed(
                    PdfViewerScreen.routeName,
                    queryParameters: {
                      'path': guide.pdfPath,
                      'title': '$title PDF',
                    },
                  );
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('View Full PDF Document'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
