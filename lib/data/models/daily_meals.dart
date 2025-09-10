import 'package:hive/hive.dart';
import 'package:meal_generator_planner/data/models/meal.dart';

part 'daily_meals.g.dart';

@HiveType(typeId: 3)
class DailyMeals extends HiveObject {
  @HiveField(0)
  final Meal breakfast;

  @HiveField(1)
  final Meal lunch;

  @HiveField(2)
  final Meal dinner;

  @HiveField(3)
  final List<Meal> snacks;

  DailyMeals({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    this.snacks = const [],
  });

  DailyMeals copyWith({
    Meal? breakfast,
    Meal? lunch,
    Meal? dinner,
    List<Meal>? snacks,
  }) {
    return DailyMeals(
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
      snacks: snacks ?? this.snacks,
    );
  }
}
