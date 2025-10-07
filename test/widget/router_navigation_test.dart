import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:afc_studymate/app_router.dart';
import 'package:afc_studymate/main.dart';

void main() {
  testWidgets('navigates to tabs via router', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: Builder(
          builder: (BuildContext context) {
            final router = ProviderScope.containerOf(context).read(appRouterProvider);
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Welcome to AFC StudyMate'), findsOneWidget);
  });
}
