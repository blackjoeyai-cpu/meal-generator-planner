import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';
import 'package:meal_generator_planner/widgets/meal_card.dart';
import 'package:meal_generator_planner/core/utils/date_utils.dart' as app_date_utils;
import 'package:meal_generator_planner/providers/meal_plan_generator_provider.dart';

/// Results display interface with calendar grid and meal cards
class MealPlanResultsPage extends ConsumerWidget {
  const MealPlanResultsPage({super.key, required this.mealPlans, this.errorMessage});

  final List<MealPlan> mealPlans;
  final String? errorMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Meal Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Regenerate meal plan using the last request
              ref.read(mealPlanGeneratorProvider.notifier).regenerateMealPlan();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Regenerating meal plan...')),
              );
            },
          ),
        ],
      ),
      body: _buildContent(context, ref),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Save meal plan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Meal plan saved!')),
          );
        },
        icon: const Icon(Icons.save),
        label: const Text('Save Plan'),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final mealPlanState = ref.watch(mealPlanGeneratorProvider);
    
    // Show error message if there is one
    if (mealPlanState.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Error Generating Meal Plan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              mealPlanState.errorMessage!,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Retry generation
                ref.read(mealPlanGeneratorProvider.notifier).regenerateMealPlan();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    // Show loading indicator if generating
    if (mealPlanState.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Regenerating your meal plan...'),
          ],
        ),
      );
    }

    final plansToDisplay = mealPlanState.mealPlans ?? mealPlans;
    
    if (plansToDisplay.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No meal plans available',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Generate a new meal plan to get started',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Sort meal plans by date
    final sortedPlans = List<MealPlan>.from(plansToDisplay)..sort((a, b) => a.date.compareTo(b.date));
    
    // Group plans by week
    final weeks = _groupPlansByWeek(sortedPlans);
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Week selector if there are multiple weeks
            if (weeks.length > 1) ...[
              const Text(
                'Select Week',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weeks.keys.length,
                  itemBuilder: (context, index) {
                    final weekStart = weeks.keys.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(app_date_utils.DateUtils.formatDate(weekStart)),
                        selected: index == 0, // Select first week by default
                        onSelected: (selected) {
                          // TODO: Handle week selection
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Display meal plans for the selected week
            ...weeks.values.first.map((plan) => _buildDaySection(context, plan)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDaySection(BuildContext context, MealPlan plan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          app_date_utils.DateUtils.formatDateWithDay(plan.date),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        
        // Breakfast
        if (plan.breakfast != null) ...[
          const Text('Breakfast', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          MealCard(meal: plan.breakfast!),
          const SizedBox(height: 8),
        ],
        
        // Lunch
        if (plan.lunch != null) ...[
          const Text('Lunch', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          MealCard(meal: plan.lunch!),
          const SizedBox(height: 8),
        ],
        
        // Dinner
        if (plan.dinner != null) ...[
          const Text('Dinner', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          MealCard(meal: plan.dinner!),
          const SizedBox(height: 8),
        ],
        
        // Snacks
        if (plan.snacks.isNotEmpty) ...[
          const Text('Snacks', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ...plan.snacks.map((snack) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: MealCard(meal: snack),
          )),
        ],
        
        const Divider(height: 32),
      ],
    );
  }
  
  Map<DateTime, List<MealPlan>> _groupPlansByWeek(List<MealPlan> plans) {
    final Map<DateTime, List<MealPlan>> weeks = {};
    
    for (final plan in plans) {
      final weekStart = app_date_utils.DateUtils.getStartOfWeek(plan.date);
      
      if (weeks.containsKey(weekStart)) {
        weeks[weekStart]!.add(plan);
      } else {
        weeks[weekStart] = [plan];
      }
    }
    
    return weeks;
  }
}