# PRD Feature 01: Meal Plan Generation

## 1. Feature Overview

### 1.1 Description
The Meal Plan Generation feature is the core functionality that automatically creates weekly meal plans based on a predefined meal database and intelligent algorithms. It ensures variety, nutritional balance, and user preferences while maintaining simplicity for the target audience of busy households.

### 1.2 Business Value
- **Primary Value**: Saves 30+ minutes of weekly meal planning time for households
- **User Impact**: Eliminates decision fatigue around "what to cook today"
- **Competitive Advantage**: One-click generation with offline capability

### 1.3 Success Metrics
- Generation time < 1 second
- 90% user satisfaction with generated plans
- 70% of users use generated plans without major modifications
- Zero crashes during generation process

---

## 2. Functional Requirements

### 2.1 Core Algorithm Specifications

#### 2.1.1 Input Parameters
```dart
class MealPlanGenerationRequest {
  final DateTime weekStartDate;        // Default: current week Monday
  final int numberOfPeople;           // Range: 1-10, Default: 4
  final List<DietaryRestriction> restrictions; // Optional filters
  final List<String> excludedIngredients;     // Allergens/dislikes
  final List<String> previousWeekMealIds;     // Avoid recent repetitions
  final bool includeFavorites;        // Priority to favorite meals
  final List<String> pinnedFavoriteIds;      // Must-include meals
}
```

#### 2.1.2 Algorithm Logic Flow
1. **Data Preparation**
   - Load available meals from local Hive database
   - Filter meals based on dietary restrictions
   - Exclude meals containing forbidden ingredients
   - Remove meals used in the last 7 days

2. **Meal Selection Strategy**
   ```
   For each day (Monday to Sunday):
     For each meal type (Breakfast, Lunch, Dinner):
       1. Check if pinned favorite exists for this slot → Use it
       2. Filter available meals by category and constraints
       3. Apply weighted selection algorithm:
          - Favorites: 40% higher probability
          - Recently unused: 30% higher probability
          - Nutritionally balanced: 20% higher probability
          - Random selection: 10%
       4. Select meal and remove from available pool
   
   For snacks (optional, 0-2 per day):
     - Select based on remaining daily calorie budget
     - Maximum 200 calories per snack
   ```

3. **Validation Rules**
   - No meal repetition within 7-day period
   - Each day has exactly 3 main meals (B/L/D)
   - Daily calorie range: 1800-2400 (adjustable by number of people)
   - Weekly nutritional balance: 40% carbs, 30% protein, 30% vegetables
   - Minimum 2 vegetarian meals per week
   - Maximum 2 high-calorie meals (>700 cal) per week

#### 2.1.3 Meal Database Structure
```dart
class Meal {
  final String id;                    // UUID format
  final String name;                  // Display name (max 50 chars)
  final String description;           // Brief description (max 150 chars)
  final List<Ingredient> ingredients; // Complete ingredient list
  final MealCategory category;        // breakfast, lunch, dinner, snack
  final int estimatedCalories;        // Per serving
  final int preparationTimeMinutes;   // Cooking + prep time
  final DifficultyLevel difficulty;   // easy, medium, hard
  final List<DietaryTag> dietaryTags; // vegetarian, vegan, gluten-free, etc.
  final String imageAssetPath;        // Local image asset
  final String cookingInstructions;   // Step-by-step guide
  final int defaultServings;          // Standard serving size
  final DateTime createdAt;
  final bool isFavorite;
  final bool isCustomUserMeal;        // User-created vs pre-loaded
  final Map<String, dynamic> nutritionFacts; // Optional detailed nutrition
}

class Ingredient {
  final String name;           // e.g., "Chicken breast"
  final double quantity;       // e.g., 2
  final String unit;          // e.g., "pieces", "cups", "lbs"
  final FoodCategory category; // For shopping list grouping
  final bool isOptional;      // Can be omitted if unavailable
}

enum MealCategory { breakfast, lunch, dinner, snack }
enum DifficultyLevel { easy, medium, hard }
enum DietaryTag { vegetarian, vegan, glutenFree, dairyFree, nutFree, lowCarb }
enum FoodCategory { produce, meat, dairy, pantry, frozen, bakery }
```

### 2.2 User Interface Requirements

#### 2.2.1 Generation Trigger Interface
- **Home Screen Button**: Large, prominent "Generate New Plan" CTA
  - Size: Minimum 280x60px on mobile, 320x80px on web
  - Color: Primary green (#4CAF50)
  - Text: "Generate Weekly Plan" with calendar icon
  - Position: Center of home screen, above fold

- **Quick Generation Options** (Future enhancement):
  - "Generate for This Week"
  - "Generate for Next Week"
  - "Quick Generate" (uses default settings)

#### 2.2.2 Generation Configuration Screen (Optional)
- **Number of People Selector**: 
  - Slider: 1-10 people
  - Visual indicator showing portion adjustments
  - Default: 4 people

- **Dietary Preferences**:
  - Toggle switches for common restrictions
  - "Vegetarian Friendly" (ensures 50%+ vegetarian meals)
  - "Quick Meals Only" (under 30 min prep time)
  - Custom ingredient exclusion list

#### 2.2.3 Loading State Interface
- **Progress Indicator**:
  - Circular progress with descriptive text
  - Messages: "Loading meals...", "Creating your plan...", "Almost ready!"
  - Maximum duration: 1 second (with timeout handling)
  - Skeleton UI showing weekly calendar structure

#### 2.2.4 Results Display Interface
- **Weekly Calendar Grid**:
  ```
  |   Mon   |   Tue   |   Wed   |   Thu   |   Fri   |   Sat   |   Sun   |
  |---------|---------|---------|---------|---------|---------|---------|
  |🍳 B-fast|🍳 B-fast|🍳 B-fast|🍳 B-fast|🍳 B-fast|🍳 B-fast|🍳 B-fast|
  |🥙 Lunch |🥙 Lunch |🥙 Lunch |🥙 Lunch |🥙 Lunch |🥙 Lunch |🥙 Lunch |
  |🍽️ Dinner|🍽️ Dinner|🍽️ Dinner|🍽️ Dinner|🍽️ Dinner|🍽️ Dinner|🍽️ Dinner|
  |🍎 Snack |         |🍎 Snack |         |🍎 Snack |         |         |
  ```

- **Meal Card Design**:
  - Meal image thumbnail (80x80px)
  - Meal name (truncated if > 20 chars)
  - Prep time and calorie badges
  - Favorite heart icon (if applicable)
  - Tap to expand/edit functionality

- **Action Buttons**:
  - "Accept This Plan" (primary action)
  - "Generate Again" (secondary action)
  - "Customize Plan" (tertiary action)

### 2.3 Error Handling & Edge Cases

#### 2.3.1 Insufficient Meal Database
- **Scenario**: Less than 21 unique meals in database
- **Handling**: 
  - Show warning message: "Limited meal variety detected"
  - Suggest adding custom meals or importing additional recipes
  - Allow generation with repetitions if user confirms

#### 2.3.2 Over-Constrained Parameters
- **Scenario**: Filters eliminate too many meal options
- **Handling**:
  - Progressively relax constraints in this order:
    1. Remove "recently used" constraint
    2. Allow some repetitions
    3. Ignore prep time preferences
    4. Show message explaining adjustments made

#### 2.3.3 Generation Algorithm Failure
- **Scenario**: Algorithm cannot complete due to data corruption or logic error
- **Fallback Strategy**:
  - Simple round-robin selection from available meals
  - Basic nutritional balance (rotate categories)
  - Log error for debugging
  - Show "Basic plan generated" message

#### 2.3.4 Storage Failures
- **Scenario**: Cannot save generated plan to local storage
- **Handling**:
  - Keep plan in memory for current session
  - Show storage warning to user
  - Attempt to save periodically
  - Offer manual export option

---

## 3. Technical Implementation Details

### 3.1 Data Architecture

#### 3.1.1 Local Database Schema (Hive)
```dart
// Box: 'meals'
@HiveType(typeId: 0)
class MealHiveModel extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  List<IngredientHiveModel> ingredients;
  
  @HiveField(3)
  int category; // Enum index
  
  @HiveField(4)
  int calories;
  
  @HiveField(5)
  int prepTimeMinutes;
  
  @HiveField(6)
  List<int> dietaryTags; // Enum indices
  
  @HiveField(7)
  bool isFavorite;
  
  @HiveField(8)
  bool isCustom;
  
  @HiveField(9)
  DateTime createdAt;
}

// Box: 'meal_plans'
@HiveType(typeId: 1)
class MealPlanHiveModel extends HiveObject {
  @HiveField(0)
  String weekId; // Format: "2024-W01"
  
  @HiveField(1)
  DateTime weekStartDate;
  
  @HiveField(2)
  Map<String, List<String>> dailyMealIds; // Day -> List of meal IDs
  
  @HiveField(3)
  DateTime generatedAt;
  
  @HiveField(4)
  bool isActive; // Current active plan
}
```

#### 3.1.2 Repository Pattern Implementation
```dart
abstract class MealRepository {
  Future<List<Meal>> getAllMeals();
  Future<List<Meal>> getMealsByCategory(MealCategory category);
  Future<List<Meal>> getFavoriteMeals();
  Future<Meal?> getMealById(String id);
  Future<void> saveMeal(Meal meal);
  Future<void> deleteMeal(String id);
}

abstract class MealPlanRepository {
  Future<MealPlan?> getCurrentMealPlan();
  Future<List<MealPlan>> getMealPlanHistory();
  Future<void> saveMealPlan(MealPlan plan);
  Future<void> setActiveMealPlan(String weekId);
}
```

### 3.2 State Management (Riverpod)

#### 3.2.1 Generation State Provider
```dart
@riverpod
class MealPlanGenerator extends _$MealPlanGenerator {
  @override
  FutureOr<MealPlan?> build() async {
    return ref.read(mealPlanRepositoryProvider).getCurrentMealPlan();
  }

  Future<MealPlan> generateWeeklyPlan(MealPlanGenerationRequest request) async {
    state = const AsyncValue.loading();
    
    try {
      final generationService = ref.read(mealGenerationServiceProvider);
      final newPlan = await generationService.generatePlan(request);
      
      // Save to local storage
      await ref.read(mealPlanRepositoryProvider).saveMealPlan(newPlan);
      
      state = AsyncValue.data(newPlan);
      return newPlan;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> regeneratePlan() async {
    final currentRequest = _buildDefaultRequest();
    await generateWeeklyPlan(currentRequest);
  }
}
```

#### 3.2.2 Meal Database Provider
```dart
@riverpod
Future<List<Meal>> availableMeals(AvailableMealsRef ref) async {
  final repository = ref.read(mealRepositoryProvider);
  return repository.getAllMeals();
}

@riverpod
Future<List<Meal>> mealsByCategory(MealsByCategoryRef ref, MealCategory category) async {
  final repository = ref.read(mealRepositoryProvider);
  return repository.getMealsByCategory(category);
}
```

### 3.3 Core Generation Service

#### 3.3.1 Service Interface
```dart
class MealGenerationService {
  final MealRepository _mealRepository;
  final Random _random = Random();

  MealGenerationService(this._mealRepository);

  Future<MealPlan> generatePlan(MealPlanGenerationRequest request) async {
    // 1. Load and filter available meals
    final availableMeals = await _loadFilteredMeals(request);
    
    // 2. Validate sufficient meal variety
    _validateMealAvailability(availableMeals);
    
    // 3. Generate daily meal assignments
    final weeklyMeals = <DateTime, DailyMeals>{};
    
    for (int day = 0; day < 7; day++) {
      final currentDate = request.weekStartDate.add(Duration(days: day));
      final dailyMeals = await _generateDayMeals(
        availableMeals, 
        request, 
        weeklyMeals.values.toList()
      );
      weeklyMeals[currentDate] = dailyMeals;
    }
    
    // 4. Create and return meal plan
    return MealPlan(
      id: _generatePlanId(request.weekStartDate),
      weekStartDate: request.weekStartDate,
      dailyMeals: weeklyMeals,
      generatedAt: DateTime.now(),
      generationParameters: request,
    );
  }

  Future<DailyMeals> _generateDayMeals(
    Map<MealCategory, List<Meal>> availableMeals,
    MealPlanGenerationRequest request,
    List<DailyMeals> previousDays,
  ) async {
    // Implementation details for daily meal selection
    final breakfast = _selectMealForCategory(
      MealCategory.breakfast, 
      availableMeals, 
      previousDays,
    );
    
    final lunch = _selectMealForCategory(
      MealCategory.lunch, 
      availableMeals, 
      previousDays,
    );
    
    final dinner = _selectMealForCategory(
      MealCategory.dinner, 
      availableMeals, 
      previousDays,
    );
    
    final snacks = _selectSnacks(availableMeals, request.numberOfPeople);
    
    return DailyMeals(
      breakfast: breakfast,
      lunch: lunch,
      dinner: dinner,
      snacks: snacks,
    );
  }
}
```

### 3.4 Performance Optimization

#### 3.4.1 Caching Strategy
- **Meal Database Cache**: Keep frequently accessed meals in memory
- **Generated Plan Cache**: Cache last 3 generated plans for quick regeneration
- **Image Cache**: Preload meal images for smooth UI

#### 3.4.2 Background Processing
- **Pre-computation**: Calculate meal combinations during app idle time
- **Lazy Loading**: Load meal details only when needed for display
- **Batch Operations**: Group database operations for better performance

---

## 4. Testing Requirements

### 4.1 Unit Tests

#### 4.1.1 Algorithm Testing
```dart
group('Meal Generation Algorithm Tests', () {
  test('should generate 7 days of meals without repetition', () {
    // Test implementation
  });

  test('should respect dietary restrictions', () {
    // Test implementation
  });

  test('should include pinned favorites', () {
    // Test implementation
  });

  test('should handle insufficient meal database gracefully', () {
    // Test implementation
  });

  test('should maintain calorie balance across week', () {
    // Test implementation
  });
});
```

#### 4.1.2 Data Model Testing
```dart
group('Meal Model Tests', () {
  test('should serialize to/from JSON correctly', () {
    // Test implementation
  });

  test('should validate required fields', () {
    // Test implementation
  });

  test('should calculate total calories correctly', () {
    // Test implementation
  });
});
```

### 4.2 Widget Tests

#### 4.2.1 Generation UI Testing
```dart
group('Meal Plan Generation UI Tests', () {
  testWidgets('should show generate button on home screen', (tester) async {
    // Test implementation
  });

  testWidgets('should display loading indicator during generation', (tester) async {
    // Test implementation
  });

  testWidgets('should show generated plan in calendar view', (tester) async {
    // Test implementation
  });

  testWidgets('should handle generation errors gracefully', (tester) async {
    // Test implementation
  });
});
```

### 4.3 Integration Tests

#### 4.3.1 End-to-End Generation Flow
```dart
group('Meal Generation E2E Tests', () {
  testWidgets('complete generation workflow', (tester) async {
    // 1. Tap generate button
    // 2. Wait for loading
    // 3. Verify plan is displayed
    // 4. Verify plan is saved to storage
    // 5. Verify can regenerate
  });
});
```

### 4.4 Performance Tests

#### 4.4.1 Generation Speed Tests
- Test generation time with different database sizes (50, 100, 500+ meals)
- Memory usage monitoring during generation
- UI responsiveness during background generation

---

## 5. Acceptance Criteria

### 5.1 Functional Acceptance Criteria
- [ ] User can generate a weekly meal plan with one tap
- [ ] Generated plan contains 7 days × 3 meals (21 total meals minimum)
- [ ] No meal repetition within the 7-day period
- [ ] Plan respects dietary restrictions if specified
- [ ] Pinned favorite meals are included when possible
- [ ] Generated plan is automatically saved locally
- [ ] User can regenerate plan if unsatisfied

### 5.2 Performance Acceptance Criteria
- [ ] Generation completes within 1 second on average device
- [ ] Memory usage stays under 50MB during generation
- [ ] No UI blocking during generation process
- [ ] Graceful handling of generation failures

### 5.3 Usability Acceptance Criteria
- [ ] Generate button is prominently visible on home screen
- [ ] Loading state provides clear feedback to user
- [ ] Generated plan is visually appealing and easy to read
- [ ] User can immediately see all meals for the week
- [ ] Error messages are clear and actionable

---

## 6. Dependencies & Prerequisites

### 6.1 Technical Dependencies
- **Flutter SDK**: 3.0+ with stable channel
- **Hive Database**: Local storage for meals and plans
- **Riverpod**: State management for generation state
- **UUID Package**: Unique identifier generation

### 6.2 Data Dependencies
- **Starter Meal Database**: Minimum 50 pre-loaded meals
- **Meal Images**: Local asset images for visual appeal
- **Nutritional Data**: Basic calorie information per meal

### 6.3 Design Dependencies
- **UI/UX Mockups**: Approved designs for all generation screens
- **Icon Assets**: Generate button, meal category icons
- **Color Scheme**: Defined primary/secondary colors

---

## 7. Future Enhancements

### 7.1 Short-term Enhancements (Next 3 months)
- [ ] **Smart Defaults**: Learn user preferences over time
- [ ] **Batch Generation**: Generate multiple weeks at once
- [ ] **Template Plans**: Save and reuse successful plan patterns

### 7.2 Medium-term Enhancements (3-6 months)
- [ ] **Advanced Filters**: Cuisine type, cooking method, ingredients on hand
- [ ] **Nutritional Targeting**: Specific calorie/macro goals
- [ ] **Seasonal Preferences**: Favor seasonal ingredients

### 7.3 Long-term Enhancements (6+ months)
- [ ] **AI-Powered Generation**: Machine learning for better recommendations
- [ ] **External Recipe APIs**: Expand meal database dynamically
- [ ] **Social Features**: Share and rate meal plans with community

---

## 8. Definition of Done

This feature is considered complete when:

1. **All acceptance criteria are met** and verified through testing
2. **Performance benchmarks** are achieved on target devices
3. **Code coverage** reaches minimum 80% for generation logic
4. **User testing** shows 90%+ satisfaction with generation speed and results
5. **Integration testing** passes with other app features
6. **Documentation** is complete including code comments and user guides
7. **Accessibility compliance** meets WCAG 2.1 AA standards
8. **Cross-platform testing** completed on Android and Web targets

The Meal Plan Generation feature serves as the foundation for all other app features and must be robust, fast, and user-friendly to ensure overall app success.