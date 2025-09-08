import 'package:meal_generator_planner/data/models/shopping_list.dart';
import 'package:meal_generator_planner/data/models/shopping_item.dart';

/// Abstract interface for shopping list data operations
abstract class ShoppingListRepository {
  /// Get all shopping lists
  Future<List<ShoppingList>> getAllShoppingLists();

  /// Get shopping list by ID
  Future<ShoppingList?> getShoppingListById(String id);

  /// Add a new shopping list
  Future<void> addShoppingList(ShoppingList shoppingList);

  /// Update an existing shopping list
  Future<void> updateShoppingList(ShoppingList shoppingList);

  /// Delete a shopping list
  Future<void> deleteShoppingList(String id);

  /// Add item to shopping list
  Future<void> addItemToShoppingList(String shoppingListId, ShoppingItem item);

  /// Update item in shopping list
  Future<void> updateItemInShoppingList(
    String shoppingListId,
    ShoppingItem item,
  );

  /// Remove item from shopping list
  Future<void> removeItemFromShoppingList(String shoppingListId, String itemId);

  /// Toggle item checked status
  Future<void> toggleItemChecked(String shoppingListId, String itemId);

  /// Get active shopping lists (not completed)
  Future<List<ShoppingList>> getActiveShoppingLists();
}
