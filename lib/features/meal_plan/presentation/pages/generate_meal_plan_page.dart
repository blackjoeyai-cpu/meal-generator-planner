import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_generator_planner/data/models/meal_plan_generation_request.dart';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/features/meal_plan/presentation/pages/meal_plan_results_page.dart';
import 'package:meal_generator_planner/providers/meal_plan_generator_provider.dart';

/// Loading indicator widget with descriptive text
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.message = 'Generating your meal plan...',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Generation configuration screen for meal plans
class GenerateMealPlanPage extends ConsumerStatefulWidget {
  const GenerateMealPlanPage({super.key});

  @override
  ConsumerState<GenerateMealPlanPage> createState() =>
      _GenerateMealPlanPageState();
}

class _GenerateMealPlanPageState extends ConsumerState<GenerateMealPlanPage> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  int _numberOfPeople = 4;
  final List<DietaryTag> _selectedDietaryTags = [];
  final List<String> _excludedIngredients = [];
  final TextEditingController _ingredientController = TextEditingController();
  bool _includeFavorites = true;

  // Error handling
  String? _errorMessage;

  // Add a new ingredient to exclude
  void _addExcludedIngredient() {
    if (_ingredientController.text.trim().isNotEmpty) {
      setState(() {
        _excludedIngredients.add(_ingredientController.text.trim());
        _ingredientController.clear();
        _errorMessage = null; // Clear any previous error
      });
    }
  }

  // Remove an excluded ingredient
  void _removeExcludedIngredient(String ingredient) {
    setState(() {
      _excludedIngredients.remove(ingredient);
      _errorMessage = null; // Clear any previous error
    });
  }

  // Toggle a dietary tag
  void _toggleDietaryTag(DietaryTag tag) {
    setState(() {
      if (_selectedDietaryTags.contains(tag)) {
        _selectedDietaryTags.remove(tag);
      } else {
        _selectedDietaryTags.add(tag);
      }
      _errorMessage = null; // Clear any previous error
    });
  }

  // Generate the meal plan
  void _generateMealPlan() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = null; // Clear any previous error
      });

      // Create the generation request
      final request = MealPlanGenerationRequest(
        weekStartDate: DateTime.now(),
        numberOfPeople: _numberOfPeople,
        restrictions: List.from(_selectedDietaryTags),
        excludedIngredients: List.from(_excludedIngredients),
        previousWeekMealIds: [], // In a real app, this would come from storage
        includeFavorites: _includeFavorites,
        pinnedFavoriteIds:
            [], // In a real app, this would come from user selections
      );

      // Call the meal plan generation service through the provider
      ref.read(mealPlanGeneratorProvider.notifier).generateMealPlan(request);

      // Navigate to results page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MealPlanResultsPage(
            mealPlans: [], // Will be populated by the provider
            errorMessage: null, // Will be handled by the provider
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mealPlanState = ref.watch(mealPlanGeneratorProvider);

    // Show loading indicator if generating
    if (mealPlanState.isLoading && Navigator.canPop(context)) {
      return const LoadingIndicator();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Generate Meal Plan')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Configure your meal plan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Error message display
              if (_errorMessage != null) ...[
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _errorMessage = null;
                            });
                          },
                          child: const Text('Dismiss'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Number of people selector
              const Text(
                'Number of People',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_numberOfPeople > 1) {
                        setState(() {
                          _numberOfPeople--;
                          _errorMessage = null; // Clear any previous error
                        });
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    '$_numberOfPeople',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_numberOfPeople < 10) {
                        setState(() {
                          _numberOfPeople++;
                          _errorMessage = null; // Clear any previous error
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Dietary preferences
              const Text(
                'Dietary Preferences',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: DietaryTag.values.map((tag) {
                  final isSelected = _selectedDietaryTags.contains(tag);
                  return FilterChip(
                    label: Text(_getDietaryTagDisplayName(tag)),
                    selected: isSelected,
                    onSelected: (_) => _toggleDietaryTag(tag),
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Include favorites toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Include Favorite Meals',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: _includeFavorites,
                    onChanged: (value) {
                      setState(() {
                        _includeFavorites = value;
                        _errorMessage = null; // Clear any previous error
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Excluded ingredients
              const Text(
                'Exclude Ingredients',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ingredientController,
                      decoration: const InputDecoration(
                        hintText: 'Enter an ingredient to exclude',
                        border: OutlineInputBorder(),
                      ),
                      onFieldSubmitted: (_) => _addExcludedIngredient(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addExcludedIngredient,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_excludedIngredients.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _excludedIngredients.map((ingredient) {
                    return Chip(
                      label: Text(ingredient),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => _removeExcludedIngredient(ingredient),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 30),

              // Generate button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _generateMealPlan,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Generate Meal Plan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDietaryTagDisplayName(DietaryTag tag) {
    switch (tag) {
      case DietaryTag.vegetarian:
        return 'Vegetarian';
      case DietaryTag.vegan:
        return 'Vegan';
      case DietaryTag.glutenFree:
        return 'Gluten Free';
      case DietaryTag.dairyFree:
        return 'Dairy Free';
      case DietaryTag.nutFree:
        return 'Nut Free';
      case DietaryTag.lowCarb:
        return 'Low Carb';
    }
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }
}
