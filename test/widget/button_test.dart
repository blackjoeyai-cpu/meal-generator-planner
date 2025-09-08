import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/widgets/buttons.dart';

void main() {
  group('PrimaryButton Widget Tests', () {
    testWidgets('should render button with text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              onPressed: () {},
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should show loading indicator when isLoading is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              onPressed: null,
              isLoading: true,
              child: Text('Test Button'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('should be disabled when isEnabled is false', (
      WidgetTester tester,
    ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              onPressed: () => wasPressed = true,
              isEnabled: false,
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(wasPressed, false);
    });

    testWidgets('should call onPressed when tapped and enabled', (
      WidgetTester tester,
    ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              onPressed: () => wasPressed = true,
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(wasPressed, true);
    });
  });

  group('SecondaryButton Widget Tests', () {
    testWidgets('should render outlined button with text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              onPressed: () {},
              child: const Text('Secondary Button'),
            ),
          ),
        ),
      );

      expect(find.text('Secondary Button'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (
      WidgetTester tester,
    ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              onPressed: () => wasPressed = true,
              child: const Text('Secondary Button'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      expect(wasPressed, true);
    });
  });
}
