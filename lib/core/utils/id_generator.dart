import 'package:uuid/uuid.dart';

/// UUID generation utilities
class IdGenerator {
  IdGenerator._();

  static const _uuid = Uuid();

  /// Generate a unique ID string
  static String generateId() {
    return _uuid.v4();
  }

  /// Generate a unique ID with a prefix
  static String generateIdWithPrefix(String prefix) {
    return '${prefix}_${generateId()}';
  }

  /// Generate meal ID
  static String generateMealId() {
    return generateIdWithPrefix('meal');
  }

  /// Generate meal plan ID
  static String generateMealPlanId() {
    return generateIdWithPrefix('plan');
  }

  /// Generate shopping list ID
  static String generateShoppingListId() {
    return generateIdWithPrefix('shopping');
  }

  /// Generate shopping item ID
  static String generateShoppingItemId() {
    return generateIdWithPrefix('item');
  }
}
