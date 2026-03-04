import 'dart:async';

import 'package:afc_studymate/app_router.dart';
import 'package:afc_studymate/data/services/app_bootstrap_service.dart';
import 'package:afc_studymate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  final container = ProviderContainer();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const StudyMateApp(),
    ),
  );
}

class StudyMateApp extends HookConsumerWidget {
  const StudyMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'AFM SEAR StudyMate',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en', 'GB'),
      ],
      home: const _SplashWrapper(),
    );
  }
}

/// Runs bootstrap work, then hands off to the GoRouter-powered app.
class _SplashWrapper extends ConsumerStatefulWidget {
  const _SplashWrapper();

  @override
  ConsumerState<_SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends ConsumerState<_SplashWrapper> {
  var _ready = false;
  var _progress = 0.0;
  var _status = 'Starting StudyMate...';
  Object? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    setState(() {
      _error = null;
      _progress = 0.02;
      _status = 'Starting StudyMate...';
    });
    try {
      await ref.read(appBootstrapServiceProvider).bootstrap(
        onProgress: (progress) {
          if (!mounted) {
            return;
          }
          setState(() {
            _progress = progress.progress;
            _status = progress.message;
          });
        },
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _ready = true;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return _BootstrapSplash(
        progress: _progress,
        status: _status,
        error: _error,
        onRetry: _bootstrap,
      );
    }

    final router = ref.watch(appRouterProvider);
    return Router<Object?>(
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      backButtonDispatcher: router.backButtonDispatcher,
    );
  }
}

class _BootstrapSplash extends StatelessWidget {
  const _BootstrapSplash({
    required this.progress,
    required this.status,
    required this.error,
    required this.onRetry,
  });

  final double progress;
  final String status;
  final Object? error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.3,
            colors: [
              Color(0xFF2C1B5E),
              Color(0xFF0A1045),
              Color(0xFF050820),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    width: 120,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'AFC StudyMate',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  status,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 18),
                LinearProgressIndicator(
                  value: error == null ? progress.clamp(0, 1) : null,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(999),
                ),
                if (error != null) ...<Widget>[
                  const SizedBox(height: 14),
                  Text(
                    'Startup failed: $error',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.red.shade200,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => unawaited(onRetry()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry Startup'),
                  ),
                ],
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
