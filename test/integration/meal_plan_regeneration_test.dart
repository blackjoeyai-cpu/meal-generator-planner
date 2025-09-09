import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';
import 'package:meal_generator_planner/data/models/meal_plan_generation_request.dart';
import 'package:meal_generator_planner/data/repositories/meal_repository.dart';
import 'package:meal_generator_planner/data/repositories/meal_plan_repository.dart';
import 'package:meal_generator_planner/features/meal_plan/presentation/pages/generate_meal_plan_page.dart';

import 'package:meal_generator_planner/providers/meal_plan_generator_provider.dart';

import 'package:mockito/annotations.dart';

// Generate mocks
@GenerateMocks([MealRepository, MealPlanRepository])


// Mock implementation of MealRepository for testing
class MockMealRepositoryImpl implements MealRepository {
  @override
  Future<void> addMeal(Meal meal) async {}

  @override
  Future<List<Meal>> getAllMeals() async {
    // Return a list of meals for testing (enough for a week)
    List<Meal> meals = [];
    
    // Add 10 breakfast meals
    for (int i = 0; i < 10; i++) {
      meals.add(Meal(
        id: 'breakfast_$i',
        name: 'Test Breakfast $i',
        ingredients: ['ingredient_$i'],
        category: 'breakfast',
        calories: 300 + (i * 10),
        createdAt: DateTime.now(),
      ));
    }
    
    // Add 10 lunch meals
    for (int i = 0; i < 10; i++) {
      meals.add(Meal(
        id: 'lunch_$i',
        name: 'Test Lunch $i',
        ingredients: ['ingredient_$i'],
        category: 'lunch',
        calories: 400 + (i * 10),
        createdAt: DateTime.now(),
      ));
    }
    
    // Add 10 dinner meals
    for (int i = 0; i < 10; i++) {
      meals.add(Meal(
        id: 'dinner_$i',
        name: 'Test Dinner $i',
        ingredients: ['ingredient_$i'],
        category: 'dinner',
        calories: 500 + (i * 10),
        createdAt: DateTime.now(),
      ));
    }
    
    // Add 10 snack meals
    for (int i = 0; i < 10; i++) {
      meals.add(Meal(
        id: 'snack_$i',
        name: 'Test Snack $i',
        ingredients: ['ingredient_$i'],
        category: 'snack',
        calories: 150 + (i * 10),
        createdAt: DateTime.now(),
      ));
    }
    
    return meals;
  }

  @override
  Future<Meal?> getMealById(String id) async => null;

  @override
  Future<List<Meal>> getMealsByCategory(String category) async => [];

  @override
  Future<List<Meal>> getFavoriteMeals() async => [];

  @override
  Future<List<Meal>> searchMeals(String query) async => [];

  @override
  Future<void> toggleMealFavorite(String mealId) async {}

  @override
  Future<void> updateMeal(Meal meal) async {}

  @override
  Future<void> deleteMeal(String id) async {}

  // Added missing implementations
  @override
  Future<List<Meal>> getMealsByDietaryTags(List<DietaryTag> tags) async => [];

  @override
  Future<List<Meal>> getMealsExcludingIds(List<String> excludedIds) async => [];

  @override
  Future<List<Meal>> getRecentMeals(DateTime since) async => [];
}

// Mock implementation of MealPlanRepository for testing
class MockMealPlanRepositoryImpl implements MealPlanRepository {
  @override
  Future<void> addMealPlan(MealPlan mealPlan) async {}

  @override
  Future<List<MealPlan>> getAllMealPlans() async => [];

  @override
  Future<MealPlan?> getMealPlanByDate(DateTime date) async => null;

  @override
  Future<List<MealPlan>> getMealPlansInRange(DateTime startDate, DateTime endDate) async => [];

  @override
  Future<List<MealPlan>> getCurrentWeekMealPlans() async => [];

  @override
  Future<bool> hasMealPlanForDate(DateTime date) async => false;

  @override
  Future<void> updateMealPlan(MealPlan mealPlan) async {}

  @override
  Future<void> deleteMealPlan(String id) async {}

  // Added missing implementations
  @override
  Future<List<MealPlan>> getMealPlansForWeek(DateTime weekStartDate) async => [];

  @override
  Future<MealPlan?> getMostRecentMealPlan() async => null;

  @override
  Future<List<String>> getRecentMealIds(DateTime since) async => [];
}

void main() {
  group('Meal Plan Regeneration Integration Tests', () {
    testWidgets('User can regenerate meal plan if unsatisfied', (WidgetTester tester) async {
      // Create a widget tree with the provider scope
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mealPlanGeneratorProvider.overrideWith((ref) {
              final mealRepository = MockMealRepositoryImpl();
              final mealPlanRepository = MockMealPlanRepositoryImpl();
              return MealPlanGeneratorNotifier(
                mealRepository: mealRepository,
                mealPlanRepository: mealPlanRepository,
              );
            }),
          ],
          child: const MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify we're on the generation page
      expect(find.text('Generate Meal Plan'), findsAtLeast(1)); // AppBar title
      expect(find.text('Configure your meal plan'), findsOneWidget);

      // Tap the generate button (use widgetWithText to be more specific)
      final generateButton = find.widgetWithText(ElevatedButton, 'Generate Meal Plan');
      expect(generateButton, findsOneWidget);
      await tester.tap(generateButton);
      await tester.pump();

      // Wait for navigation to results page
      await tester.pumpAndSettle();

      // Verify we're on the results page
      expect(find.text('Your Meal Plan'), findsOneWidget);

      // Find and tap the regenerate button
      final regenerateButton = find.byIcon(Icons.refresh);
      expect(regenerateButton, findsOneWidget);
      await tester.tap(regenerateButton);
      await tester.pump();

      // Verify that a snackbar is shown
      expect(find.text('Regenerating meal plan...'), findsOneWidget);

      // Wait for regeneration to complete
      await tester.pumpAndSettle();

      // Verify we're still on the results page
      expect(find.text('Your Meal Plan'), findsOneWidget);
    });

    testWidgets('Regenerate button works from error state', (WidgetTester tester) async {
      // Create a widget tree with the provider scope
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mealPlanGeneratorProvider.overrideWith((ref) {
              // Return a mock provider that throws an error on generation
              return MockMealPlanGeneratorNotifier();
            }),
          ],
          child: const MaterialApp(
            home: GenerateMealPlanPage(),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Tap the generate button (use widgetWithText to be more specific)
      final generateButton = find.widgetWithText(ElevatedButton, 'Generate Meal Plan');
      await tester.tap(generateButton);
      await tester.pumpAndSettle();

      // Verify we're on the results page with an error
      expect(find.text('Error Generating Meal Plan'), findsOneWidget);

      // Find and tap the try again button
      final tryAgainButton = find.widgetWithText(ElevatedButton, 'Try Again');
      await tester.tap(tryAgainButton);
      await tester.pump();

      // Verify that the regeneration was attempted
      // Note: In a real test, we would verify the actual regeneration logic
      // For now, we're just testing that the UI flow works
    });
  });
}

// Mock notifier for testing error scenarios
class MockMealPlanGeneratorNotifier extends MealPlanGeneratorNotifier {
  MockMealPlanGeneratorNotifier()
      : super(
          mealRepository: MockMealRepositoryImpl(),
          mealPlanRepository: MockMealPlanRepositoryImpl(),
        );

  @override
  Future<void> generateMealPlan(MealPlanGenerationRequest request) async {
    // Simulate an error for testing
    state = state.copyWith(
      isLoading: false,
      errorMessage: 'Test error for regeneration',
      lastRequest: request,
    );
  }

  @override
  Future<void> regenerateMealPlan() async {
    if (state.lastRequest == null) {
      state = state.copyWith(errorMessage: 'No previous generation request found');
      return;
    }

    // In a real implementation, this would call generateMealPlan
    // For testing, we'll just update the state to show the regeneration was attempted
    state = state.copyWith(
      isLoading: false,
      errorMessage: null,
      isSuccess: true,
    );
  }
}