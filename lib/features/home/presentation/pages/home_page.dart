import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_generator_planner/core/constants/routes.dart';

/// Home dashboard page - main entry point of the application
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Generator Planner'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant_menu,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Meal Generator Planner',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Generate and customize meal plans effortlessly',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _NavigationCard(
              title: 'Meal Plan',
              description: 'Create and manage weekly meal plans',
              icon: Icons.calendar_today,
              onTap: () => context.go(RoutePaths.mealPlan),
            ),
            const SizedBox(height: 16),
            _NavigationCard(
              title: 'Shopping List',
              description: 'Generate shopping lists from meal plans',
              icon: Icons.shopping_cart,
              onTap: () => context.go(RoutePaths.shoppingList),
            ),
            const SizedBox(height: 16),
            _NavigationCard(
              title: 'Favorites',
              description: 'Manage your favorite meals',
              icon: Icons.favorite,
              onTap: () => context.go(RoutePaths.favorites),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  const _NavigationCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}