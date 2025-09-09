import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:meal_generator_planner/main.dart';

void main() {
  group('Meal Plan Generation Integration Tests', () {
    testWidgets('Generate meal plan from home page', (
      WidgetTester tester,
    ) async {
      // Start the app with ProviderScope
      await tester.pumpWidget(const ProviderScope(child: MealGeneratorApp()));
      await tester.pumpAndSettle();

      // Verify we're on the home page
      expect(find.text('Welcome to Meal Generator Planner'), findsOneWidget);

      // Find and tap the "Generate New Plan" button
      final generateButton = find.text('Generate New Plan');
      expect(generateButton, findsOneWidget);
      await tester.tap(generateButton);
      await tester.pumpAndSettle();

      // Verify we're on the generation configuration page
      expect(find.text('Generate Meal Plan'), findsAtLeast(1)); // AppBar title
      expect(find.text('Configure your meal plan'), findsOneWidget);

      // Test that we can adjust the number of people
      expect(find.text('4'), findsOneWidget); // Default value
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pump();
      expect(find.text('5'), findsOneWidget);

      // Test that we can select dietary preferences
      final vegetarianChip = find.text('Vegetarian');
      expect(vegetarianChip, findsOneWidget);
      await tester.tap(vegetarianChip);
      await tester.pump();

      // Test that we can add excluded ingredients
      await tester.enterText(find.byType(TextFormField), 'nuts');
      await tester.tap(find.byIcon(Icons.add).at(1)); // Second add button
      await tester.pump();
      expect(find.text('nuts'), findsOneWidget);

      // Test that we can toggle favorites inclusion
      final favoritesSwitch = find.byType(Switch);
      expect(favoritesSwitch, findsOneWidget);
      Switch switchWidget = tester.widget<Switch>(favoritesSwitch);
      expect(switchWidget.value, true); // Initially on

      // Find and tap the generate button
      final generatePlanButton = find.widgetWithText(
        ElevatedButton,
        'Generate Meal Plan',
      );
      expect(generatePlanButton, findsOneWidget);
      // Note: In a real test, we would mock the service and verify the results
      // For now, we're just testing the UI flow
    });

    testWidgets('Navigate through meal plan pages', (
      WidgetTester tester,
    ) async {
      // Start the app with ProviderScope
      await tester.pumpWidget(const ProviderScope(child: MealGeneratorApp()));
      await tester.pumpAndSettle();

      // Find and tap the 'Meal Plan' navigation card
      final mealPlanCard = find.text('Meal Plan');
      expect(mealPlanCard, findsOneWidget);
      await tester.tap(mealPlanCard);
      await tester.pumpAndSettle();

      // Verify we're on the meal plan page
      expect(find.text('Meal Plan Feature'), findsOneWidget);
      expect(
        find.text('Feature implementation coming soon...'),
        findsOneWidget,
      );
    });

    testWidgets('Navigate to favorites page', (WidgetTester tester) async {
      // Start the app with ProviderScope
      await tester.pumpWidget(const ProviderScope(child: MealGeneratorApp()));
      await tester.pumpAndSettle();

      // Find and tap the 'Favorites' navigation card
      final favoritesCard = find.text('Favorites');
      expect(favoritesCard, findsOneWidget);
      await tester.tap(favoritesCard);
      await tester.pumpAndSettle();

      // Verify we're on the favorites page
      expect(find.text('Favorites Feature'), findsOneWidget);
      expect(
        find.text('Feature implementation coming soon...'),
        findsOneWidget,
      );
    });

    testWidgets('Navigate to shopping list page', (WidgetTester tester) async {
      // Start the app with ProviderScope
      await tester.pumpWidget(const ProviderScope(child: MealGeneratorApp()));
      await tester.pumpAndSettle();

      // Find and tap the 'Shopping List' navigation card
      final shoppingListCard = find.text('Shopping List');
      expect(shoppingListCard, findsOneWidget);
      await tester.tap(shoppingListCard);
      await tester.pumpAndSettle();

      // Verify we're on the shopping list page
      expect(find.text('Shopping List Feature'), findsOneWidget);
      expect(
        find.text('Feature implementation coming soon...'),
        findsOneWidget,
      );
    });
  });
}
