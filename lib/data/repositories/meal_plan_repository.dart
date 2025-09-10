import 'package:meal_generator_planner/data/models/meal_plan.dart';

/// Abstract interface for meal plan data operations
abstract class MealPlanRepository {
  /// Get a meal plan by its ID
  Future<MealPlan?> getMealPlanById(String id);

  /// Get the currently active meal plan
  Future<MealPlan?> getCurrentMealPlan();

  /// Get all non-active meal plans
  Future<List<MealPlan>> getMealPlanHistory();

  /// Save a meal plan (creates if new, updates if exists)
  Future<void> saveMealPlan(MealPlan plan);

  /// Set a meal plan as the active one
  Future<void> setActiveMealPlan(String id);

  /// Delete a meal plan by its ID
  Future<void> deleteMealPlan(String id);
}
