// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealPlanGenerationRequestAdapter
    extends TypeAdapter<MealPlanGenerationRequest> {
  @override
  final int typeId = 4;

  @override
  MealPlanGenerationRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealPlanGenerationRequest(
      weekStartDate: fields[0] as DateTime,
      numberOfPeople: fields[1] as int,
      restrictions: (fields[2] as List).cast<DietaryTag>(),
      excludedIngredients: (fields[3] as List).cast<String>(),
      includeFavorites: fields[4] as bool,
      pinnedFavoriteIds: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MealPlanGenerationRequest obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.weekStartDate)
      ..writeByte(1)
      ..write(obj.numberOfPeople)
      ..writeByte(2)
      ..write(obj.restrictions)
      ..writeByte(3)
      ..write(obj.excludedIngredients)
      ..writeByte(4)
      ..write(obj.includeFavorites)
      ..writeByte(5)
      ..write(obj.pinnedFavoriteIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealPlanGenerationRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealPlanAdapter extends TypeAdapter<MealPlan> {
  @override
  final int typeId = 1;

  @override
  MealPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealPlan(
      id: fields[0] as String,
      weekStartDate: fields[1] as DateTime,
      dailyMeals: (fields[2] as Map).cast<String, DailyMeals>(),
      generatedAt: fields[3] as DateTime,
      generationParameters: fields[5] as MealPlanGenerationRequest,
      isActive: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MealPlan obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.weekStartDate)
      ..writeByte(2)
      ..write(obj.dailyMeals)
      ..writeByte(3)
      ..write(obj.generatedAt)
      ..writeByte(4)
      ..write(obj.isActive)
      ..writeByte(5)
      ..write(obj.generationParameters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
