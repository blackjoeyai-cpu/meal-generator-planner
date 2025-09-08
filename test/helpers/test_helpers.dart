import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';
import 'package:meal_generator_planner/data/models/shopping_item.dart';
import 'package:meal_generator_planner/data/models/shopping_list.dart';
import 'package:meal_generator_planner/core/utils/id_generator.dart';

/// Test helper functions for creating mock data
class TestHelpers {
  TestHelpers._();

  /// Create a test meal with default or custom values
  static Meal createTestMeal({
    String? id,
    String name = 'Test Meal',
    List<String> ingredients = const ['ingredient1', 'ingredient2'],
    String category = 'lunch',
    int calories = 300,
    String notes = 'Test notes',
    int preparationTime = 30,
    bool isFavorite = false,
  }) {
    return Meal(
      id: id ?? IdGenerator.generateMealId(),
      name: name,
      ingredients: ingredients,
      category: category,
      calories: calories,
      notes: notes,
      preparationTime: preparationTime,
      isFavorite: isFavorite,
    );
  }

  /// Create a test meal plan with default or custom values
  static MealPlan createTestMealPlan({
    String? id,
    DateTime? date,
    Meal? breakfast,
    Meal? lunch,
    Meal? dinner,
    List<Meal> snacks = const [],
  }) {
    return MealPlan(
      id: id ?? IdGenerator.generateMealPlanId(),
      date: date ?? DateTime.now(),
      breakfast: breakfast,
      lunch: lunch,
      dinner: dinner,
      snacks: snacks,
    );
  }

  /// Create a test shopping item with default or custom values
  static ShoppingItem createTestShoppingItem({
    String? id,
    String name = 'Test Item',
    double quantity = 1.0,
    String unit = 'piece',
    bool isChecked = false,
    String category = 'Other',
  }) {
    return ShoppingItem(
      id: id ?? IdGenerator.generateShoppingItemId(),
      name: name,
      quantity: quantity,
      unit: unit,
      isChecked: isChecked,
      category: category,
    );
  }

  /// Create a test shopping list with default or custom values
  static ShoppingList createTestShoppingList({
    String? id,
    String name = 'Test Shopping List',
    List<ShoppingItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isCompleted = false,
  }) {
    return ShoppingList(
      id: id ?? IdGenerator.generateShoppingListId(),
      name: name,
      items: items ?? [createTestShoppingItem()],
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt,
      isCompleted: isCompleted,
    );
  }

  /// Create a list of test meals for various categories
  static List<Meal> createTestMeals() {
    return [
      createTestMeal(
        name: 'Oatmeal',
        category: 'breakfast',
        calories: 250,
        ingredients: ['oats', 'milk', 'honey'],
      ),
      createTestMeal(
        name: 'Grilled Chicken Salad',
        category: 'lunch',
        calories: 400,
        ingredients: ['chicken', 'lettuce', 'tomatoes', 'dressing'],
      ),
      createTestMeal(
        name: 'Spaghetti Bolognese',
        category: 'dinner',
        calories: 600,
        ingredients: ['pasta', 'ground beef', 'tomato sauce', 'parmesan'],
      ),
      createTestMeal(
        name: 'Apple',
        category: 'snack',
        calories: 80,
        ingredients: ['apple'],
      ),
    ];
  }

  /// Create a complete test meal plan with all meals
  static MealPlan createCompleteMealPlan() {
    final meals = createTestMeals();
    return createTestMealPlan(
      breakfast: meals.firstWhere((m) => m.category == 'breakfast'),
      lunch: meals.firstWhere((m) => m.category == 'lunch'),
      dinner: meals.firstWhere((m) => m.category == 'dinner'),
      snacks: meals.where((m) => m.category == 'snack').toList(),
    );
  }
}