import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/data/models/enums.dart';
import 'package:meal_generator_planner/data/models/ingredient.dart';
import 'package:meal_generator_planner/data/models/meal.dart';

void main() {
  group('Meal Model Tests', () {
    test('should create a meal with required fields', () {
      final meal = Meal(
        id: 'test_id',
        name: 'Test Meal',
        description: 'Test description',
        ingredients: [
          Ingredient(
              name: 'ingredient1',
              quantity: 1,
              unit: 'cup',
              category: FoodCategory.pantry)
        ],
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

      expect(meal.id, 'test_id');
      expect(meal.name, 'Test Meal');
      expect(meal.isFavorite, false); // default value
    });

    test('should create a copy with updated values', () {
      final originalMeal = Meal(
        id: 'test_id',
        name: 'Original Meal',
        description: 'Original description',
        ingredients: [],
        category: MealCategory.breakfast,
        estimatedCalories: 200,
        preparationTimeMinutes: 10,
        difficulty: DifficultyLevel.easy,
        dietaryTags: [],
        imageAssetPath: '',
        cookingInstructions: '',
        defaultServings: 1,
        createdAt: DateTime.now(),
      );

      final updatedMeal = originalMeal.copyWith(
        name: 'Updated Meal',
        estimatedCalories: 300,
      );

      expect(updatedMeal.id, 'test_id'); // unchanged
      expect(updatedMeal.name, 'Updated Meal'); // changed
      expect(updatedMeal.estimatedCalories, 300); // changed
      expect(updatedMeal.category, MealCategory.breakfast); // unchanged
    });

    test('should have correct equality comparison', () {
      final now = DateTime.now();
      final meal1 = Meal(
        id: 'same_id',
        name: 'Meal 1',
        description: '',
        ingredients: [],
        category: MealCategory.breakfast,
        estimatedCalories: 0,
        preparationTimeMinutes: 0,
        difficulty: DifficultyLevel.easy,
        dietaryTags: [],
        imageAssetPath: '',
        cookingInstructions: '',
        defaultServings: 1,
        createdAt: now,
      );

      final meal2 = Meal(
        id: 'same_id',
        name: 'Meal 2', // different name but same id
        description: '',
        ingredients: [],
        category: MealCategory.lunch,
        estimatedCalories: 0,
        preparationTimeMinutes: 0,
        difficulty: DifficultyLevel.easy,
        dietaryTags: [],
        imageAssetPath: '',
        cookingInstructions: '',
        defaultServings: 1,
        createdAt: now,
      );

      final meal3 = Meal(
        id: 'different_id',
        name: 'Meal 1',
        description: '',
        ingredients: [],
        category: MealCategory.breakfast,
        estimatedCalories: 0,
        preparationTimeMinutes: 0,
        difficulty: DifficultyLevel.easy,
        dietaryTags: [],
        imageAssetPath: '',
        cookingInstructions: '',
        defaultServings: 1,
        createdAt: now,
      );

      expect(meal1, equals(meal2)); // same id
      expect(meal1, isNot(equals(meal3))); // different id
    });
  });
}
