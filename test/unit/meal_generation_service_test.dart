import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/data/models/enums.dart';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';
import 'package:meal_generator_planner/data/repositories/meal_repository.dart';
import 'package:meal_generator_planner/features/meal_plan/domain/services/meal_generation_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'meal_generation_service_test.mocks.dart';

// Generate mocks for MealRepository
@GenerateMocks([MealRepository])
void main() {
  late MealGenerationService mealGenerationService;
  late MockMealRepository mockMealRepository;

  setUp(() {
    mockMealRepository = MockMealRepository();
    mealGenerationService = MealGenerationService(mockMealRepository);
  });

  // A dummy list of meals for testing
  final dummyMeals = List.generate(
    30,
    (i) => Meal(
      id: 'meal_$i',
      name: 'Meal $i',
      description: 'Description for meal $i',
      ingredients: [],
      category: i % 3 == 0
          ? MealCategory.breakfast
          : (i % 3 == 1 ? MealCategory.lunch : MealCategory.dinner),
      estimatedCalories: 300 + i * 10,
      preparationTimeMinutes: 15 + i,
      difficulty: DifficultyLevel.easy,
      dietaryTags: i % 5 == 0 ? [DietaryTag.vegetarian] : [],
      imageAssetPath: '',
      cookingInstructions: '',
      defaultServings: 2,
      createdAt: DateTime.now(),
    ),
  );

  test('generatePlan returns a valid 7-day meal plan', () async {
    // Arrange
    when(mockMealRepository.getAllMeals()).thenAnswer((_) async => dummyMeals);
    final request = MealPlanGenerationRequest(
      weekStartDate: DateTime.now(),
      numberOfPeople: 4,
    );

    // Act
    final mealPlan = await mealGenerationService.generatePlan(request);

    // Assert
    expect(mealPlan, isA<MealPlan>());
    expect(mealPlan.dailyMeals.length, 7);
    // Verify that each day has breakfast, lunch, and dinner
    for (final dailyMeal in mealPlan.dailyMeals.values) {
      expect(dailyMeal.breakfast, isNotNull);
      expect(dailyMeal.lunch, isNotNull);
      expect(dailyMeal.dinner, isNotNull);
    }
  });
}
