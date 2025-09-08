import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meal_generator_planner/core/constants/app_constants.dart';
import 'package:meal_generator_planner/core/themes/app_theme.dart';
import 'package:meal_generator_planner/core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters will be added when generated
  // await Hive.openBox(AppConstants.mealsBoxName);
  // await Hive.openBox(AppConstants.mealPlansBoxName);
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
