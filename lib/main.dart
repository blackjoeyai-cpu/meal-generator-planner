import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meal_generator_planner/core/constants/app_constants.dart';
import 'package:meal_generator_planner/core/themes/app_theme.dart';
import 'package:meal_generator_planner/core/router/app_router.dart';
import 'package:meal_generator_planner/data/models/daily_meals.dart';
import 'package:meal_generator_planner/data/models/enums.dart';
import 'package:meal_generator_planner/data/models/ingredient.dart';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(MealAdapter());
  Hive.registerAdapter(IngredientAdapter());
  Hive.registerAdapter(DailyMealsAdapter());
  Hive.registerAdapter(MealPlanAdapter());
  Hive.registerAdapter(MealPlanGenerationRequestAdapter());
  Hive.registerAdapter(MealCategoryAdapter());
  Hive.registerAdapter(DifficultyLevelAdapter());
  Hive.registerAdapter(DietaryTagAdapter());
  Hive.registerAdapter(FoodCategoryAdapter());

  // Open boxes
  await Hive.openBox<Meal>(AppConstants.mealsBoxName);
  await Hive.openBox<MealPlan>(AppConstants.mealPlansBoxName);
  // await Hive.openBox(AppConstants.shoppingListsBoxName);
  // await Hive.openBox(AppConstants.favoritesBoxName);

  runApp(const ProviderScope(child: MealGeneratorApp()));
}

class MealGeneratorApp extends StatelessWidget {
  const MealGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
