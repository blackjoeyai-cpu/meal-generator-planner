import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/data/models/meal.dart';

void main() {
  group('Meal Model Tests', () {
    test('should create a meal with required fields', () {
      final meal = Meal(
        id: 'test_id',
        name: 'Test Meal',
        ingredients: ['ingredient1', 'ingredient2'],
        category: 'breakfast',
        createdAt: DateTime(2024, 1, 15),
      );

      expect(meal.id, 'test_id');
      expect(meal.name, 'Test Meal');
      expect(meal.ingredients, ['ingredient1', 'ingredient2']);
      expect(meal.category, 'breakfast');
      expect(meal.calories, 0); // default value
      expect(meal.isFavorite, false); // default value
      expect(meal.dietaryTags, isEmpty); // default value
      expect(meal.difficulty, DifficultyLevel.easy); // default value
      expect(meal.isCustomUserMeal, false); // default value
      expect(meal.createdAt, DateTime(2024, 1, 15));
    });

    test('should create a meal with all properties', () {
      final meal = Meal(
        id: 'test_id',
        name: 'Test Meal',
        ingredients: ['ingredient1', 'ingredient2'],
        category: 'breakfast',
        calories: 300,
        notes: 'Test notes',
        imageUrl: 'test_image.jpg',
        preparationTime: 30,
        isFavorite: true,
        dietaryTags: [DietaryTag.vegetarian, DietaryTag.glutenFree],
        difficulty: DifficultyLevel.medium,
        isCustomUserMeal: true,
        createdAt: DateTime(2024, 1, 15),
      );

      expect(meal.id, 'test_id');
      expect(meal.name, 'Test Meal');
      expect(meal.ingredients, ['ingredient1', 'ingredient2']);
      expect(meal.category, 'breakfast');
      expect(meal.calories, 300);
      expect(meal.notes, 'Test notes');
      expect(meal.imageUrl, 'test_image.jpg');
      expect(meal.preparationTime, 30);
      expect(meal.isFavorite, true);
      expect(meal.dietaryTags, [DietaryTag.vegetarian, DietaryTag.glutenFree]);
      expect(meal.difficulty, DifficultyLevel.medium);
      expect(meal.isCustomUserMeal, true);
      expect(meal.createdAt, DateTime(2024, 1, 15));
    });

    test('should create a copy with updated values', () {
      final originalMeal = Meal(
        id: 'test_id',
        name: 'Original Meal',
        ingredients: ['ingredient1'],
        category: 'breakfast',
        createdAt: DateTime(2024, 1, 15),
      );

      final updatedMeal = originalMeal.copyWith(
        name: 'Updated Meal',
        calories: 300,
        isFavorite: true,
        dietaryTags: [DietaryTag.vegetarian],
        difficulty: DifficultyLevel.hard,
        isCustomUserMeal: true,
        createdAt: DateTime(2024, 1, 16),
      );

      expect(updatedMeal.id, 'test_id'); // unchanged
      expect(updatedMeal.name, 'Updated Meal'); // changed
      expect(updatedMeal.calories, 300); // changed
      expect(updatedMeal.isFavorite, true); // changed
      expect(updatedMeal.dietaryTags, [DietaryTag.vegetarian]); // changed
      expect(updatedMeal.difficulty, DifficultyLevel.hard); // changed
      expect(updatedMeal.isCustomUserMeal, true); // changed
      expect(updatedMeal.createdAt, DateTime(2024, 1, 16)); // changed
      expect(updatedMeal.category, 'breakfast'); // unchanged
    });

    test('should have correct equality comparison', () {
      final meal1 = Meal(
        id: 'same_id',
        name: 'Meal 1',
        ingredients: ['ingredient1'],
        category: 'breakfast',
        createdAt: DateTime(2024, 1, 15),
      );

      final meal2 = Meal(
        id: 'same_id',
        name: 'Meal 2', // different name but same id
        ingredients: ['ingredient2'],
        category: 'lunch',
        createdAt: DateTime(2024, 1, 15),
      );

      final meal3 = Meal(
        id: 'different_id',
        name: 'Meal 1',
        ingredients: ['ingredient1'],
        category: 'breakfast',
        createdAt: DateTime(2024, 1, 15),
      );

      expect(meal1, equals(meal2)); // same id
      expect(meal1, isNot(equals(meal3))); // different id
    });

    test('should convert to string correctly', () {
      final meal = Meal(
        id: 'test_id',
        name: 'Test Meal',
        ingredients: ['ingredient1'],
        category: 'breakfast',
        calories: 300,
        createdAt: DateTime(2024, 1, 15),
      );

      expect(
        meal.toString(),
        'Meal(id: test_id, name: Test Meal, category: breakfast, calories: 300)',
      );
    });
  });
}
