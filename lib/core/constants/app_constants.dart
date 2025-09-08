/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'Meal Generator Planner';
  static const String appVersion = '1.0.0';

  // Database constants
  static const String mealsBoxName = 'meals';
  static const String mealPlansBoxName = 'meal_plans';
  static const String shoppingListsBoxName = 'shopping_lists';
  static const String favoritesBoxName = 'favorites';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;

  // Animation durations
  static const int defaultAnimationDuration = 300;
  static const int fastAnimationDuration = 150;
  static const int slowAnimationDuration = 500;

  // Performance targets
  static const int mealGenerationTimeoutMs = 1000;
}
