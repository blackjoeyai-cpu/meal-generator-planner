import 'package:hive/hive.dart';

/// Data model for a shopping list item
@HiveType(typeId: 2)
class ShoppingItem extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double quantity;

  @HiveField(2)
  final String unit;

  @HiveField(3)
  final bool isChecked;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String id;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    this.isChecked = false,
    this.category = 'Other',
  });

  /// Creates a copy of this shopping item with the given fields replaced with new values
  ShoppingItem copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
    bool? isChecked,
    String? category,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      isChecked: isChecked ?? this.isChecked,
      category: category ?? this.category,
    );
  }

  /// Toggle the checked status of this item
  ShoppingItem toggleChecked() {
    return copyWith(isChecked: !isChecked);
  }

  /// JSON serialization - to be implemented when code generation is set up
  // factory ShoppingItem.fromJson(Map<String, dynamic> json) => _$ShoppingItemFromJson(json);
  // Map<String, dynamic> toJson() => _$ShoppingItemToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoppingItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ShoppingItem(name: $name, quantity: $quantity $unit, category: $category, checked: $isChecked)';
  }
}
