import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/providers/meal_plan_generator_provider.dart';
import 'package:meal_generator_planner/data/models/meal_plan_generation_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('MealPlanGeneratorProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should store last request for regeneration', () {
      // Arrange
      final provider = container.read(mealPlanGeneratorProvider.notifier);
      final request = MealPlanGenerationRequest(
        weekStartDate: DateTime(2024, 1, 15),
        numberOfPeople: 4,
        restrictions: [],
        excludedIngredients: [],
        previousWeekMealIds: [],
        includeFavorites: true,
        pinnedFavoriteIds: [],
      );

      // Act
      provider.state = provider.state.copyWith(lastRequest: request);

      // Assert
      expect(container.read(mealPlanGeneratorProvider).lastRequest, request);
    });

    test('should clear state properly', () {
      // Arrange
      final provider = container.read(mealPlanGeneratorProvider.notifier);
      final request = MealPlanGenerationRequest(
        weekStartDate: DateTime(2024, 1, 15),
        numberOfPeople: 4,
        restrictions: [],
        excludedIngredients: [],
        previousWeekMealIds: [],
        includeFavorites: true,
        pinnedFavoriteIds: [],
      );
      
      provider.state = provider.state.copyWith(
        isLoading: true,
        errorMessage: 'Test error',
        isSuccess: true,
        lastRequest: request,
      );

      // Act
      provider.clearState();

      // Assert
      final state = container.read(mealPlanGeneratorProvider);
      expect(state.isLoading, false);
      expect(state.errorMessage, null);
      expect(state.isSuccess, false);
      expect(state.lastRequest, null);
    });

    test('regenerateMealPlan should fail when no last request is available', () async {
      // Arrange
      final provider = container.read(mealPlanGeneratorProvider.notifier);

      // Act
      await provider.regenerateMealPlan();

      // Assert
      expect(container.read(mealPlanGeneratorProvider).errorMessage, 
        'No previous generation request found');
    });
  });
}