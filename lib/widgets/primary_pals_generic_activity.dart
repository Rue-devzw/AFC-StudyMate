import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryPalsGenericActivity extends StatelessWidget {
  const PrimaryPalsGenericActivity({
    required this.activityType,
    required this.instructions,
    this.title,
    super.key,
  });

  final String activityType;
  final String instructions;
  final String? title;

  IconData _getIconForType(String type) {
    final lowerType = type.toLowerCase();
    if (lowerType.contains('color')) return Icons.color_lens;
    if (lowerType.contains('puzzle') ||
        lowerType.contains('crossword') ||
        lowerType.contains('maze')) {
      return Icons.extension;
    }
    if (lowerType.contains('draw')) return Icons.brush;
    if (lowerType.contains('word search') ||
        lowerType.contains('word puzzle') ||
        lowerType.contains('word scramble')) {
      return Icons.search;
    }
    if (lowerType.contains('question') || lowerType.contains('choice')) {
      return Icons.help_outline;
    }
    if (lowerType.contains('fill')) return Icons.edit;
    if (lowerType.contains('match')) return Icons.handshake;
    return Icons.star;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            _getIconForType(activityType),
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            title ?? activityType,
            style: GoogleFonts.nunito(
              textStyle: Theme.of(context).textTheme.headlineMedium,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            instructions,
            style: GoogleFonts.nunito(
              textStyle: Theme.of(context).textTheme.titleLarge,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.print,
                  size: 28,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'Grab your pencil, crayons, or printed worksheet!',
                    style: GoogleFonts.nunito(
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
