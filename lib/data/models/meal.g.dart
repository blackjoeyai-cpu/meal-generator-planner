// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final int typeId = 0;

  @override
  Meal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meal(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      ingredients: (fields[3] as List).cast<Ingredient>(),
      category: fields[4] as MealCategory,
      estimatedCalories: fields[5] as int,
      preparationTimeMinutes: fields[6] as int,
      difficulty: fields[7] as DifficultyLevel,
      dietaryTags: (fields[8] as List).cast<DietaryTag>(),
      imageAssetPath: fields[9] as String,
      cookingInstructions: fields[10] as String,
      defaultServings: fields[11] as int,
      createdAt: fields[12] as DateTime,
      isFavorite: fields[13] as bool,
      isCustomUserMeal: fields[14] as bool,
      nutritionFacts: (fields[15] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.ingredients)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.estimatedCalories)
      ..writeByte(6)
      ..write(obj.preparationTimeMinutes)
      ..writeByte(7)
      ..write(obj.difficulty)
      ..writeByte(8)
      ..write(obj.dietaryTags)
      ..writeByte(9)
      ..write(obj.imageAssetPath)
      ..writeByte(10)
      ..write(obj.cookingInstructions)
      ..writeByte(11)
      ..write(obj.defaultServings)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.isFavorite)
      ..writeByte(14)
      ..write(obj.isCustomUserMeal)
      ..writeByte(15)
      ..write(obj.nutritionFacts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
