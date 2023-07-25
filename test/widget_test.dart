// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran/inject_dependency.dart';
import 'package:quran/main.dart' as app;

void main() {
  testWidgets('quran widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await initDependency();
    await tester.pumpWidget(app.MyApp(
      instance: getIt,
    ));

    // Verify that our text is founded
    expect(find.byKey(const Key('top_likes')), findsOneWidget);
    expect(find.byKey(const Key('listen_Quran')), findsNothing);

    await tester.pump();
  });
}
