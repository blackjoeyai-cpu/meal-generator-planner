import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:meal_generator_planner/core/constants/app_constants.dart';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';
import 'package:meal_generator_planner/main.dart' as app;
import 'package:meal_generator_planner/features/meal_plan/presentation/widgets/weekly_calendar_grid.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../test/helpers/test_setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    setUpAll(() async {
      await setUpHiveForTesting();
      await Hive.openBox<Meal>(AppConstants.mealsBoxName);
      await Hive.openBox<MealPlan>(AppConstants.mealPlansBoxName);
    });

    testWidgets('Generate meal plan flow', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: app.MealGeneratorApp()),
      );
      await tester.pumpAndSettle();

      // Verify we're on the home page
      expect(find.text('Generate Weekly Plan'), findsOneWidget);

      // Tap the generate button
      await tester.tap(find.text('Generate Weekly Plan'));
      await tester.pumpAndSettle();

      // Verify the meal plan is displayed
      expect(find.byType(WeeklyCalendarGrid), findsOneWidget);
    });
  });
}
