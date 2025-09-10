import 'package:hive/hive.dart';
import 'package:meal_generator_planner/data/models/enums.dart';
import 'package:meal_generator_planner/data/models/ingredient.dart';

part 'meal.g.dart';

@HiveType(typeId: 0)
class Meal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<Ingredient> ingredients;

  @HiveField(4)
  final MealCategory category;

  @HiveField(5)
  final int estimatedCalories;

  @HiveField(6)
  final int preparationTimeMinutes;

  @HiveField(7)
  final DifficultyLevel difficulty;

  @HiveField(8)
  final List<DietaryTag> dietaryTags;

  @HiveField(9)
  final String imageAssetPath;

  @HiveField(10)
  final String cookingInstructions;

  @HiveField(11)
  final int defaultServings;

  @HiveField(12)
  final DateTime createdAt;

  @HiveField(13)
  final bool isFavorite;

  @HiveField(14)
  final bool isCustomUserMeal;

  @HiveField(15)
  final Map<String, String> nutritionFacts;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.category,
    required this.estimatedCalories,
    required this.preparationTimeMinutes,
    required this.difficulty,
    required this.dietaryTags,
    required this.imageAssetPath,
    required this.cookingInstructions,
    required this.defaultServings,
    required this.createdAt,
    this.isFavorite = false,
    this.isCustomUserMeal = false,
    this.nutritionFacts = const {},
  });

  Meal copyWith({
    String? id,
    String? name,
    String? description,
    List<Ingredient>? ingredients,
    MealCategory? category,
    int? estimatedCalories,
    int? preparationTimeMinutes,
    DifficultyLevel? difficulty,
    List<DietaryTag>? dietaryTags,
    String? imageAssetPath,
    String? cookingInstructions,
    int? defaultServings,
    DateTime? createdAt,
    bool? isFavorite,
    bool? isCustomUserMeal,
    Map<String, String>? nutritionFacts,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      category: category ?? this.category,
      estimatedCalories: estimatedCalories ?? this.estimatedCalories,
      preparationTimeMinutes:
          preparationTimeMinutes ?? this.preparationTimeMinutes,
      difficulty: difficulty ?? this.difficulty,
      dietaryTags: dietaryTags ?? this.dietaryTags,
      imageAssetPath: imageAssetPath ?? this.imageAssetPath,
      cookingInstructions: cookingInstructions ?? this.cookingInstructions,
      defaultServings: defaultServings ?? this.defaultServings,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isCustomUserMeal: isCustomUserMeal ?? this.isCustomUserMeal,
      nutritionFacts: nutritionFacts ?? this.nutritionFacts,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Meal && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Meal(id: $id, name: $name, category: $category)';
  }
}
