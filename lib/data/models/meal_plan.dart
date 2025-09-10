import 'package:hive/hive.dart';
import 'package:meal_generator_planner/data/models/daily_meals.dart';
import 'package:meal_generator_planner/data/models/enums.dart';

part 'meal_plan.g.dart';

@HiveType(typeId: 4)
class MealPlanGenerationRequest extends HiveObject {
  @HiveField(0)
  final DateTime weekStartDate;

  @HiveField(1)
  final int numberOfPeople;

  @HiveField(2)
  final List<DietaryTag> restrictions;

  @HiveField(3)
  final List<String> excludedIngredients;

  @HiveField(4)
  final bool includeFavorites;

  @HiveField(5)
  final List<String> pinnedFavoriteIds;

  MealPlanGenerationRequest({
    required this.weekStartDate,
    required this.numberOfPeople,
    this.restrictions = const [],
    this.excludedIngredients = const [],
    this.includeFavorites = true,
    this.pinnedFavoriteIds = const [],
  });
}

@HiveType(typeId: 1)
class MealPlan extends HiveObject {
  @HiveField(0)
  final String id; // Format: "2024-W01"

  @HiveField(1)
  final DateTime weekStartDate;

  @HiveField(2)
  final Map<String, DailyMeals> dailyMeals; // Key: ISO 8601 date string

  @HiveField(3)
  final DateTime generatedAt;

  @HiveField(4)
  final bool isActive;

  @HiveField(5)
  final MealPlanGenerationRequest generationParameters;

  MealPlan({
    required this.id,
    required this.weekStartDate,
    required this.dailyMeals,
    required this.generatedAt,
    required this.generationParameters,
    this.isActive = false,
  });

  MealPlan copyWith({
    String? id,
    DateTime? weekStartDate,
    Map<String, DailyMeals>? dailyMeals,
    DateTime? generatedAt,
    bool? isActive,
    MealPlanGenerationRequest? generationParameters,
  }) {
    return MealPlan(
      id: id ?? this.id,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      dailyMeals: dailyMeals ?? this.dailyMeals,
      generatedAt: generatedAt ?? this.generatedAt,
      isActive: isActive ?? this.isActive,
      generationParameters: generationParameters ?? this.generationParameters,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MealPlan && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MealPlan(id: $id, weekStartDate: $weekStartDate)';
  }
}
