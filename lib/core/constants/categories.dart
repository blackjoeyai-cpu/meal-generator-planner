/// Meal categories used throughout the application
class MealCategories {
  MealCategories._();

  static const String breakfast = 'breakfast';
  static const String lunch = 'lunch';
  static const String dinner = 'dinner';
  static const String snack = 'snack';

  static const List<String> allCategories = [
    breakfast,
    lunch,
    dinner,
    snack,
  ];

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
}