import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/models/bible_ref.dart';
import '../features/bible/bible_screen.dart';

class LinkedVerse extends StatelessWidget {
  const LinkedVerse({
    required this.reference,
    this.label,
    this.style,
    super.key,
  });

  final BibleRef reference;
  final String? label;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = (style ?? theme.textTheme.bodyMedium)?.copyWith(
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleTap(context),
      child: Text(
        (label ?? reference.displayText).trim(),
        style: effectiveStyle,
      ),
    );
  }

  void _handleTap(BuildContext context) {
    final queryParameters = <String, String>{
      'book': reference.book,
      'chapter': reference.chapter.toString(),
    };
    final verse = reference.verseStart;
    if (verse != null) {
      queryParameters['verse'] = verse.toString();
    }

    context.goNamed(
      BibleScreen.routeName,
      queryParameters: queryParameters,
    );
  }
}
