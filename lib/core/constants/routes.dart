/// Route paths used by GoRouter
class RoutePaths {
  RoutePaths._();

  // Main routes
  static const String home = '/';
  static const String mealPlan = '/meal-plan';
  static const String shoppingList = '/shopping-list';
  static const String favorites = '/favorites';

  // Sub-routes
  static const String generateMealPlan = '/generate-meal-plan';
  static const String editMealPlan = '/edit-meal-plan';
  static const String mealDetails = '/meal-details';
  static const String createCustomMeal = '/create-custom-meal';
  static const String shoppingListDetails = '/shopping-list-details';

  // Settings and help
  static const String settings = '/settings';
  static const String about = '/about';
}

/// Route names for named navigation
class RouteNames {
  RouteNames._();

  static const String home = 'home';
  static const String mealPlan = 'meal-plan';
  static const String shoppingList = 'shopping-list';
  static const String favorites = 'favorites';
  static const String generateMealPlan = 'generate-meal-plan';
  static const String editMealPlan = 'edit-meal-plan';
  static const String mealDetails = 'meal-details';
  static const String createCustomMeal = 'create-custom-meal';
  static const String shoppingListDetails = 'shopping-list-details';
  static const String settings = 'settings';
  static const String about = 'about';
}
