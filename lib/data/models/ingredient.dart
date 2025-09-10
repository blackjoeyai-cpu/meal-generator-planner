import 'package:hive/hive.dart';
import 'package:meal_generator_planner/data/models/enums.dart';

part 'ingredient.g.dart';

@HiveType(typeId: 2)
class Ingredient extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double quantity;

  @HiveField(2)
  final String unit;

  @HiveField(3)
  final FoodCategory category;

  @HiveField(4)
  final bool isOptional;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    this.isOptional = false,
  });

  Ingredient copyWith({
    String? name,
    double? quantity,
    String? unit,
    FoodCategory? category,
    bool? isOptional,
  }) {
    return Ingredient(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      isOptional: isOptional ?? this.isOptional,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ingredient &&
        other.name == name &&
        other.quantity == quantity &&
        other.unit == unit &&
        other.category == category &&
        other.isOptional == isOptional;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      quantity.hashCode ^
      unit.hashCode ^
      category.hashCode ^
      isOptional.hashCode;

  @override
  String toString() {
    return 'Ingredient(name: $name, quantity: $quantity, unit: $unit)';
  }
}
