import 'package:hive/hive.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';
import 'package:meal_generator_planner/data/repositories/meal_plan_repository.dart';

class HiveMealPlanRepository implements MealPlanRepository {
  final Box<MealPlan> _box;

  HiveMealPlanRepository(this._box);

  static Future<HiveMealPlanRepository> create() async {
    final box = await Hive.openBox<MealPlan>('meal_plans');
    return HiveMealPlanRepository(box);
  }

  @override
  Future<void> deleteMealPlan(String id) async {
    await _box.delete(id);
  }

  @override
  Future<MealPlan?> getCurrentMealPlan() async {
    try {
      return _box.values.firstWhere((plan) => plan.isActive);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<MealPlan?> getMealPlanById(String id) async {
    return _box.get(id);
  }

  @override
  Future<List<MealPlan>> getMealPlanHistory() async {
    return _box.values.where((plan) => !plan.isActive).toList();
  }

  @override
  Future<void> saveMealPlan(MealPlan plan) async {
    await _box.put(plan.id, plan);
  }

  @override
  Future<void> setActiveMealPlan(String id) async {
    final currentActive = await getCurrentMealPlan();
    if (currentActive != null) {
      await saveMealPlan(currentActive.copyWith(isActive: false));
    }

    final newActive = await getMealPlanById(id);
    if (newActive != null) {
      await saveMealPlan(newActive.copyWith(isActive: true));
    }
  }
}
