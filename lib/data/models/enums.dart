import 'package:hive/hive.dart';

part 'enums.g.dart';

@HiveType(typeId: 10)
enum MealCategory {
  @HiveField(0)
  breakfast,

  @HiveField(1)
  lunch,

  @HiveField(2)
  dinner,

  @HiveField(3)
  snack,
}

@HiveType(typeId: 11)
enum DifficultyLevel {
  @HiveField(0)
  easy,

  @HiveField(1)
  medium,

  @HiveField(2)
  hard,
}

@HiveType(typeId: 12)
enum DietaryTag {
  @HiveField(0)
  vegetarian,

  @HiveField(1)
  vegan,

  @HiveField(2)
  glutenFree,

  @HiveField(3)
  dairyFree,

  @HiveField(4)
  nutFree,

  @HiveField(5)
  lowCarb,
}

@HiveType(typeId: 13)
enum FoodCategory {
  @HiveField(0)
  produce,

  @HiveField(1)
  meat,

  @HiveField(2)
  dairy,

  @HiveField(3)
  pantry,

  @HiveField(4)
  frozen,

  @HiveField(5)
  bakery,
}
