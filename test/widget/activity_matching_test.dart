import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:afc_studymate/widgets/activity_matching.dart';

void main() {
  testWidgets('matching activity records answers', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ActivityMatching(data: {'Moses': 'Burning bush', 'Noah': 'Ark'}),
        ),
      ),
    );

    await tester.tap(find.text('Check answers'));
    await tester.pump();

    expect(find.textContaining('You matched'), findsOneWidget);
  });
}
