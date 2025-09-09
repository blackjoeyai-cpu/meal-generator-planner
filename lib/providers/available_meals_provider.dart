import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/models/meal_plan_generation_request.dart';
import 'package:meal_generator_planner/data/repositories/meal_repository.dart';

/// State management for available meals with filtering capabilities
class AvailableMealsState {
  final bool isLoading;
  final List<Meal> meals;
  final String? errorMessage;
  final MealPlanGenerationRequest? filterCriteria;

  AvailableMealsState({
    this.isLoading = false,
    this.meals = const [],
    this.errorMessage,
    this.filterCriteria,
  });

  AvailableMealsState copyWith({
    bool? isLoading,
    List<Meal>? meals,
    String? errorMessage,
    MealPlanGenerationRequest? filterCriteria,
  }) {
    return AvailableMealsState(
      isLoading: isLoading ?? this.isLoading,
      meals: meals ?? this.meals,
      errorMessage: errorMessage ?? this.errorMessage,
      filterCriteria: filterCriteria ?? this.filterCriteria,
    );
  }
}

/// Provider for managing available meals with filtering
class AvailableMealsNotifier extends StateNotifier<AvailableMealsState> {
  final MealRepository _mealRepository;

  AvailableMealsNotifier({required MealRepository mealRepository})
    : _mealRepository = mealRepository,
      super(AvailableMealsState());

  /// Load all meals from the repository
  Future<void> loadAllMeals() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final meals = await _mealRepository.getAllMeals();
      state = state.copyWith(
        isLoading: false,
        meals: meals,
        errorMessage: null,
      );
    } catch (e, stackTrace) {
      debugPrint('Error loading meals: $e');
      debugPrint('Stack trace: $stackTrace');

      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Apply filters to the available meals
  void applyFilters(MealPlanGenerationRequest request) {
    state = state.copyWith(filterCriteria: request);

    // In a real implementation, we would re-fetch meals with the new filters
    // For now, we'll just update the filter criteria in state
  }

  /// Get meals filtered by the current criteria
  List<Meal> get filteredMeals {
    if (state.filterCriteria == null) {
      return state.meals;
    }

    List<Meal> filtered = List.from(state.meals);

    // Apply dietary restrictions filter
    if (state.filterCriteria!.restrictions.isNotEmpty) {
      filtered = filtered.where((meal) {
        // If meal has no dietary tags, it's considered acceptable
        if (meal.dietaryTags.isEmpty) return true;

        // Check if all meal tags are compatible with restrictions
        return meal.dietaryTags.every(
          (tag) => state.filterCriteria!.restrictions.contains(tag),
        );
      }).toList();
    }

    // Apply excluded ingredients filter
    if (state.filterCriteria!.excludedIngredients.isNotEmpty) {
      filtered = filtered.where((meal) {
        return !meal.ingredients.any(
          (ingredient) => state.filterCriteria!.excludedIngredients.any(
            (excluded) =>
                ingredient.toLowerCase().contains(excluded.toLowerCase()),
          ),
        );
      }).toList();
    }

    return filtered;
  }

  /// Clear the current state
  void clearState() {
    state = AvailableMealsState();
  }
}

/// Riverpod provider for available meals with filtering
final availableMealsProvider =
    StateNotifierProvider<AvailableMealsNotifier, AvailableMealsState>((ref) {
      // In a real implementation, this would be injected through ref.read
      // For now, we'll create a mock repository
      // TODO: Replace with actual repository instance when available
      final mealRepository = FakeMealRepository();

      return AvailableMealsNotifier(mealRepository: mealRepository);
    });

// TODO: Remove this fake repository when real one is available
class FakeMealRepository implements MealRepository {
  @override
  Future<void> addMeal(Meal meal) async {}

  @override
  Future<List<Meal>> getAllMeals() async => [];

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

  @override
  Future<List<Meal>> getMealsByDietaryTags(List<DietaryTag> tags) async => [];

  @override
  Future<List<Meal>> getRecentMeals(DateTime since) async => [];

  @override
  Future<List<Meal>> getMealsExcludingIds(List<String> excludedIds) async => [];
}
