import 'package:flutter/material.dart';
import 'package:meal_generator_planner/data/models/meal.dart';

/// Card widget to display meal information
class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.meal,
    this.onTap,
    this.onFavoriteToggle,
    this.showFavoriteButton = true,
  });

  final Meal meal;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool showFavoriteButton;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      meal.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (showFavoriteButton)
                    IconButton(
                      icon: Icon(
                        meal.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: meal.isFavorite ? Colors.red : null,
                      ),
                      onPressed: onFavoriteToggle,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(
                    label: Text(meal.category),
                    backgroundColor: _getCategoryColor(meal.category),
                  ),
                  const SizedBox(width: 8),
                  if (meal.calories > 0)
                    Chip(
                      label: Text('${meal.calories} cal'),
                      backgroundColor: Colors.orange.withValues(alpha: 0.2),
                    ),
                ],
              ),
              if (meal.preparationTime > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${meal.preparationTime} min',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
              if (meal.ingredients.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Ingredients: ${meal.ingredients.take(3).join(', ')}${meal.ingredients.length > 3 ? '...' : ''}',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return Colors.yellow.withValues(alpha: 0.2);
      case 'lunch':
        return Colors.green.withValues(alpha: 0.2);
      case 'dinner':
        return Colors.blue.withValues(alpha: 0.2);
      case 'snack':
        return Colors.purple.withValues(alpha: 0.2);
      default:
        return Colors.grey.withValues(alpha: 0.2);
    }
  }
}