import 'package:meal_generator_planner/data/models/meal_plan.dart';

/// Abstract interface for meal plan data operations
abstract class MealPlanRepository {
  /// Get all meal plans
  Future<List<MealPlan>> getAllMealPlans();

  /// Get meal plan by date
  Future<MealPlan?> getMealPlanByDate(DateTime date);

  /// Get meal plans for a date range
  Future<List<MealPlan>> getMealPlansInRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Add a new meal plan
  Future<void> addMealPlan(MealPlan mealPlan);

  /// Update an existing meal plan
  Future<void> updateMealPlan(MealPlan mealPlan);

  /// Delete a meal plan
  Future<void> deleteMealPlan(String id);

  /// Get meal plans for current week
  Future<List<MealPlan>> getCurrentWeekMealPlans();

  /// Check if meal plan exists for date
  Future<bool> hasMealPlanForDate(DateTime date);
}
