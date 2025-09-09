import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/features/meal_plan/presentation/pages/generate_meal_plan_page.dart';

void main() {
  group('GenerateMealPlanPage Widget Tests', () {
    testWidgets('should render the page with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      expect(find.widgetWithText(AppBar, 'Generate Meal Plan'), findsOneWidget);
      expect(find.text('Configure your meal plan'), findsOneWidget);
    });

    testWidgets('should render number of people selector', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      expect(find.text('Number of People'), findsOneWidget);
      expect(find.text('4'), findsOneWidget); // Default value
      expect(find.byIcon(Icons.add).first, findsOneWidget);
      expect(find.byIcon(Icons.remove).first, findsOneWidget);
    });

    testWidgets('should increase number of people when add button is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      expect(find.text('4'), findsOneWidget); // Default value

      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pump();

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should decrease number of people when remove button is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      expect(find.text('4'), findsOneWidget); // Default value

      await tester.tap(find.byIcon(Icons.remove).first);
      await tester.pump();

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('should not decrease below 1 person', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      // Decrease to 1
      await tester.tap(find.byIcon(Icons.remove).first);
      await tester.tap(find.byIcon(Icons.remove).first);
      await tester.tap(find.byIcon(Icons.remove).first);
      await tester.pump();

      expect(find.text('1'), findsOneWidget);

      // Try to decrease further
      await tester.tap(find.byIcon(Icons.remove).first);
      await tester.pump();

      // Should still be 1
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should not increase above 10 people', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      // Increase to 10
      for (int i = 0; i < 6; i++) {
        await tester.tap(find.byIcon(Icons.add).first);
      }
      await tester.pump();

      expect(find.text('10'), findsOneWidget);

      // Try to increase further
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pump();

      // Should still be 10
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('should render dietary preferences section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      expect(find.text('Dietary Preferences'), findsOneWidget);
      
      // Check for dietary tags
      expect(find.text('Vegetarian'), findsOneWidget);
      expect(find.text('Vegan'), findsOneWidget);
      expect(find.text('Gluten Free'), findsOneWidget);
      expect(find.text('Dairy Free'), findsOneWidget);
      expect(find.text('Nut Free'), findsOneWidget);
      expect(find.text('Low Carb'), findsOneWidget);
    });

    testWidgets('should toggle dietary tag when chip is selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      final vegetarianChip = find.text('Vegetarian');
      expect(vegetarianChip, findsOneWidget);

      // Initially not selected
      final unselectedChip = tester.widget<FilterChip>(find.byWidgetPredicate(
        (widget) => widget is FilterChip && widget.label.toString().contains('Vegetarian'),
      ));
      expect(unselectedChip.selected, false);

      // Tap the chip
      await tester.tap(vegetarianChip);
      await tester.pump();

      // Should now be selected
      final selectedChip = tester.widget<FilterChip>(find.byWidgetPredicate(
        (widget) => widget is FilterChip && widget.label.toString().contains('Vegetarian'),
      ));
      expect(selectedChip.selected, true);
    });

    testWidgets('should render include favorites toggle', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      expect(find.text('Include Favorite Meals'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('should toggle include favorites switch', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      // Initially on (true)
      Switch switchWidget = tester.widget<Switch>(switchFinder);
      expect(switchWidget.value, true);

      // Tap the switch
      await tester.tap(switchFinder);
      await tester.pump();

      // Should now be off (false)
      switchWidget = tester.widget<Switch>(switchFinder);
      expect(switchWidget.value, false);
    });

    testWidgets('should render exclude ingredients section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      expect(find.text('Exclude Ingredients'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byIcon(Icons.add).at(1), findsOneWidget); // Second add button
    });

    testWidgets('should add excluded ingredient when add button is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      // Enter text in the field
      await tester.enterText(find.byType(TextFormField), 'nuts');
      
      // Tap add button (second one)
      await tester.tap(find.byIcon(Icons.add).at(1));
      await tester.pump();

      // Should show the chip
      expect(find.text('nuts'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should remove excluded ingredient when close button is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      // Add an ingredient
      await tester.enterText(find.byType(TextFormField), 'nuts');
      await tester.tap(find.byIcon(Icons.add).at(1));
      await tester.pump();

      expect(find.text('nuts'), findsOneWidget);

      // Remove the ingredient
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      // Should no longer show the chip
      expect(find.text('nuts'), findsNothing);
    });

    testWidgets('should render generate button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      expect(find.widgetWithText(ElevatedButton, 'Generate Meal Plan'), findsOneWidget);
    });
  });
}