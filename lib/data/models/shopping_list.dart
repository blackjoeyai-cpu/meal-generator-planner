import 'package:hive/hive.dart';
import 'package:meal_generator_planner/data/models/shopping_item.dart';

/// Data model for a shopping list
@HiveType(typeId: 3)
class ShoppingList extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<ShoppingItem> items;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime? updatedAt;

  @HiveField(5)
  final bool isCompleted;

  ShoppingList({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
    this.updatedAt,
    this.isCompleted = false,
  });

  /// Creates a copy of this shopping list with the given fields replaced with new values
  ShoppingList copyWith({
    String? id,
    String? name,
    List<ShoppingItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCompleted,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Get items grouped by category
  Map<String, List<ShoppingItem>> get itemsByCategory {
    final Map<String, List<ShoppingItem>> grouped = {};
    for (final item in items) {
      if (grouped.containsKey(item.category)) {
        grouped[item.category]!.add(item);
      } else {
        grouped[item.category] = [item];
      }
    }
    return grouped;
  }

  /// Get the number of checked items
  int get checkedItemsCount {
    return items.where((item) => item.isChecked).length;
  }

  /// Get the total number of items
  int get totalItemsCount {
    return items.length;
  }

  /// Get completion percentage
  double get completionPercentage {
    if (totalItemsCount == 0) return 0.0;
    return checkedItemsCount / totalItemsCount;
  }

  /// Check if all items are checked
  bool get isFullyCompleted {
    return totalItemsCount > 0 && checkedItemsCount == totalItemsCount;
  }

  /// JSON serialization - to be implemented when code generation is set up
  // factory ShoppingList.fromJson(Map<String, dynamic> json) => _$ShoppingListFromJson(json);
  // Map<String, dynamic> toJson() => _$ShoppingListToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoppingList && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ShoppingList(name: $name, items: ${items.length}, completion: ${(completionPercentage * 100).toStringAsFixed(1)}%)';
  }
}