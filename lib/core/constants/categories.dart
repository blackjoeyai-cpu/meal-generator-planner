import 'package:meal_generator_planner/core/enums/meal_category.dart';
import 'package:meal_generator_planner/core/enums/food_category.dart';

/// Meal categories used throughout the application
class MealCategories {
  MealCategories._();

  static const String breakfast = 'breakfast';
  static const String lunch = 'lunch';
  static const String dinner = 'dinner';
  static const String snack = 'snack';

  static const List<String> allCategories = [breakfast, lunch, dinner, snack];

  /// Get display name for a meal category
  static String getDisplayName(String category) {
    switch (category) {
      case breakfast:
        return 'Breakfast';
      case lunch:
        return 'Lunch';
      case dinner:
        return 'Dinner';
      case snack:
        return 'Snack';
      default:
        return category.toUpperCase();
    }
  }
  
  /// Convert MealCategory enum to string
  static String fromEnum(MealCategory category) {
    switch (category) {
      case MealCategory.breakfast:
        return breakfast;
      case MealCategory.lunch:
        return lunch;
      case MealCategory.dinner:
        return dinner;
      case MealCategory.snack:
        return snack;
    }
  }
  
  /// Convert string to MealCategory enum
  static MealCategory toEnum(String category) {
    switch (category) {
      case breakfast:
        return MealCategory.breakfast;
      case lunch:
        return MealCategory.lunch;
      case dinner:
        return MealCategory.dinner;
      case snack:
        return MealCategory.snack;
      default:
        return MealCategory.breakfast;
    }
  }
}

/// Food categories for shopping list organization
class FoodCategories {
  FoodCategories._();

  static const String vegetables = 'Vegetables';
  static const String fruits = 'Fruits';
  static const String meat = 'Meat & Poultry';
  static const String seafood = 'Seafood';
  static const String dairy = 'Dairy';
  static const String grains = 'Grains & Cereals';
  static const String spices = 'Spices & Seasonings';
  static const String beverages = 'Beverages';
  static const String other = 'Other';

  static const List<String> allCategories = [
    vegetables,
    fruits,
    meat,
    seafood,
    dairy,
    grains,
    spices,
    beverages,
    other,
  ];
  
  /// Convert FoodCategory enum to string
  static String fromEnum(FoodCategory category) {
    switch (category) {
      case FoodCategory.vegetables:
        return vegetables;
      case FoodCategory.fruits:
        return fruits;
      case FoodCategory.meat:
        return meat;
      case FoodCategory.seafood:
        return seafood;
      case FoodCategory.dairy:
        return dairy;
      case FoodCategory.grains:
        return grains;
      case FoodCategory.spices:
        return spices;
      case FoodCategory.beverages:
        return beverages;
      case FoodCategory.other:
        return other;
    }
  }
  
  /// Convert string to FoodCategory enum
  static FoodCategory toEnum(String category) {
    switch (category) {
      case vegetables:
        return FoodCategory.vegetables;
      case fruits:
        return FoodCategory.fruits;
      case meat:
        return FoodCategory.meat;
      case seafood:
        return FoodCategory.seafood;
      case dairy:
        return FoodCategory.dairy;
      case grains:
        return FoodCategory.grains;
      case spices:
        return FoodCategory.spices;
      case beverages:
        return FoodCategory.beverages;
      case other:
        return FoodCategory.other;
      default:
        return FoodCategory.other;
    }
  }
}