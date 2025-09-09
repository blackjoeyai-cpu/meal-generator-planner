import 'package:hive/hive.dart';
import 'package:meal_generator_planner/data/models/meal.dart';

/// Data structure for encapsulating generation parameters
@HiveType(typeId: 4)
class MealPlanGenerationRequest extends HiveObject {
  @HiveField(0)
  final DateTime weekStartDate; // Starting date for the meal plan (default: current week Monday)

  @HiveField(1)
  final int numberOfPeople; // Number of people to plan for (range: 1-10, default: 4)

  @HiveField(2)
  final List<DietaryTag> restrictions; // List of dietary restrictions to apply

  @HiveField(3)
  final List<String> excludedIngredients; // List of ingredients to exclude (allergens/dislikes)

  @HiveField(4)
  final List<String> previousWeekMealIds; // Meal IDs from previous week to avoid repetition

  @HiveField(5)
  final bool includeFavorites; // Flag to prioritize favorite meals

  @HiveField(6)
  final List<String> pinnedFavoriteIds; // Specific favorite meals that must be included

  MealPlanGenerationRequest({
    required this.weekStartDate,
    this.numberOfPeople = 4,
    this.restrictions = const [],
    this.excludedIngredients = const [],
    this.previousWeekMealIds = const [],
    this.includeFavorites = true,
    this.pinnedFavoriteIds = const [],
  });

  /// Creates a copy of this request with the given fields replaced with new values
  MealPlanGenerationRequest copyWith({
    DateTime? weekStartDate,
    int? numberOfPeople,
    List<DietaryTag>? restrictions,
    List<String>? excludedIngredients,
    List<String>? previousWeekMealIds,
    bool? includeFavorites,
    List<String>? pinnedFavoriteIds,
  }) {
    return MealPlanGenerationRequest(
      weekStartDate: weekStartDate ?? this.weekStartDate,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      restrictions: restrictions ?? this.restrictions,
      excludedIngredients: excludedIngredients ?? this.excludedIngredients,
      previousWeekMealIds: previousWeekMealIds ?? this.previousWeekMealIds,
      includeFavorites: includeFavorites ?? this.includeFavorites,
      pinnedFavoriteIds: pinnedFavoriteIds ?? this.pinnedFavoriteIds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MealPlanGenerationRequest &&
        other.weekStartDate == weekStartDate &&
        other.numberOfPeople == numberOfPeople &&
        other.restrictions == restrictions &&
        other.excludedIngredients == excludedIngredients &&
        other.previousWeekMealIds == previousWeekMealIds &&
        other.includeFavorites == includeFavorites &&
        other.pinnedFavoriteIds == pinnedFavoriteIds;
  }

  @override
  int get hashCode => Object.hash(
        weekStartDate,
        numberOfPeople,
        restrictions,
        excludedIngredients,
        previousWeekMealIds,
        includeFavorites,
        pinnedFavoriteIds,
      );

  @override
  String toString() {
    return 'MealPlanGenerationRequest(weekStartDate: $weekStartDate, numberOfPeople: $numberOfPeople, includeFavorites: $includeFavorites)';
  }
}