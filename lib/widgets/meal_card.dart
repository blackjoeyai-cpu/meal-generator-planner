import 'package:flutter/material.dart';
import 'package:meal_generator_planner/data/models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TODO: Replace with actual image asset
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Icon(Icons.image, color: Colors.grey, size: 40),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              meal.name,
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Icon(Icons.timer, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${meal.preparationTimeMinutes} min',
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.local_fire_department,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${meal.estimatedCalories} kcal',
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
