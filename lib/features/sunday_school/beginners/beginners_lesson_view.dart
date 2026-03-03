import 'package:afc_studymate/data/models/lesson.dart';
import 'package:flutter/material.dart';

class BeginnersLessonView extends StatefulWidget {
  const BeginnersLessonView({required this.lesson, super.key});

  final Lesson lesson;

  @override
  State<BeginnersLessonView> createState() => _BeginnersLessonViewState();
}

class _BeginnersLessonViewState extends State<BeginnersLessonView> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sections =
        (widget.lesson.payload['sections'] as List<dynamic>? ?? <dynamic>[])
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 700,
          child: Semantics(
            explicitChildNodes: true,
            child: PageView.builder(
              controller: _controller,
              itemCount: sections.length,
              onPageChanged: (value) => setState(() => _index = value),
              itemBuilder: (context, index) {
                final section = sections[index];
                final type = (section['sectionType'] as String? ?? 'text')
                    .toLowerCase();
                final title =
                    section['sectionTitle'] as String? ?? 'Story moment';
                final content =
                    section['sectionContent'] as String? ??
                    'Content coming soon.';
                final imagePath = section['imagePath'] as String?;

                return SingleChildScrollView(
                  primary: false,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Card(
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (imagePath != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      imagePath,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              Text(
                                content,
                                style: Theme.of(context).textTheme.bodyLarge,
                                textScaler: const TextScaler.linear(1.15),
                              ),
                              if (type == 'question') ...<Widget>[
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.question_answer,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Ask this question to spark a conversation!',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        if (sections.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Section ${_index + 1} of ${sections.length}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              OutlinedButton.icon(
                onPressed: sections.length <= 1
                    ? null
                    : () => _goRelative(sections.length, -1),
                icon: const Icon(Icons.arrow_back_ios_new),
                label: const Text('Previous'),
              ),
              OutlinedButton.icon(
                onPressed: sections.length <= 1
                    ? null
                    : () => _goRelative(sections.length, 1),
                icon: const Icon(Icons.arrow_forward_ios),
                label: const Text('Next'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _goRelative(int length, int delta) {
    if (length <= 1) {
      return;
    }
    final target = (_index + delta) % length;
    final normalized = target < 0 ? target + length : target;
    _controller.animateToPage(
      normalized,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
