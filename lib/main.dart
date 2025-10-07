import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app_router.dart';
import 'data/services/app_bootstrap_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  final container = ProviderContainer();
  await container.read(appBootstrapServiceProvider).bootstrap();

  runApp(UncontrolledProviderScope(
    container: container,
    child: const StudyMateApp(),
  ));
}

class StudyMateApp extends HookConsumerWidget {
  const StudyMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final theme = ref.watch(appThemeProvider);

    return MaterialApp.router(
      title: 'AFC StudyMate',
      debugShowCheckedModeBanner: false,
      themeMode: ref.watch(theme.themeModeProvider),
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      routerConfig: router,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en', 'GB'),
      ],
    );
  }
}
