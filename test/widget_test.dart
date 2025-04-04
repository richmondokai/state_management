// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_assessment3/app/app.dart'; // Import your MyApp
import 'package:flutter_assessment3/screens/home_screen.dart'; // Import your MyApp

void main() {
  testWidgets('App renders successfully', (WidgetTester tester) async {
    // Build our app wrapped with ProviderScope
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify the app renders without throwing
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('HomeScreen is displayed by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify HomeScreen is shown (adjust based on your actual home widget)
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
