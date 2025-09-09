import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/data/models/meal_plan_generation_request.dart';
import 'package:meal_generator_planner/data/models/meal.dart';

void main() {
  group('MealPlanGenerationRequest Model Tests', () {
    test('should create a request with all required fields', () {
      final testDate = DateTime(2024, 1, 15);
      final request = MealPlanGenerationRequest(
        weekStartDate: testDate,
        numberOfPeople: 4,
        restrictions: [DietaryTag.vegetarian],
        excludedIngredients: ['nuts', 'shellfish'],
        previousWeekMealIds: ['meal1', 'meal2'],
        includeFavorites: true,
        pinnedFavoriteIds: ['fav1', 'fav2'],
      );

      expect(request.weekStartDate, testDate);
      expect(request.numberOfPeople, 4);
      expect(request.restrictions, [DietaryTag.vegetarian]);
      expect(request.excludedIngredients, ['nuts', 'shellfish']);
      expect(request.previousWeekMealIds, ['meal1', 'meal2']);
      expect(request.includeFavorites, true);
      expect(request.pinnedFavoriteIds, ['fav1', 'fav2']);
    });

    test('should use default values when not provided', () {
      final testDate = DateTime(2024, 1, 15);
      final request = MealPlanGenerationRequest(
        weekStartDate: testDate,
      );

      expect(request.weekStartDate, testDate);
      expect(request.numberOfPeople, 4); // Default value
      expect(request.restrictions, isEmpty);
      expect(request.excludedIngredients, isEmpty);
      expect(request.previousWeekMealIds, isEmpty);
      expect(request.includeFavorites, true); // Default value
      expect(request.pinnedFavoriteIds, isEmpty);
    });

    test('should copy with new values correctly', () {
      final originalRequest = MealPlanGenerationRequest(
        weekStartDate: DateTime(2024, 1, 15),
        numberOfPeople: 4,
        restrictions: [DietaryTag.vegetarian],
        excludedIngredients: ['nuts'],
        previousWeekMealIds: ['meal1'],
        includeFavorites: true,
        pinnedFavoriteIds: ['fav1'],
      );

      final newDate = DateTime(2024, 1, 22);
      final copiedRequest = originalRequest.copyWith(
        weekStartDate: newDate,
        numberOfPeople: 6,
        restrictions: [DietaryTag.vegan],
      );

      expect(copiedRequest.weekStartDate, newDate);
      expect(copiedRequest.numberOfPeople, 6);
      expect(copiedRequest.restrictions, [DietaryTag.vegan]);
      expect(copiedRequest.excludedIngredients, originalRequest.excludedIngredients); // Should be unchanged
      expect(copiedRequest.previousWeekMealIds, originalRequest.previousWeekMealIds); // Should be unchanged
      expect(copiedRequest.includeFavorites, originalRequest.includeFavorites); // Should be unchanged
      expect(copiedRequest.pinnedFavoriteIds, originalRequest.pinnedFavoriteIds); // Should be unchanged
    });

    test('should have correct equality comparison', () {
      final date = DateTime(2024, 1, 15);
      
      final request1 = MealPlanGenerationRequest(
        weekStartDate: date,
        numberOfPeople: 4,
        includeFavorites: true,
      );

      final request2 = MealPlanGenerationRequest(
        weekStartDate: date,
        numberOfPeople: 4,
        includeFavorites: true,
      );

      final request3 = MealPlanGenerationRequest(
        weekStartDate: date,
        numberOfPeople: 5, // Different value
        includeFavorites: true,
      );

      // For equality to work correctly, all fields must be identical
      expect(request1 == request2, true);
      expect(request1.hashCode, request2.hashCode);
      expect(request1 == request3, false);
    });

    test('should convert to string correctly', () {
      final request = MealPlanGenerationRequest(
        weekStartDate: DateTime(2024, 1, 15),
        numberOfPeople: 4,
        includeFavorites: true,
      );

      expect(request.toString(), contains('MealPlanGenerationRequest'));
      expect(request.toString(), contains('2024-01-15'));
      expect(request.toString(), contains('4'));
      expect(request.toString(), contains('true'));
    });
  });
}