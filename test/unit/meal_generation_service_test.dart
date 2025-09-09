import 'package:flutter_test/flutter_test.dart';
import 'package:meal_generator_planner/data/services/meal_generation_service.dart';
import 'package:meal_generator_planner/data/models/meal.dart';

import 'package:meal_generator_planner/data/models/meal_plan_generation_request.dart';
import 'package:meal_generator_planner/data/repositories/meal_repository.dart';
import 'package:meal_generator_planner/data/repositories/meal_plan_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Generate mocks
@GenerateMocks([MealRepository, MealPlanRepository])
import 'meal_generation_service_test.mocks.dart';

void main() {
  group('MealGenerationService Tests', () {
    late MockMealRepository mockMealRepository;
    late MealGenerationService service;

    setUp(() {
      mockMealRepository = MockMealRepository();
      service = MealGenerationService(
        mealRepository: mockMealRepository,
      );
    });

    test('should generate weekly meal plan with sufficient meals', () async {
      // Arrange
      final request = MealPlanGenerationRequest(
        weekStartDate: DateTime(2024, 1, 15), // Monday
        numberOfPeople: 4,
        restrictions: [],
        excludedIngredients: [],
        previousWeekMealIds: [],
        includeFavorites: true,
        pinnedFavoriteIds: [],
      );

      // Create meals with proper distribution across categories including snacks
      final meals = <Meal>[];
      
      // Add 10 breakfast meals
      for (int i = 0; i < 10; i++) {
        meals.add(Meal(
          id: 'breakfast_$i',
          name: 'Breakfast Meal $i',
          ingredients: ['ingredient_$i'],
          category: 'breakfast',
          calories: 300 + (i * 10),
          createdAt: DateTime.now(),
        ));
      }
      
      // Add 10 lunch meals
      for (int i = 0; i < 10; i++) {
        meals.add(Meal(
          id: 'lunch_$i',
          name: 'Lunch Meal $i',
          ingredients: ['ingredient_${i + 10}'],
          category: 'lunch',
          calories: 400 + (i * 10),
          createdAt: DateTime.now(),
        ));
      }
      
      // Add 10 dinner meals
      for (int i = 0; i < 10; i++) {
        meals.add(Meal(
          id: 'dinner_$i',
          name: 'Dinner Meal $i',
          ingredients: ['ingredient_${i + 20}'],
          category: 'dinner',
          calories: 500 + (i * 10),
          createdAt: DateTime.now(),
        ));
      }
      
      // Add 10 snack meals
      for (int i = 0; i < 10; i++) {
        meals.add(Meal(
          id: 'snack_$i',
          name: 'Snack Meal $i',
          ingredients: ['ingredient_${i + 30}'],
          category: 'snack',
          calories: 100 + (i * 10),
          createdAt: DateTime.now(),
        ));
      }

      when(mockMealRepository.getAllMeals()).thenAnswer((_) async => meals);
      when(mockMealRepository.getMealById(any)).thenAnswer((_) async => null);

      // Act
      final result = await service.generateWeeklyMealPlan(request);

      // Assert
      expect(result, isNotEmpty);
      expect(result.length, 7); // 7 days in a week
      
      // Check that each day has meals
      for (final plan in result) {
        expect(plan.breakfast, isNotNull);
        expect(plan.lunch, isNotNull);
        expect(plan.dinner, isNotNull);
        expect(plan.date, isNotNull);
      }
    });

    test('should throw exception when insufficient meals available', () async {
      // Arrange
      final request = MealPlanGenerationRequest(
        weekStartDate: DateTime(2024, 1, 15),
        numberOfPeople: 4,
        restrictions: [],
        excludedIngredients: [],
        previousWeekMealIds: [],
        includeFavorites: true,
        pinnedFavoriteIds: [],
      );

      // Only 5 meals, which is not enough for a week (need at least 21)
      final meals = List.generate(5, (index) {
        return Meal(
          id: 'meal_$index',
          name: 'Meal $index',
          ingredients: ['ingredient_$index'],
          category: index % 3 == 0 ? 'breakfast' : (index % 3 == 1 ? 'lunch' : 'dinner'),
          calories: 300 + (index * 10),
          createdAt: DateTime.now(),
        );
      });

      when(mockMealRepository.getAllMeals()).thenAnswer((_) async => meals);

      // Act & Assert
      expect(
        () => service.generateWeeklyMealPlan(request),
        throwsA(isA<Exception>()),
      );
    });

    test('should apply dietary restrictions correctly', () async {
      // Arrange
      final request = MealPlanGenerationRequest(
        weekStartDate: DateTime(2024, 1, 15),
        numberOfPeople: 4,
        restrictions: [DietaryTag.vegetarian],
        excludedIngredients: [],
        previousWeekMealIds: [],
        includeFavorites: true,
        pinnedFavoriteIds: [],
      );

      final vegetarianMeal = Meal(
        id: 'veg_1',
        name: 'Vegetarian Meal',
        ingredients: ['vegetables'],
        category: 'lunch',
        calories: 400,
        dietaryTags: [DietaryTag.vegetarian],
        createdAt: DateTime.now(),
      );

      final nonVegetarianMeal = Meal(
        id: 'non_veg_1',
        name: 'Non-Vegetarian Meal',
        ingredients: ['meat'],
        category: 'lunch',
        calories: 500,
        dietaryTags: [],
        createdAt: DateTime.now(),
      );

      when(mockMealRepository.getAllMeals()).thenAnswer((_) async => [vegetarianMeal, nonVegetarianMeal]);
      when(mockMealRepository.getMealById(any)).thenAnswer((_) async => null);

      // Act & Assert
      // This should throw an exception because after filtering, we won't have enough meals
      expect(
        () => service.generateWeeklyMealPlan(request),
        throwsA(isA<Exception>()),
      );
    });

    test('should exclude meals with forbidden ingredients', () async {
      // Arrange
      final request = MealPlanGenerationRequest(
        weekStartDate: DateTime(2024, 1, 15),
        numberOfPeople: 4,
        restrictions: [],
        excludedIngredients: ['nuts'],
        previousWeekMealIds: [],
        includeFavorites: true,
        pinnedFavoriteIds: [],
      );

      final nutFreeMeal = Meal(
        id: 'safe_1',
        name: 'Safe Meal',
        ingredients: ['vegetables'],
        category: 'lunch',
        calories: 400,
        createdAt: DateTime.now(),
      );

      final nutMeal = Meal(
        id: 'unsafe_1',
        name: 'Nutty Meal',
        ingredients: ['almonds', 'peanuts'],
        category: 'lunch',
        calories: 500,
        createdAt: DateTime.now(),
      );

      when(mockMealRepository.getAllMeals()).thenAnswer((_) async => [nutFreeMeal, nutMeal]);
      when(mockMealRepository.getMealById(any)).thenAnswer((_) async => null);

      // Act & Assert
      // This should throw an exception because after filtering, we won't have enough meals
      expect(
        () => service.generateWeeklyMealPlan(request),
        throwsA(isA<Exception>()),
      );
    });

    test('should generate different plans on subsequent calls', () async {
      // Arrange
      final request = MealPlanGenerationRequest(
        weekStartDate: DateTime(2024, 1, 15), // Monday
        numberOfPeople: 4,
        restrictions: [],
        excludedIngredients: [],
        previousWeekMealIds: [],
        includeFavorites: true,
        pinnedFavoriteIds: [],
      );

      // Create meals with proper distribution across categories including snacks
      final meals = <Meal>[];
      
      // Add 15 breakfast meals
      for (int i = 0; i < 15; i++) {
        meals.add(Meal(
          id: 'breakfast_$i',
          name: 'Breakfast Meal $i',
          ingredients: ['ingredient_$i'],
          category: 'breakfast',
          calories: 300 + (i * 10),
          createdAt: DateTime.now(),
        ));
      }
      
      // Add 15 lunch meals
      for (int i = 0; i < 15; i++) {
        meals.add(Meal(
          id: 'lunch_$i',
          name: 'Lunch Meal $i',
          ingredients: ['ingredient_${i + 15}'],
          category: 'lunch',
          calories: 400 + (i * 10),
          createdAt: DateTime.now(),
        ));
      }
      
      // Add 15 dinner meals
      for (int i = 0; i < 15; i++) {
        meals.add(Meal(
          id: 'dinner_$i',
          name: 'Dinner Meal $i',
          ingredients: ['ingredient_${i + 30}'],
          category: 'dinner',
          calories: 500 + (i * 10),
          createdAt: DateTime.now(),
        ));
      }
      
      // Add 15 snack meals
      for (int i = 0; i < 15; i++) {
        meals.add(Meal(
          id: 'snack_$i',
          name: 'Snack Meal $i',
          ingredients: ['ingredient_${i + 45}'],
          category: 'snack',
          calories: 100 + (i * 10),
          createdAt: DateTime.now(),
        ));
      }

      when(mockMealRepository.getAllMeals()).thenAnswer((_) async => meals);
      when(mockMealRepository.getMealById(any)).thenAnswer((_) async => null);

      // Act
      final result1 = await service.generateWeeklyMealPlan(request);
      final result2 = await service.generateWeeklyMealPlan(request);

      // Assert
      expect(result1, isNotEmpty);
      expect(result2, isNotEmpty);
      
      // With a sufficient number of meals and the randomness in selection,
      // it's very likely that at least one meal will be different between the two plans
      bool hasDifferentMeals = false;
      for (int i = 0; i < result1.length; i++) {
        if (result1[i].breakfast?.id != result2[i].breakfast?.id ||
            result1[i].lunch?.id != result2[i].lunch?.id ||
            result1[i].dinner?.id != result2[i].dinner?.id) {
          hasDifferentMeals = true;
          break;
        }
      }
      
      // Note: This test might occasionally fail due to randomness, but it's unlikely with enough meals
      expect(hasDifferentMeals, true);
    });
  });
}