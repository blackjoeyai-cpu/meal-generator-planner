import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/core/testing/test_setup.dart';
import 'package:meal_generator_planner/data/repositories/meal_plan_repository.dart';
import 'package:meal_generator_planner/data/repositories/meal_repository.dart';
import 'package:meal_generator_planner/data/repositories/repository_providers.dart';
import 'package:meal_generator_planner/main.dart';
import 'package:mockito/mockito.dart';

class MockMealRepository extends Mock implements MealRepository {}

class MockMealPlanRepository extends Mock implements MealPlanRepository {}

void main() {
  late MockMealRepository mockMealRepository;
  late MockMealPlanRepository mockMealPlanRepository;

  setUpAll(() async {
    await setUpHiveForTesting();
  });

  setUp(() {
    mockMealRepository = MockMealRepository();
    mockMealPlanRepository = MockMealPlanRepository();
  });

  testWidgets('App loads and displays home page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mealRepositoryProvider
              .overrideWith((ref) => Future.value(mockMealRepository)),
          mealPlanRepositoryProvider
              .overrideWith((ref) => Future.value(mockMealPlanRepository)),
        ],
        child: const MealGeneratorApp(),
      ),
    );

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that the app title is displayed
    expect(find.text('Meal Plan Generator'), findsOneWidget);
    expect(find.text('Generate Weekly Plan'), findsOneWidget);
  });
}
