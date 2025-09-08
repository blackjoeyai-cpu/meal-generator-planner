// Basic widget test for Meal Generator Planner app

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/main.dart';

void main() {
  testWidgets('App loads and displays home page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MealGeneratorApp());

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that the app title is displayed
    expect(find.text('Meal Generator Planner'), findsOneWidget);
    expect(find.text('Welcome to Meal Generator Planner'), findsOneWidget);
  });
}
