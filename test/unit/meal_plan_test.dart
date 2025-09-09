import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';

void main() {
  group('MealPlan Model Tests', () {
    test('should create a meal plan with all required fields', () {
      final testBreakfast = Meal(
        id: '1',
        name: 'Test Breakfast',
        ingredients: ['ingredient1', 'ingredient2'],
        category: 'breakfast',
        calories: 300,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final testLunch = Meal(
        id: '2',
        name: 'Test Lunch',
        ingredients: ['ingredient3', 'ingredient4'],
        category: 'lunch',
        calories: 500,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final testDinner = Meal(
        id: '3',
        name: 'Test Dinner',
        ingredients: ['ingredient5', 'ingredient6'],
        category: 'dinner',
        calories: 600,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final testDate = DateTime(2024, 1, 15);
      final mealPlan = MealPlan(
        id: 'test_id',
        date: testDate,
        breakfast: testBreakfast,
        lunch: testLunch,
        dinner: testDinner,
      );

      expect(mealPlan.id, 'test_id');
      expect(mealPlan.date, testDate);
      expect(mealPlan.breakfast, testBreakfast);
      expect(mealPlan.lunch, testLunch);
      expect(mealPlan.dinner, testDinner);
      expect(mealPlan.snacks, isEmpty);
    });

    test('should calculate total calories correctly', () {
      final testBreakfast = Meal(
        id: '1',
        name: 'Test Breakfast',
        ingredients: ['ingredient1', 'ingredient2'],
        category: 'breakfast',
        calories: 300,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final testLunch = Meal(
        id: '2',
        name: 'Test Lunch',
        ingredients: ['ingredient3', 'ingredient4'],
        category: 'lunch',
        calories: 500,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final testDinner = Meal(
        id: '3',
        name: 'Test Dinner',
        ingredients: ['ingredient5', 'ingredient6'],
        category: 'dinner',
        calories: 600,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final snack = Meal(
        id: '4',
        name: 'Test Snack',
        ingredients: ['ingredient7'],
        category: 'snack',
        calories: 200,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final mealPlan = MealPlan(
        id: 'test_id',
        date: DateTime(2024, 1, 15),
        breakfast: testBreakfast,
        lunch: testLunch,
        dinner: testDinner,
        snacks: [snack],
      );

      // Total should be 300 + 500 + 600 + 200 = 1600
      expect(mealPlan.totalCalories, 1600);
    });

    test('should determine if meal plan is complete', () {
      final testBreakfast = Meal(
        id: '1',
        name: 'Test Breakfast',
        ingredients: ['ingredient1', 'ingredient2'],
        category: 'breakfast',
        calories: 300,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final testLunch = Meal(
        id: '2',
        name: 'Test Lunch',
        ingredients: ['ingredient3', 'ingredient4'],
        category: 'lunch',
        calories: 500,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final testDinner = Meal(
        id: '3',
        name: 'Test Dinner',
        ingredients: ['ingredient5', 'ingredient6'],
        category: 'dinner',
        calories: 600,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      // Complete meal plan
      final completeMealPlan = MealPlan(
        id: 'complete_id',
        date: DateTime(2024, 1, 15),
        breakfast: testBreakfast,
        lunch: testLunch,
        dinner: testDinner,
      );

      expect(completeMealPlan.isComplete, true);

      // Incomplete meal plan
      final incompleteMealPlan = MealPlan(
        id: 'incomplete_id',
        date: DateTime(2024, 1, 15),
        breakfast: testBreakfast,
        lunch: testLunch,
        // No dinner
      );

      expect(incompleteMealPlan.isComplete, false);
    });

    test('should get all meals correctly', () {
      final testBreakfast = Meal(
        id: '1',
        name: 'Test Breakfast',
        ingredients: ['ingredient1', 'ingredient2'],
        category: 'breakfast',
        calories: 300,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final testLunch = Meal(
        id: '2',
        name: 'Test Lunch',
        ingredients: ['ingredient3', 'ingredient4'],
        category: 'lunch',
        calories: 500,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final testDinner = Meal(
        id: '3',
        name: 'Test Dinner',
        ingredients: ['ingredient5', 'ingredient6'],
        category: 'dinner',
        calories: 600,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final snack1 = Meal(
        id: '4',
        name: 'Test Snack 1',
        ingredients: ['ingredient7'],
        category: 'snack',
        calories: 200,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final snack2 = Meal(
        id: '5',
        name: 'Test Snack 2',
        ingredients: ['ingredient8'],
        category: 'snack',
        calories: 150,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final mealPlan = MealPlan(
        id: 'test_id',
        date: DateTime(2024, 1, 15),
        breakfast: testBreakfast,
        lunch: testLunch,
        dinner: testDinner,
        snacks: [snack1, snack2],
      );

      final allMeals = mealPlan.allMeals;
      expect(allMeals.length, 5);
      expect(allMeals.contains(testBreakfast), true);
      expect(allMeals.contains(testLunch), true);
      expect(allMeals.contains(testDinner), true);
      expect(allMeals.contains(snack1), true);
      expect(allMeals.contains(snack2), true);
    });

    test('should copy with new values correctly', () {
      final originalMealPlan = MealPlan(
        id: 'original_id',
        date: DateTime(2024, 1, 15),
        breakfast: Meal(
          id: '1',
          name: 'Original Breakfast',
          ingredients: ['ingredient1'],
          category: 'breakfast',
          calories: 300,
          notes: 'Original notes',
          createdAt: DateTime.now(),
        ),
      );

      final newDate = DateTime(2024, 1, 16);
      final newLunch = Meal(
        id: '2',
        name: 'New Lunch',
        ingredients: ['ingredient2'],
        category: 'lunch',
        calories: 500,
        notes: 'New notes',
        createdAt: DateTime.now(),
      );

      final copiedMealPlan = originalMealPlan.copyWith(
        id: 'new_id',
        date: newDate,
        lunch: newLunch,
      );

      expect(copiedMealPlan.id, 'new_id');
      expect(copiedMealPlan.date, newDate);
      expect(
        copiedMealPlan.breakfast,
        originalMealPlan.breakfast,
      ); // Should be unchanged
      expect(copiedMealPlan.lunch, newLunch);
      expect(
        copiedMealPlan.dinner,
        originalMealPlan.dinner,
      ); // Should be unchanged
    });

    test('should have correct equality comparison', () {
      final meal1 = Meal(
        id: '1',
        name: 'Test Meal',
        ingredients: ['ingredient1'],
        category: 'breakfast',
        calories: 300,
        notes: 'Test notes',
        createdAt: DateTime.now(),
      );

      final mealPlan1 = MealPlan(
        id: 'test_id',
        date: DateTime(2024, 1, 15),
        breakfast: meal1,
      );

      final mealPlan2 = MealPlan(
        id: 'test_id', // Same ID
        date: DateTime(2024, 1, 15),
        breakfast: meal1,
      );

      final mealPlan3 = MealPlan(
        id: 'different_id', // Different ID
        date: DateTime(2024, 1, 15),
        breakfast: meal1,
      );

      expect(mealPlan1, equals(mealPlan2));
      expect(mealPlan1.hashCode, equals(mealPlan2.hashCode));
      expect(mealPlan1, isNot(equals(mealPlan3)));
    });

    test('should convert to string correctly', () {
      final mealPlan = MealPlan(id: 'test_id', date: DateTime(2024, 1, 15));

      expect(mealPlan.toString(), contains('MealPlan'));
      expect(mealPlan.toString(), contains('test_id'));
      expect(mealPlan.toString(), contains('2024-01-15'));
    });
  });
}
