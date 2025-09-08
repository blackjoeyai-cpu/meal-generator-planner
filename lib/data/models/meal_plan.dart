import 'package:hive/hive.dart';
import 'package:meal_generator_planner/data/models/meal.dart';

/// Data model for a daily meal plan
@HiveType(typeId: 1)
class MealPlan extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final Meal? breakfast;

  @HiveField(2)
  final Meal? lunch;

  @HiveField(3)
  final Meal? dinner;

  @HiveField(4)
  final List<Meal> snacks;

  @HiveField(5)
  final String id;

  MealPlan({
    required this.id,
    required this.date,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snacks = const [],
  });

  /// Creates a copy of this meal plan with the given fields replaced with new values
  MealPlan copyWith({
    String? id,
    DateTime? date,
    Meal? breakfast,
    Meal? lunch,
    Meal? dinner,
    List<Meal>? snacks,
  }) {
    return MealPlan(
      id: id ?? this.id,
      date: date ?? this.date,
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
      snacks: snacks ?? this.snacks,
    );
  }

  /// Get all meals in this plan (non-null meals + snacks)
  List<Meal> get allMeals {
    final meals = <Meal>[];
    if (breakfast != null) meals.add(breakfast!);
    if (lunch != null) meals.add(lunch!);
    if (dinner != null) meals.add(dinner!);
    meals.addAll(snacks);
    return meals;
  }

  /// Calculate total calories for the day
  int get totalCalories {
    return allMeals.fold(0, (sum, meal) => sum + meal.calories);
  }

  /// Check if the meal plan is complete (has all main meals)
  bool get isComplete {
    return breakfast != null && lunch != null && dinner != null;
  }

  /// JSON serialization - to be implemented when code generation is set up
  // factory MealPlan.fromJson(Map<String, dynamic> json) => _$MealPlanFromJson(json);
  // Map<String, dynamic> toJson() => _$MealPlanToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MealPlan && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MealPlan(id: $id, date: $date, totalCalories: $totalCalories)';
  }
}