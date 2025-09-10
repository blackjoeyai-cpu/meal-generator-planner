import 'package:meal_generator_planner/data/models/enums.dart';
import 'package:meal_generator_planner/data/models/meal.dart';

/// Abstract interface for meal data operations
abstract class MealRepository {
  /// Get all meals
  Future<List<Meal>> getAllMeals();

  /// Get meals by category
  Future<List<Meal>> getMealsByCategory(MealCategory category);

  /// Get meal by ID
  Future<Meal?> getMealById(String id);

  /// Save a meal (creates if new, updates if exists)
  Future<void> saveMeal(Meal meal);

  /// Delete a meal
  Future<void> deleteMeal(String id);

  /// Get favorite meals
  Future<List<Meal>> getFavoriteMeals();

  /// Toggle meal favorite status
  Future<void> toggleMealFavorite(String mealId);

  /// Search meals by name or ingredients
  Future<List<Meal>> searchMeals(String query);
}
