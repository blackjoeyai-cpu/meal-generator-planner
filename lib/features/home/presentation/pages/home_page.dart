import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';
import 'package:meal_generator_planner/features/meal_plan/presentation/providers/meal_plan_generator_provider.dart';
import 'package:meal_generator_planner/features/meal_plan/presentation/widgets/weekly_calendar_grid.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealPlanState = ref.watch(mealPlanGeneratorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Meal Plan Generator')),
      body: Center(
        child: mealPlanState.when(
          data: (mealPlan) {
            if (mealPlan == null) {
              return ElevatedButton.icon(
                onPressed: () {
                  final request = MealPlanGenerationRequest(
                    weekStartDate: DateTime.now(),
                    numberOfPeople: 4,
                  );
                  ref
                      .read(mealPlanGeneratorProvider.notifier)
                      .generateWeeklyPlan(request);
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Generate Weekly Plan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 24,
                  ),
                  textStyle: const TextStyle(fontSize: 20),
                ),
              );
            } else {
              // Display the generated meal plan
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Your Weekly Plan:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: WeeklyCalendarGrid(mealPlan: mealPlan)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final request = MealPlanGenerationRequest(
                            weekStartDate: DateTime.now(),
                            numberOfPeople: 4,
                          );
                          ref
                              .read(mealPlanGeneratorProvider.notifier)
                              .generateWeeklyPlan(request);
                        },
                        child: const Text('Generate Again'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement customize plan
                        },
                        child: const Text('Customize Plan'),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${error.toString()}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final request = MealPlanGenerationRequest(
                    weekStartDate: DateTime.now(),
                    numberOfPeople: 4,
                  );
                  ref
                      .read(mealPlanGeneratorProvider.notifier)
                      .generateWeeklyPlan(request);
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
