import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:meal_generator_planner/data/models/enums.dart';
import 'package:meal_generator_planner/data/models/ingredient.dart';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/repositories/meal_repository.dart';

class HiveMealRepository implements MealRepository {
  final Box<Meal> _box;

  HiveMealRepository(this._box);

  static Future<HiveMealRepository> create() async {
    final box = await Hive.openBox<Meal>('meals');
    final repo = HiveMealRepository(box);
    await repo._init();
    return repo;
  }

  Future<void> _init() async {
    if (_box.isEmpty) {
      final jsonString = await rootBundle.loadString('assets/data/meals.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final meals = jsonList.map((json) => _mealFromJson(json)).toList();
      for (final meal in meals) {
        await _box.put(meal.id, meal);
      }

      if (_box.isEmpty) {
        throw Exception('Failed to load meals into the Hive box.');
      }
    }
  }

  @override
  Future<void> deleteMeal(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<Meal>> getAllMeals() async {
    return _box.values.toList();
  }

  @override
  Future<List<Meal>> getFavoriteMeals() async {
    return _box.values.where((meal) => meal.isFavorite).toList();
  }

  @override
  Future<Meal?> getMealById(String id) async {
    return _box.get(id);
  }

  @override
  Future<List<Meal>> getMealsByCategory(MealCategory category) async {
    return _box.values.where((meal) => meal.category == category).toList();
  }

  @override
  Future<void> saveMeal(Meal meal) async {
    await _box.put(meal.id, meal);
  }

  @override
  Future<List<Meal>> searchMeals(String query) async {
    final lowerCaseQuery = query.toLowerCase();
    return _box.values
        .where((meal) =>
            meal.name.toLowerCase().contains(lowerCaseQuery) ||
            meal.ingredients.any((ingredient) =>
                ingredient.name.toLowerCase().contains(lowerCaseQuery)))
        .toList();
  }

  @override
  Future<void> toggleMealFavorite(String mealId) async {
    final meal = await getMealById(mealId);
    if (meal != null) {
      final updatedMeal = meal.copyWith(isFavorite: !meal.isFavorite);
      await saveMeal(updatedMeal);
    }
  }

  Meal _mealFromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      ingredients: (json['ingredients'] as List)
          .map((i) => _ingredientFromJson(i))
          .toList(),
      category: MealCategory.values
          .firstWhere((e) => e.toString() == 'MealCategory.${json['category']}'),
      estimatedCalories: json['estimatedCalories'],
      preparationTimeMinutes: json['preparationTimeMinutes'],
      difficulty: DifficultyLevel.values.firstWhere(
          (e) => e.toString() == 'DifficultyLevel.${json['difficulty']}'),
      dietaryTags: (json['dietaryTags'] as List)
          .map((t) => DietaryTag.values
              .firstWhere((e) => e.toString() == 'DietaryTag.$t'))
          .toList(),
      imageAssetPath: json['imageAssetPath'],
      cookingInstructions: json['cookingInstructions'],
      defaultServings: json['defaultServings'],
      createdAt: DateTime.now(), // Set creation date on import
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Ingredient _ingredientFromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'],
      category: FoodCategory.values
          .firstWhere((e) => e.toString() == 'FoodCategory.${json['category']}'),
      isOptional: json['isOptional'] ?? false,
    );
  }
}
