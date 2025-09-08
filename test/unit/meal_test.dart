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
      );

      expect(meal.id, 'test_id');
      expect(meal.name, 'Test Meal');
      expect(meal.ingredients, ['ingredient1', 'ingredient2']);
      expect(meal.category, 'breakfast');
      expect(meal.calories, 0); // default value
      expect(meal.isFavorite, false); // default value
    });

    test('should create a copy with updated values', () {
      final originalMeal = Meal(
        id: 'test_id',
        name: 'Original Meal',
        ingredients: ['ingredient1'],
        category: 'breakfast',
      );

      final updatedMeal = originalMeal.copyWith(
        name: 'Updated Meal',
        calories: 300,
      );

      expect(updatedMeal.id, 'test_id'); // unchanged
      expect(updatedMeal.name, 'Updated Meal'); // changed
      expect(updatedMeal.calories, 300); // changed
      expect(updatedMeal.category, 'breakfast'); // unchanged
    });

    test('should have correct equality comparison', () {
      final meal1 = Meal(
        id: 'same_id',
        name: 'Meal 1',
        ingredients: ['ingredient1'],
        category: 'breakfast',
      );

      final meal2 = Meal(
        id: 'same_id',
        name: 'Meal 2', // different name but same id
        ingredients: ['ingredient2'],
        category: 'lunch',
      );

      final meal3 = Meal(
        id: 'different_id',
        name: 'Meal 1',
        ingredients: ['ingredient1'],
        category: 'breakfast',
      );

      expect(meal1, equals(meal2)); // same id
      expect(meal1, isNot(equals(meal3))); // different id
    });
  });
}