import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';
import 'package:meal_generator_planner/data/repositories/repository_providers.dart';
import 'package:meal_generator_planner/features/meal_plan/domain/services/meal_generation_service.dart';

part 'meal_plan_generator_provider.g.dart';

final mealGenerationServiceProvider = FutureProvider<MealGenerationService>((ref) async {
  final mealRepository = await ref.watch(mealRepositoryProvider.future);
  return MealGenerationService(mealRepository);
});

@riverpod
class MealPlanGenerator extends _$MealPlanGenerator {
  @override
  FutureOr<MealPlan?> build() async {
    // For now, we don't load an initial plan.
    return null;
  }

  Future<void> generateWeeklyPlan(MealPlanGenerationRequest request) async {
    state = const AsyncValue.loading();
    final generationService = await ref.read(mealGenerationServiceProvider.future);
    state = await AsyncValue.guard(() async {
      return await generationService.generatePlan(request);
    });
  }
}
