import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baranguard/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp()); // Ensure the name matches your class

    // Verify that our counter starts at 0.
    expect(find.text('Counter Value: 0'), findsOneWidget);
    expect(find.text('Counter Value: 1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('Counter Value: 0'), findsNothing);
    expect(find.text('Counter Value: 1'), findsOneWidget);
  });
}
