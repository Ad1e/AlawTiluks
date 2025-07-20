import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finalapp/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartSafetyApp());

    // This test assumes there's a counter, which may not exist in your app.
    // If your app doesn't have a '+' button and counter, this test will fail.
    // You can comment/remove below lines or customize them to match your actual UI.

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
