import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';
import 'package:meal_generator_planner/data/models/meal.dart';

void main() {
  group('MealPlan Model Tests', () {
    final testDate = DateTime(2024, 1, 15);

    final testBreakfast = Meal(
      id: 'breakfast_id',
      name: 'Oatmeal',
      ingredients: ['oats', 'milk'],
      category: 'breakfast',
      calories: 300,
    );

    final testLunch = Meal(
      id: 'lunch_id',
      name: 'Sandwich',
      ingredients: ['bread', 'ham'],
      category: 'lunch',
      calories: 450,
    );

    final testDinner = Meal(
      id: 'dinner_id',
      name: 'Pasta',
      ingredients: ['pasta', 'sauce'],
      category: 'dinner',
      calories: 600,
    );

    test('should create a meal plan with required fields', () {
      final mealPlan = MealPlan(
        id: 'plan_id',
        date: testDate,
        breakfast: testBreakfast,
        lunch: testLunch,
        dinner: testDinner,
      );

      expect(mealPlan.id, 'plan_id');
      expect(mealPlan.date, testDate);
      expect(mealPlan.breakfast, testBreakfast);
      expect(mealPlan.lunch, testLunch);
      expect(mealPlan.dinner, testDinner);
      expect(mealPlan.snacks, isEmpty);
    });

    test('should calculate total calories correctly', () {
      final mealPlan = MealPlan(
        id: 'plan_id',
        date: testDate,
        breakfast: testBreakfast,
        lunch: testLunch,
        dinner: testDinner,
      );

      expect(mealPlan.totalCalories, 1350); // 300 + 450 + 600
    });

    test('should check if meal plan is complete', () {
      final completeMealPlan = MealPlan(
        id: 'complete_plan',
        date: testDate,
        breakfast: testBreakfast,
        lunch: testLunch,
        dinner: testDinner,
      );

      final incompleteMealPlan = MealPlan(
        id: 'incomplete_plan',
        date: testDate,
        breakfast: testBreakfast,
        lunch: testLunch,
        // dinner is null
      );

      expect(completeMealPlan.isComplete, true);
      expect(incompleteMealPlan.isComplete, false);
    });

    test('should get all meals including snacks', () {
      final snack = Meal(
        id: 'snack_id',
        name: 'Apple',
        ingredients: ['apple'],
        category: 'snack',
        calories: 80,
      );

      final mealPlan = MealPlan(
        id: 'plan_id',
        date: testDate,
        breakfast: testBreakfast,
        lunch: testLunch,
        snacks: [snack],
      );

      final allMeals = mealPlan.allMeals;
      expect(allMeals.length, 3); // breakfast, lunch, snack
      expect(allMeals.contains(testBreakfast), true);
      expect(allMeals.contains(testLunch), true);
      expect(allMeals.contains(snack), true);
    });
  });
}
