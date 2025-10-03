import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/presentation/app/app.dart';
import 'src/presentation/providers.dart';

void main() {
  runApp(
    const ProviderScope(
      child: _AppBootstrap(),
    ),
  );
}

class _AppBootstrap extends ConsumerWidget {
  const _AppBootstrap();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ensure the local database has baseline data available.
    ref.read(appDatabaseProvider).ensureSeeded();
    return const StudyMateApp();
  }
}
