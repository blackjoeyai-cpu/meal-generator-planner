import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_generator_planner/core/constants/routes.dart';
import 'package:meal_generator_planner/features/home/presentation/pages/home_page.dart';
import 'package:meal_generator_planner/features/meal_plan/presentation/pages/meal_plan_page.dart';
import 'package:meal_generator_planner/features/shopping_list/presentation/pages/shopping_list_page.dart';
import 'package:meal_generator_planner/features/favorites/presentation/pages/favorites_page.dart';

/// Application router configuration using GoRouter
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.home,
    routes: [
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RoutePaths.mealPlan,
        name: RouteNames.mealPlan,
        builder: (context, state) => const MealPlanPage(),
      ),
      GoRoute(
        path: RoutePaths.shoppingList,
        name: RouteNames.shoppingList,
        builder: (context, state) => const ShoppingListPage(),
      ),
      GoRoute(
        path: RoutePaths.favorites,
        name: RouteNames.favorites,
        builder: (context, state) => const FavoritesPage(),
      ),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
  );
}

/// Error page displayed when navigation fails
class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'The requested page could not be found.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
