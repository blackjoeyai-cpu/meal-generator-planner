import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/data/models/daily_meals.dart';
import 'package:meal_generator_planner/data/models/enums.dart';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';

void main() {
  group('MealPlan Model Tests', () {
    final testStartDate = DateTime(2024, 1, 15);
    final dummyMeal = Meal(
      id: 'meal_id',
      name: 'Test Meal',
      description: 'Test description',
      ingredients: [],
      category: MealCategory.breakfast,
      estimatedCalories: 100,
      preparationTimeMinutes: 10,
      difficulty: DifficultyLevel.easy,
      dietaryTags: [],
      imageAssetPath: '',
      cookingInstructions: '',
      defaultServings: 1,
      createdAt: DateTime.now(),
    );

    final dailyMeals = DailyMeals(
      breakfast: dummyMeal,
      lunch: dummyMeal,
      dinner: dummyMeal,
    );

    final generationRequest = MealPlanGenerationRequest(
      weekStartDate: testStartDate,
      numberOfPeople: 2,
    );

    test('should create a meal plan with required fields', () {
      final mealPlan = MealPlan(
        id: 'plan_id',
        weekStartDate: testStartDate,
        dailyMeals: {'2024-01-15': dailyMeals},
        generatedAt: DateTime.now(),
        generationParameters: generationRequest,
      );

      expect(mealPlan.id, 'plan_id');
      expect(mealPlan.weekStartDate, testStartDate);
      expect(mealPlan.dailyMeals.length, 1);
      expect(mealPlan.isActive, false); // default value
    });

    test('should create a copy with updated values', () {
      final originalMealPlan = MealPlan(
        id: 'plan_id',
        weekStartDate: testStartDate,
        dailyMeals: {'2024-01-15': dailyMeals},
        generatedAt: DateTime.now(),
        generationParameters: generationRequest,
      );

      final updatedMealPlan = originalMealPlan.copyWith(
        isActive: true,
      );

      expect(updatedMealPlan.id, 'plan_id');
      expect(updatedMealPlan.isActive, true);
    });

    test('should have correct equality comparison', () {
      final now = DateTime.now();
      final plan1 = MealPlan(
        id: 'same_id',
        weekStartDate: testStartDate,
        dailyMeals: {},
        generatedAt: now,
        generationParameters: generationRequest,
      );

      final plan2 = MealPlan(
        id: 'same_id',
        weekStartDate: testStartDate.add(const Duration(days: 7)), // different date
        dailyMeals: {},
        generatedAt: now,
        generationParameters: generationRequest,
      );

      final plan3 = MealPlan(
        id: 'different_id',
        weekStartDate: testStartDate,
        dailyMeals: {},
        generatedAt: now,
        generationParameters: generationRequest,
      );

      expect(plan1, equals(plan2)); // same id
      expect(plan1, isNot(equals(plan3))); // different id
    });
  });
}
