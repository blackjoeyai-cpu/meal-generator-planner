import 'dart:math';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';
import 'package:meal_generator_planner/data/models/meal_plan_generation_request.dart';
import 'package:meal_generator_planner/data/repositories/meal_repository.dart';

import 'package:meal_generator_planner/core/utils/date_utils.dart';
import 'package:meal_generator_planner/core/utils/id_generator.dart';

/// Exception thrown when there are insufficient meals in the database
class InsufficientMealsException implements Exception {
  final String message;

  InsufficientMealsException(this.message);

  @override
  String toString() => 'InsufficientMealsException: $message';
}

/// Exception thrown when parameters are over-constrained
class OverConstrainedParametersException implements Exception {
  final String message;

  OverConstrainedParametersException(this.message);

  @override
  String toString() => 'OverConstrainedParametersException: $message';
}

/// Exception thrown when the generation algorithm fails
class GenerationAlgorithmException implements Exception {
  final String message;

  GenerationAlgorithmException(this.message);

  @override
  String toString() => 'GenerationAlgorithmException: $message';
}

/// Service responsible for generating meal plans based on user preferences and constraints
class MealGenerationService {
  final MealRepository _mealRepository;

  MealGenerationService({required MealRepository mealRepository})
    : _mealRepository = mealRepository;

  /// Generate a weekly meal plan based on the provided request parameters
  Future<List<MealPlan>> generateWeeklyMealPlan(
    MealPlanGenerationRequest request,
  ) async {
    try {
      // Load available meals from repository
      List<Meal> availableMeals = await _loadAvailableMeals(request);

      // Apply filters based on request parameters
      availableMeals = _applyFilters(availableMeals, request);

      // Check if parameters are over-constrained
      _checkForOverConstrainedParameters(availableMeals, request);

      // Validate that we have enough meals
      if (!_validateMealAvailability(availableMeals)) {
        throw InsufficientMealsException(
          'Insufficient meals in database. Please add more meals or relax constraints. '
          'Current meal count: ${availableMeals.length}, Required: 21',
        );
      }

      // Generate daily meal plans for the week
      final List<MealPlan> weeklyPlan = await _generateDailyMeals(
        availableMeals,
        request,
      );

      return weeklyPlan;
    } catch (e) {
      // Re-throw known exceptions
      if (e is InsufficientMealsException ||
          e is OverConstrainedParametersException ||
          e is GenerationAlgorithmException) {
        rethrow;
      }

      // Wrap unknown exceptions
      throw GenerationAlgorithmException('Failed to generate meal plan: $e');
    }
  }

  /// Load available meals from the repository
  Future<List<Meal>> _loadAvailableMeals(
    MealPlanGenerationRequest request,
  ) async {
    // Get all meals from repository
    List<Meal> meals = await _mealRepository.getAllMeals();

    // Remove meals used in the previous week
    if (request.previousWeekMealIds.isNotEmpty) {
      meals.removeWhere(
        (meal) => request.previousWeekMealIds.contains(meal.id),
      );
    }

    return meals;
  }

  /// Apply filters based on request parameters
  List<Meal> _applyFilters(
    List<Meal> meals,
    MealPlanGenerationRequest request,
  ) {
    // Filter by dietary restrictions
    if (request.restrictions.isNotEmpty) {
      meals = meals.where((meal) {
        // If meal has no dietary tags, it's considered acceptable
        if (meal.dietaryTags.isEmpty) return true;

        // Check if all meal tags are compatible with restrictions
        return meal.dietaryTags.every(
          (tag) => request.restrictions.contains(tag),
        );
      }).toList();
    }

    // Exclude meals with forbidden ingredients
    if (request.excludedIngredients.isNotEmpty) {
      meals = meals.where((meal) {
        return !meal.ingredients.any(
          (ingredient) => request.excludedIngredients.any(
            (excluded) =>
                ingredient.toLowerCase().contains(excluded.toLowerCase()),
          ),
        );
      }).toList();
    }

    return meals;
  }

  /// Check if parameters are over-constrained
  void _checkForOverConstrainedParameters(
    List<Meal> meals,
    MealPlanGenerationRequest request,
  ) {
    // Check if we have enough meals in each category
    final breakfastMeals = meals
        .where((meal) => meal.category == 'breakfast')
        .length;
    final lunchMeals = meals.where((meal) => meal.category == 'lunch').length;
    final dinnerMeals = meals.where((meal) => meal.category == 'dinner').length;

    if (breakfastMeals < 7) {
      throw OverConstrainedParametersException(
        'Not enough breakfast meals available (found: $breakfastMeals, needed: 7). '
        'Please relax dietary restrictions or add more breakfast meals.',
      );
    }

    if (lunchMeals < 7) {
      throw OverConstrainedParametersException(
        'Not enough lunch meals available (found: $lunchMeals, needed: 7). '
        'Please relax dietary restrictions or add more lunch meals.',
      );
    }

    if (dinnerMeals < 7) {
      throw OverConstrainedParametersException(
        'Not enough dinner meals available (found: $dinnerMeals, needed: 7). '
        'Please relax dietary restrictions or add more dinner meals.',
      );
    }
  }

  /// Validate that we have enough meals to generate a plan
  bool _validateMealAvailability(List<Meal> meals) {
    // We need at least 21 meals (3 meals/day * 7 days)
    return meals.length >= 21;
  }

  /// Generate daily meal plans for the week
  Future<List<MealPlan>> _generateDailyMeals(
    List<Meal> availableMeals,
    MealPlanGenerationRequest request,
  ) async {
    final List<MealPlan> dailyPlans = [];
    final List<Meal> usedMeals = [];

    // Create a working copy of available meals
    List<Meal> workingMeals = List.from(availableMeals);

    // Generate plan for each day of the week
    for (int i = 0; i < 7; i++) {
      final DateTime currentDate = DateUtils.addDaysToDate(
        request.weekStartDate,
        i,
      );

      // Get pinned favorites for this day if any
      final List<Meal> pinnedFavorites = await _getPinnedFavorites(
        request.pinnedFavoriteIds,
        currentDate,
      );

      // Generate meals for this day
      final MealPlan dailyPlan = await _generateDailyMealPlan(
        workingMeals,
        currentDate,
        request,
        pinnedFavorites,
        usedMeals,
      );

      // Add to results
      dailyPlans.add(dailyPlan);

      // Update used meals list
      usedMeals.addAll(dailyPlan.allMeals);

      // Remove used meals from working pool to avoid repetition
      workingMeals.removeWhere((meal) => usedMeals.contains(meal));

      // If we're running low on meals, reset the working pool
      if (workingMeals.length < 5) {
        workingMeals = List.from(availableMeals);
        // But still exclude currently used meals
        workingMeals.removeWhere((meal) => usedMeals.contains(meal));
      }
    }

    return dailyPlans;
  }

  /// Get pinned favorites for a specific date
  Future<List<Meal>> _getPinnedFavorites(
    List<String> pinnedFavoriteIds,
    DateTime date,
  ) async {
    final List<Meal> pinnedFavorites = [];

    for (final id in pinnedFavoriteIds) {
      final meal = await _mealRepository.getMealById(id);
      if (meal != null) {
        pinnedFavorites.add(meal);
      }
    }

    return pinnedFavorites;
  }

  /// Generate a meal plan for a single day
  Future<MealPlan> _generateDailyMealPlan(
    List<Meal> availableMeals,
    DateTime date,
    MealPlanGenerationRequest request,
    List<Meal> pinnedFavorites,
    List<Meal> usedMeals,
  ) async {
    Meal? breakfast;
    Meal? lunch;
    Meal? dinner;
    final List<Meal> snacks = [];

    // Try to use pinned favorites first
    for (final favorite in pinnedFavorites) {
      switch (favorite.category) {
        case 'breakfast':
          breakfast = favorite;
          break;
        case 'lunch':
          lunch = favorite;
          break;
        case 'dinner':
          dinner = favorite;
          break;
      }
    }

    // Generate breakfast if not pinned
    breakfast ??= _selectMeal(availableMeals, 'breakfast', request, usedMeals);

    // Generate lunch if not pinned
    lunch ??= _selectMeal(availableMeals, 'lunch', request, usedMeals);

    // Generate dinner if not pinned
    dinner ??= _selectMeal(availableMeals, 'dinner', request, usedMeals);

    // Generate snacks (0-2 per day, max 200 calories each)
    final int snackCount = Random().nextInt(3); // 0, 1, or 2 snacks
    for (int i = 0; i < snackCount; i++) {
      final snack = _selectMeal(availableMeals, 'snack', request, usedMeals);

      // Ensure snack is under 200 calories
      if (snack.calories <= 200) {
        snacks.add(snack);
      } else {
        // Find a lower calorie snack
        final lowCalorieSnack = availableMeals
            .where((meal) => meal.category == 'snack' && meal.calories <= 200)
            .toList();
        if (lowCalorieSnack.isNotEmpty) {
          snacks.add(lowCalorieSnack[Random().nextInt(lowCalorieSnack.length)]);
        }
      }
    }

    // Create and return the daily meal plan
    return MealPlan(
      id: IdGenerator.generateId(),
      date: date,
      breakfast: breakfast,
      lunch: lunch,
      dinner: dinner,
      snacks: snacks,
    );
  }

  /// Select a meal based on category and weighted selection algorithm
  Meal _selectMeal(
    List<Meal> availableMeals,
    String category,
    MealPlanGenerationRequest request,
    List<Meal> usedMeals,
  ) {
    // Filter meals by category
    List<Meal> categoryMeals = availableMeals
        .where((meal) => meal.category == category)
        .toList();

    // If no meals in this category, throw an exception
    if (categoryMeals.isEmpty) {
      throw GenerationAlgorithmException(
        'No meals available for category: $category',
      );
    }

    // Apply weighted selection algorithm
    // Favorites: 40% higher probability
    // Recently unused: 30% higher probability
    // Nutritionally balanced: 20% higher probability
    // Random selection: 10%

    // Create a weighted list
    final List<Meal> weightedMeals = [];

    for (final meal in categoryMeals) {
      // Base weight
      int weight = 10;

      // Increase weight for favorites
      if (meal.isFavorite && request.includeFavorites) {
        weight += 40;
      }

      // Increase weight for recently unused meals
      if (!usedMeals.contains(meal)) {
        weight += 30;
      }

      // Add meal to weighted list based on its weight
      for (int i = 0; i < weight; i++) {
        weightedMeals.add(meal);
      }
    }

    // Select a random meal from the weighted list
    if (weightedMeals.isEmpty) {
      // Fallback to random selection from original list
      return categoryMeals[Random().nextInt(categoryMeals.length)];
    }

    return weightedMeals[Random().nextInt(weightedMeals.length)];
  }
}
