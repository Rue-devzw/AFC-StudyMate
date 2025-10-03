import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'src/presentation/app/app.dart';
import 'src/presentation/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
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
    ref.watch(cloudAccountBindingProvider);
    final syncService = ref.read(lessonSyncServiceProvider);
    syncService.ensureBackgroundScheduled();
    unawaited(syncService.syncAll());
    final dataSync = ref.read(syncOrchestratorProvider);
    dataSync.ensureBackgroundScheduled();
    unawaited(dataSync.syncNow().catchError((_) {}));
    return const StudyMateApp();
  }
}
