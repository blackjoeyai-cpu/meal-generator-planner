import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';
import 'package:meal_generator_planner/data/models/meal_plan_generation_request.dart';
import 'package:meal_generator_planner/data/services/meal_generation_service.dart';
import 'package:meal_generator_planner/data/repositories/meal_repository.dart';
import 'package:meal_generator_planner/data/repositories/meal_plan_repository.dart';

/// Exception thrown when storage operations fail
class StorageFailureException implements Exception {
  final String message;
  
  StorageFailureException(this.message);
  
  @override
  String toString() => 'StorageFailureException: $message';
}

/// State management for the meal plan generation process
class MealPlanGeneratorState {
  final bool isLoading;
  final List<MealPlan>? mealPlans;
  final String? errorMessage;
  final bool isSuccess;
  final MealPlanGenerationRequest? lastRequest; // Store last request for regeneration

  MealPlanGeneratorState({
    this.isLoading = false,
    this.mealPlans,
    this.errorMessage,
    this.isSuccess = false,
    this.lastRequest,
  });

  MealPlanGeneratorState copyWith({
    bool? isLoading,
    List<MealPlan>? mealPlans,
    String? errorMessage,
    bool? isSuccess,
    MealPlanGenerationRequest? lastRequest,
  }) {
    return MealPlanGeneratorState(
      isLoading: isLoading ?? this.isLoading,
      mealPlans: mealPlans ?? this.mealPlans,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      lastRequest: lastRequest ?? this.lastRequest,
    );
  }
}

/// Provider for meal plan generation functionality
class MealPlanGeneratorNotifier extends StateNotifier<MealPlanGeneratorState> {
  final MealGenerationService _mealGenerationService;
  final MealPlanRepository _mealPlanRepository;

  MealPlanGeneratorNotifier({
    required MealRepository mealRepository,
    required MealPlanRepository mealPlanRepository,
  }) : _mealGenerationService = MealGenerationService(
          mealRepository: mealRepository,
        ),
        _mealPlanRepository = mealPlanRepository,
        super(MealPlanGeneratorState());

  /// Generate a new meal plan based on the provided request
  Future<void> generateMealPlan(MealPlanGenerationRequest request) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final mealPlans = await _mealGenerationService.generateWeeklyMealPlan(request);
      state = MealPlanGeneratorState(
        isLoading: false,
        mealPlans: mealPlans,
        isSuccess: true,
        lastRequest: request, // Store the request for regeneration
      );
    } catch (e, stackTrace) {
      debugPrint('Error generating meal plan: $e');
      debugPrint('Stack trace: $stackTrace');
      
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
        lastRequest: request, // Still store the request even if generation failed
      );
    }
  }

  /// Regenerate meal plan using the last request
  Future<void> regenerateMealPlan() async {
    if (state.lastRequest == null) {
      state = state.copyWith(
        errorMessage: 'No previous generation request found',
      );
      return;
    }

    await generateMealPlan(state.lastRequest!);
  }

  /// Save the generated meal plans to storage
  Future<void> saveMealPlans() async {
    if (state.mealPlans == null || state.mealPlans!.isEmpty) {
      state = state.copyWith(
        errorMessage: 'No meal plans to save',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Save each meal plan
      for (final mealPlan in state.mealPlans!) {
        await _mealPlanRepository.addMealPlan(mealPlan);
      }
      
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: 'Meal plans saved successfully',
      );
    } catch (e, stackTrace) {
      debugPrint('Error saving meal plans: $e');
      debugPrint('Stack trace: $stackTrace');
      
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save meal plans: ${e.toString()}',
        isSuccess: false,
      );
    }
  }

  /// Clear the current state
  void clearState() {
    state = MealPlanGeneratorState();
  }
}

/// Riverpod provider for meal plan generation
final mealPlanGeneratorProvider = StateNotifierProvider<MealPlanGeneratorNotifier, MealPlanGeneratorState>(
  (ref) {
    // In a real implementation, these would be injected through ref.read
    // For now, we'll create mock repositories
    // TODO: Replace with actual repository instances when available
    final mealRepository = FakeMealRepository();
    final mealPlanRepository = FakeMealPlanRepository();
    
    return MealPlanGeneratorNotifier(
      mealRepository: mealRepository,
      mealPlanRepository: mealPlanRepository,
    );
  },
);

// TODO: Remove these fake repositories when real ones are available
class FakeMealRepository implements MealRepository {
  @override
  Future<void> addMeal(Meal meal) async {}

  @override
  Future<List<Meal>> getAllMeals() async => [];

  @override
  Future<Meal?> getMealById(String id) async => null;

  @override
  Future<List<Meal>> getMealsByCategory(String category) async => [];

  @override
  Future<List<Meal>> getFavoriteMeals() async => [];

  @override
  Future<List<Meal>> searchMeals(String query) async => [];

  @override
  Future<void> toggleMealFavorite(String mealId) async {}

  @override
  Future<void> updateMeal(Meal meal) async {}

  @override
  Future<void> deleteMeal(String id) async {}

  // New methods that need to be implemented
  @override
  Future<List<Meal>> getMealsByDietaryTags(List<DietaryTag> tags) async => [];

  @override
  Future<List<Meal>> getMealsExcludingIds(List<String> excludedIds) async => [];

  @override
  Future<List<Meal>> getRecentMeals(DateTime since) async => [];
}

class FakeMealPlanRepository implements MealPlanRepository {
  @override
  Future<void> addMealPlan(MealPlan mealPlan) async {}

  @override
  Future<List<MealPlan>> getAllMealPlans() async => [];

  @override
  Future<MealPlan?> getMealPlanByDate(DateTime date) async => null;

  @override
  Future<List<MealPlan>> getMealPlansInRange(DateTime startDate, DateTime endDate) async => [];

  @override
  Future<List<MealPlan>> getCurrentWeekMealPlans() async => [];

  @override
  Future<bool> hasMealPlanForDate(DateTime date) async => false;

  @override
  Future<void> updateMealPlan(MealPlan mealPlan) async {}

  @override
  Future<void> deleteMealPlan(String id) async {}

  // New methods that need to be implemented
  @override
  Future<List<MealPlan>> getMealPlansForWeek(DateTime weekStartDate) async => [];

  @override
  Future<MealPlan?> getMostRecentMealPlan() async => null;

  @override
  Future<List<String>> getRecentMealIds(DateTime since) async => [];
}