import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_generator_planner/data/repositories/hive_meal_repository.dart';
import 'package:meal_generator_planner/data/repositories/hive_meal_plan_repository.dart';
import 'package:meal_generator_planner/data/repositories/meal_repository.dart';
import 'package:meal_generator_planner/data/repositories/meal_plan_repository.dart';

final mealRepositoryProvider = FutureProvider<MealRepository>((ref) async {
  return await HiveMealRepository.create();
});

final mealPlanRepositoryProvider = FutureProvider<MealPlanRepository>((
  ref,
) async {
  return await HiveMealPlanRepository.create();
});
