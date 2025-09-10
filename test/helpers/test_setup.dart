import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:meal_generator_planner/data/models/daily_meals.dart';
import 'package:meal_generator_planner/data/models/enums.dart';
import 'package:meal_generator_planner/data/models/ingredient.dart';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';

Future<void> setUpHiveForTesting() async {
  final tempDir = await Directory.systemTemp.createTemp('hive_test');
  Hive.init(tempDir.path);

  // Register adapters if not already registered
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(MealAdapter());
    Hive.registerAdapter(IngredientAdapter());
    Hive.registerAdapter(DailyMealsAdapter());
    Hive.registerAdapter(MealPlanAdapter());
    Hive.registerAdapter(MealPlanGenerationRequestAdapter());
    Hive.registerAdapter(MealCategoryAdapter());
    Hive.registerAdapter(DifficultyLevelAdapter());
    Hive.registerAdapter(DietaryTagAdapter());
    Hive.registerAdapter(FoodCategoryAdapter());
  }
}
