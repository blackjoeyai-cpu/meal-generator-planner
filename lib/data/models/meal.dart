import 'package:hive/hive.dart';

/// Data model for a meal
@HiveType(typeId: 0)
class Meal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> ingredients;

  @HiveField(3)
  final String category; // e.g. breakfast, lunch, dinner, snack

  @HiveField(4)
  final int calories;

  @HiveField(5)
  final String notes;

  @HiveField(6)
  final String? imageUrl;

  @HiveField(7)
  final int preparationTime; // in minutes

  @HiveField(8)
  final bool isFavorite;

  Meal({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.category,
    this.calories = 0,
    this.notes = '',
    this.imageUrl,
    this.preparationTime = 0,
    this.isFavorite = false,
  });

  /// Creates a copy of this meal with the given fields replaced with new values
  Meal copyWith({
    String? id,
    String? name,
    List<String>? ingredients,
    String? category,
    int? calories,
    String? notes,
    String? imageUrl,
    int? preparationTime,
    bool? isFavorite,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      category: category ?? this.category,
      calories: calories ?? this.calories,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      preparationTime: preparationTime ?? this.preparationTime,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// JSON serialization - to be implemented when code generation is set up
  // factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  // Map<String, dynamic> toJson() => _$MealToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Meal && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Meal(id: $id, name: $name, category: $category, calories: $calories)';
  }
}