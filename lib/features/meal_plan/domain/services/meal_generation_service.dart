import 'dart:math';

import 'package:collection/collection.dart';
import 'package:meal_generator_planner/data/models/daily_meals.dart';
import 'package:meal_generator_planner/data/models/enums.dart';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';
import 'package:meal_generator_planner/data/repositories/meal_repository.dart';
import 'package:meal_generator_planner/core/utils/id_generator.dart';

class MealGenerationService {
  final MealRepository _mealRepository;
  final Random _random = Random();

  MealGenerationService(this._mealRepository);

  Future<MealPlan> generatePlan(MealPlanGenerationRequest request) async {
    // 1. Data Preparation
    final meals = await _loadFilteredMeals(request);

    // 2. Validate sufficient meal variety
    if (meals.length < 21) {
      // For now, we'll proceed, but a real implementation would show a warning
      // as per the PRD.
    }

    // 3. Generate daily meal assignments
    final availableMeals = List<Meal>.from(meals);
    final weeklyMeals = <String, DailyMeals>{};

    for (int day = 0; day < 7; day++) {
      final currentDate = request.weekStartDate.add(Duration(days: day));
      final dailyMeals = _generateDayMeals(availableMeals, request);
      weeklyMeals[currentDate.toIso8601String()] = dailyMeals;
    }

    // 4. Create and return meal plan
    return MealPlan(
      id: IdGenerator.generateMealPlanId(),
      weekStartDate: request.weekStartDate,
      dailyMeals: weeklyMeals,
      generatedAt: DateTime.now(),
      generationParameters: request,
    );
  }

  Future<List<Meal>> _loadFilteredMeals(
    MealPlanGenerationRequest request,
  ) async {
    final allMeals = await _mealRepository.getAllMeals();

    // TODO: The PRD mentions filtering out meals from previousWeekMealIds.
    // This needs to be implemented when the request object is fully used.

    return allMeals.where((meal) {
      // Filter by dietary restrictions
      if (request.restrictions.isNotEmpty &&
          !request.restrictions.every((r) => meal.dietaryTags.contains(r))) {
        return false;
      }

      // Filter by excluded ingredients
      if (request.excludedIngredients.isNotEmpty &&
          meal.ingredients.any(
            (i) => request.excludedIngredients.contains(i.name.toLowerCase()),
          )) {
        return false;
      }

      return true;
    }).toList();
  }

  DailyMeals _generateDayMeals(
    List<Meal> availableMeals,
    MealPlanGenerationRequest request,
  ) {
    final breakfast = _selectMealForCategory(
      MealCategory.breakfast,
      availableMeals,
      request,
    );
    final lunch = _selectMealForCategory(
      MealCategory.lunch,
      availableMeals,
      request,
    );
    final dinner = _selectMealForCategory(
      MealCategory.dinner,
      availableMeals,
      request,
    );
    final snacks = _selectSnacks(availableMeals, request);

    return DailyMeals(
      breakfast: breakfast,
      lunch: lunch,
      dinner: dinner,
      snacks: snacks,
    );
  }

  Meal _selectMealForCategory(
    MealCategory category,
    List<Meal> availableMeals,
    MealPlanGenerationRequest request,
  ) {
    var selectableMeals = availableMeals
        .where((m) => m.category == category)
        .toList();

    // Handle pinned favorites
    final pinnedMealId = request.pinnedFavoriteIds.firstWhereOrNull(
      (id) => selectableMeals.any((meal) => meal.id == id),
    );
    if (pinnedMealId != null) {
      final pinnedMeal = selectableMeals.firstWhere(
        (meal) => meal.id == pinnedMealId,
      );
      availableMeals.remove(pinnedMeal);
      return pinnedMeal;
    }

    if (selectableMeals.isEmpty) {
      // Fallback: if no meals in category, pick any meal.
      // A better implementation would follow the PRD's relaxation strategy.
      if (availableMeals.isEmpty) {
        throw Exception('Not enough meals to generate a plan.');
      }
      final meal = availableMeals[_random.nextInt(availableMeals.length)];
      availableMeals.remove(meal);
      return meal;
    }

    // TODO: Implement the weighted selection algorithm from the PRD.
    // For now, using simple random selection.
    final meal = selectableMeals[_random.nextInt(selectableMeals.length)];
    availableMeals.remove(meal);
    return meal;
  }

  List<Meal> _selectSnacks(
    List<Meal> availableMeals,
    MealPlanGenerationRequest request,
  ) {
    final snacks = <Meal>[];
    final potentialSnacks = availableMeals
        .where((m) => m.category == MealCategory.snack)
        .toList();

    if (potentialSnacks.isEmpty) return [];

    // Select 0 to 2 snacks per day, as per PRD
    final numberOfSnacks = _random.nextInt(3);

    for (int i = 0; i < numberOfSnacks && potentialSnacks.isNotEmpty; i++) {
      final snack = potentialSnacks[_random.nextInt(potentialSnacks.length)];
      snacks.add(snack);
      availableMeals.remove(snack);
      potentialSnacks.remove(snack);
    }

    return snacks;
  }
}
