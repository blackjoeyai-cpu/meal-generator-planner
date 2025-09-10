import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/data/models/enums.dart';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/repositories/meal_plan_repository.dart';
import 'package:meal_generator_planner/data/repositories/repository_providers.dart';
import 'package:meal_generator_planner/features/home/presentation/pages/home_page.dart';
import 'package:meal_generator_planner/features/meal_plan/presentation/widgets/weekly_calendar_grid.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_setup.dart';
import '../unit/meal_generation_service_test.mocks.dart';

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

  final dummyMeals = List.generate(
    30,
    (i) => Meal(
      id: 'meal_$i',
      name: 'Meal $i',
      description: 'Description for meal $i',
      ingredients: [],
      category: i % 4 == 0
          ? MealCategory.breakfast
          : (i % 4 == 1
              ? MealCategory.lunch
              : (i % 4 == 2 ? MealCategory.dinner : MealCategory.snack)),
      estimatedCalories: 300 + i * 10,
      preparationTimeMinutes: 15 + i,
      difficulty: DifficultyLevel.easy,
      dietaryTags: i % 5 == 0 ? [DietaryTag.vegetarian] : [],
      imageAssetPath: '',
      cookingInstructions: '',
      defaultServings: 2,
      createdAt: DateTime.now(),
    ),
  );

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        mealRepositoryProvider.overrideWith((ref) => Future.value(mockMealRepository)),
        mealPlanRepositoryProvider
            .overrideWith((ref) => Future.value(mockMealPlanRepository)),
      ],
      child: const MaterialApp(home: HomePage()),
    );
  }

  testWidgets('should show generate button on home screen initially',
      (WidgetTester tester) async {
    when(mockMealRepository.getAllMeals()).thenAnswer((_) async => dummyMeals);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Generate Weekly Plan'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(WeeklyCalendarGrid), findsNothing);
  });

  testWidgets('should display loading indicator during generation',
      (WidgetTester tester) async {
    when(mockMealRepository.getAllMeals()).thenAnswer((_) async {
      // Add a delay to ensure the loading state is visible
      await Future.delayed(const Duration(milliseconds: 100));
      return dummyMeals;
    });

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Generate Weekly Plan'));
    await tester.pump(); // Show loading indicator

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle(); // Complete the generation
  });

  testWidgets('should show generated plan in calendar view',
      (WidgetTester tester) async {
    when(mockMealRepository.getAllMeals()).thenAnswer((_) async => dummyMeals);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Generate Weekly Plan'));
    await tester.pumpAndSettle();

    expect(find.byType(WeeklyCalendarGrid), findsOneWidget);
    expect(find.text('Generate Again'), findsOneWidget);
  });

  testWidgets('should handle generation errors gracefully',
      (WidgetTester tester) async {
    when(mockMealRepository.getAllMeals())
        .thenThrow(Exception('Failed to load meals'));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Generate Weekly Plan'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Error'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
  });
}
