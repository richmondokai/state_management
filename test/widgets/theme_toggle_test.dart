// test/widgets/theme_toggle_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_assessment3/widgets/theme_toggle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('ThemeToggle changes icon when pressed', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: ThemeToggle())),
      ),
    );

    final lightIcon = find.byIcon(Icons.dark_mode);
    expect(lightIcon, findsOneWidget);

    await tester.tap(lightIcon);
    await tester.pump();

    expect(find.byIcon(Icons.light_mode), findsOneWidget);
  });
}
