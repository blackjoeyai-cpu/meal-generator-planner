// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealCategoryAdapter extends TypeAdapter<MealCategory> {
  @override
  final int typeId = 10;

  @override
  MealCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MealCategory.breakfast;
      case 1:
        return MealCategory.lunch;
      case 2:
        return MealCategory.dinner;
      case 3:
        return MealCategory.snack;
      default:
        return MealCategory.breakfast;
    }
  }

  @override
  void write(BinaryWriter writer, MealCategory obj) {
    switch (obj) {
      case MealCategory.breakfast:
        writer.writeByte(0);
        break;
      case MealCategory.lunch:
        writer.writeByte(1);
        break;
      case MealCategory.dinner:
        writer.writeByte(2);
        break;
      case MealCategory.snack:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DifficultyLevelAdapter extends TypeAdapter<DifficultyLevel> {
  @override
  final int typeId = 11;

  @override
  DifficultyLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DifficultyLevel.easy;
      case 1:
        return DifficultyLevel.medium;
      case 2:
        return DifficultyLevel.hard;
      default:
        return DifficultyLevel.easy;
    }
  }

  @override
  void write(BinaryWriter writer, DifficultyLevel obj) {
    switch (obj) {
      case DifficultyLevel.easy:
        writer.writeByte(0);
        break;
      case DifficultyLevel.medium:
        writer.writeByte(1);
        break;
      case DifficultyLevel.hard:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DifficultyLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DietaryTagAdapter extends TypeAdapter<DietaryTag> {
  @override
  final int typeId = 12;

  @override
  DietaryTag read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DietaryTag.vegetarian;
      case 1:
        return DietaryTag.vegan;
      case 2:
        return DietaryTag.glutenFree;
      case 3:
        return DietaryTag.dairyFree;
      case 4:
        return DietaryTag.nutFree;
      case 5:
        return DietaryTag.lowCarb;
      default:
        return DietaryTag.vegetarian;
    }
  }

  @override
  void write(BinaryWriter writer, DietaryTag obj) {
    switch (obj) {
      case DietaryTag.vegetarian:
        writer.writeByte(0);
        break;
      case DietaryTag.vegan:
        writer.writeByte(1);
        break;
      case DietaryTag.glutenFree:
        writer.writeByte(2);
        break;
      case DietaryTag.dairyFree:
        writer.writeByte(3);
        break;
      case DietaryTag.nutFree:
        writer.writeByte(4);
        break;
      case DietaryTag.lowCarb:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietaryTagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FoodCategoryAdapter extends TypeAdapter<FoodCategory> {
  @override
  final int typeId = 13;

  @override
  FoodCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FoodCategory.produce;
      case 1:
        return FoodCategory.meat;
      case 2:
        return FoodCategory.dairy;
      case 3:
        return FoodCategory.pantry;
      case 4:
        return FoodCategory.frozen;
      case 5:
        return FoodCategory.bakery;
      default:
        return FoodCategory.produce;
    }
  }

  @override
  void write(BinaryWriter writer, FoodCategory obj) {
    switch (obj) {
      case FoodCategory.produce:
        writer.writeByte(0);
        break;
      case FoodCategory.meat:
        writer.writeByte(1);
        break;
      case FoodCategory.dairy:
        writer.writeByte(2);
        break;
      case FoodCategory.pantry:
        writer.writeByte(3);
        break;
      case FoodCategory.frozen:
        writer.writeByte(4);
        break;
      case FoodCategory.bakery:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
