# PRD Feature 03: Shopping List Generation

## 1. Feature Overview

### 1.1 Description
Automatically generates organized shopping lists from meal plans with smart ingredient consolidation, category grouping, and interactive shopping features.

### 1.2 Success Metrics
- 90% of users generate shopping lists from meal plans
- Average list generation time < 2 seconds
- 85% completion rate for shopping list items

---

## 2. Core Functional Requirements

### 2.1 Automatic List Generation

#### 2.1.1 Generation Algorithm
```dart
class ShoppingListGenerator {
  Future<ShoppingList> generate(MealPlan plan) async {
    // 1. Extract ingredients from all meals
    final allIngredients = _extractIngredients(plan);
    
    // 2. Consolidate duplicates and sum quantities
    final consolidated = _consolidateIngredients(allIngredients);
    
    // 3. Group by food categories
    final grouped = _groupByCategory(consolidated);
    
    // 4. Apply smart quantity rounding
    final rounded = _roundQuantities(grouped);
    
    return ShoppingList(items: rounded, generatedFrom: plan.id);
  }
}
```

#### 2.1.2 Smart Consolidation Rules
- Same ingredient names merge quantities
- Similar ingredients suggest consolidation (e.g., "milk" + "whole milk")
- Unit conversion (cups to fluid ounces, etc.)
- Package size suggestions (buy 1 lb when recipe needs 12 oz)

### 2.2 Data Models

#### 2.2.1 Shopping Item Structure
```dart
class ShoppingItem {
  final String id;
  final String name;              // "Chicken breast"
  final double quantity;          // 2.5
  final String unit;             // "lbs"
  final FoodCategory category;    // meat, produce, etc.
  final bool isChecked;          // Purchase status
  final List<String> sourceMealIds; // Which meals need this
  final String? notes;           // User notes/preferences
  final double? estimatedPrice;   // Future feature
  final DateTime addedAt;
}

enum FoodCategory {
  produce,     // Fruits, vegetables, herbs
  meat,        // Fresh proteins, seafood
  dairy,       // Milk, cheese, yogurt, eggs
  pantry,      // Dry goods, canned items, spices
  frozen,      // Frozen vegetables, meals
  bakery,      // Bread, pastries
  beverages,   // Drinks, juices
  other        // Miscellaneous items
}
```

### 2.3 Category Organization System

#### 2.3.1 Smart Categorization
```dart
class IngredientCategorizer {
  static FoodCategory categorize(String ingredientName) {
    final lowercaseName = ingredientName.toLowerCase();
    
    // Use keyword matching and ML classification
    if (_produceKeywords.any(lowercaseName.contains)) return FoodCategory.produce;
    if (_meatKeywords.any(lowercaseName.contains)) return FoodCategory.meat;
    // ... continue for all categories
    
    return FoodCategory.other; // Default fallback
  }
}
```

#### 2.3.2 Category Display Order
1. **Produce** (fresh items first)
2. **Meat & Seafood** (refrigerated section)
3. **Dairy** (refrigerated section)
4. **Frozen** (freezer section)
5. **Pantry** (shelf-stable items)
6. **Bakery** (fresh baked goods)
7. **Beverages** (drinks and liquids)
8. **Other** (miscellaneous items)

### 2.4 Interactive Shopping Features

#### 2.4.1 Check-off System
```dart
class ShoppingListProvider extends StateNotifier<ShoppingListState> {
  void toggleItemChecked(String itemId) {
    state = state.copyWith(
      items: state.items.map((item) =>
        item.id == itemId ? item.copyWith(isChecked: !item.isChecked) : item
      ).toList(),
    );
    _autoSave();
  }

  void checkAllInCategory(FoodCategory category) {
    state = state.copyWith(
      items: state.items.map((item) =>
        item.category == category ? item.copyWith(isChecked: true) : item
      ).toList(),
    );
  }
}
```

#### 2.4.2 Progress Tracking
- Real-time completion percentage
- Category-wise progress indicators
- Visual strikethrough for completed items
- Remaining items counter

---

## 3. User Interface Design

### 3.1 Shopping List Layout

#### 3.1.1 List Structure
```
┌─────────────────────────────────────────────┐
│ Shopping List - Week of Mar 15              │
│ 12 of 24 items completed (50%)             │
│                                             │
│ 🥬 PRODUCE (3 of 5 items)                   │
│ ☐ Carrots         2 lbs    [Notes]         │
│ ☑ Lettuce         1 head   [Notes]         │
│ ☐ Tomatoes        3 pieces [Notes]         │
│                                             │
│ 🥩 MEAT & SEAFOOD (2 of 3 items)           │
│ ☑ Chicken breast  2 lbs    [Notes]         │
│ ☐ Ground beef     1 lb     [Notes]         │
│                                             │
│ [+ Add Custom Item]                         │
│ [Clear Completed] [Export List]             │
└─────────────────────────────────────────────┘
```

### 3.2 Item Interaction Design

#### 3.2.1 Shopping Item Card
- Large checkbox for easy tapping (44px minimum)
- Item name with quantity and unit
- Notes button for additional details
- Swipe gestures: swipe right to check, swipe left for options
- Visual feedback: strikethrough, fade for completed items

#### 3.2.2 Batch Operations
- "Check All" button per category
- "Clear Completed" removes checked items
- Multi-select mode for bulk operations
- Undo functionality for accidental actions

---

## 4. Technical Implementation

### 4.1 Generation Service

#### 4.1.1 Core Algorithm Implementation
```dart
class ShoppingListGenerationService {
  Future<ShoppingList> generateFromMealPlan(String mealPlanId) async {
    final mealPlan = await _mealPlanRepository.getById(mealPlanId);
    final allIngredients = <Ingredient>[];

    // Extract ingredients from all meals
    for (final dailyMeals in mealPlan.dailyMeals.values) {
      allIngredients.addAll(dailyMeals.breakfast.ingredients);
      allIngredients.addAll(dailyMeals.lunch.ingredients);
      allIngredients.addAll(dailyMeals.dinner.ingredients);
      for (final snack in dailyMeals.snacks) {
        allIngredients.addAll(snack.ingredients);
      }
    }

    // Consolidate and create shopping items
    final consolidatedItems = _consolidateIngredients(allIngredients);
    final shoppingItems = consolidatedItems.map(_createShoppingItem).toList();

    return ShoppingList(
      id: _generateListId(mealPlanId),
      items: shoppingItems,
      generatedAt: DateTime.now(),
      sourceMealPlanId: mealPlanId,
    );
  }
}
```

### 4.2 State Management

#### 4.2.1 Shopping List Provider
```dart
@riverpod
class ShoppingListNotifier extends _$ShoppingListNotifier {
  @override
  Future<ShoppingList?> build() async {
    return _repository.getCurrentShoppingList();
  }

  Future<void> generateFromCurrentPlan() async {
    state = const AsyncValue.loading();
    
    try {
      final currentPlan = await ref.read(currentMealPlanProvider.future);
      if (currentPlan == null) throw Exception('No meal plan available');
      
      final newList = await _generationService.generateFromMealPlan(currentPlan.id);
      await _repository.saveShoppingList(newList);
      
      state = AsyncValue.data(newList);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
```

### 4.3 Data Persistence

#### 4.3.1 Local Storage Schema
```dart
@HiveType(typeId: 4)
class ShoppingListHiveModel extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  List<ShoppingItemHiveModel> items;
  
  @HiveField(2)
  DateTime generatedAt;
  
  @HiveField(3)
  String sourceMealPlanId;
  
  @HiveField(4)
  bool isActive;
}

@HiveType(typeId: 5)
class ShoppingItemHiveModel {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  double quantity;
  
  @HiveField(3)
  String unit;
  
  @HiveField(4)
  int category; // FoodCategory enum index
  
  @HiveField(5)
  bool isChecked;
  
  @HiveField(6)
  List<String> sourceMealIds;
  
  @HiveField(7)
  String? notes;
}
```

---

## 5. Testing Requirements

### 5.1 Unit Tests
```dart
group('Shopping List Generation Tests', () {
  test('should consolidate duplicate ingredients', () {
    final ingredients = [
      Ingredient(name: 'Chicken breast', quantity: 1, unit: 'lb'),
      Ingredient(name: 'Chicken breast', quantity: 0.5, unit: 'lb'),
    ];
    
    final result = ShoppingListGenerator.consolidate(ingredients);
    
    expect(result.length, equals(1));
    expect(result.first.quantity, equals(1.5));
  });

  test('should categorize ingredients correctly', () {
    expect(IngredientCategorizer.categorize('Chicken breast'), FoodCategory.meat);
    expect(IngredientCategorizer.categorize('Carrots'), FoodCategory.produce);
    expect(IngredientCategorizer.categorize('Milk'), FoodCategory.dairy);
  });
});
```

### 5.2 Widget Tests
```dart
testWidgets('should toggle item check state when tapped', (tester) async {
  final item = ShoppingItem(name: 'Test Item', isChecked: false);
  
  await tester.pumpWidget(ShoppingItemWidget(item: item));
  await tester.tap(find.byType(Checkbox));
  
  verify(mockProvider.toggleItemChecked(item.id)).called(1);
});
```

---

## 6. Acceptance Criteria

### 6.1 Functional Requirements
- [ ] Generate shopping list from any meal plan
- [ ] Consolidate duplicate ingredients accurately
- [ ] Organize items by food categories
- [ ] Interactive check-off system works
- [ ] Progress tracking updates in real-time
- [ ] Support for custom item additions

### 6.2 Performance Requirements
- [ ] Generation completes within 2 seconds
- [ ] Smooth scrolling through large lists (100+ items)
- [ ] Instant response to check/uncheck actions
- [ ] Efficient local storage operations

### 6.3 Usability Requirements
- [ ] Clear visual hierarchy by categories
- [ ] Easy-to-tap interactive elements
- [ ] Obvious completion status indicators
- [ ] Simple addition of custom items

---

## 7. Dependencies & Future Enhancements

### 7.1 Dependencies
- Meal Plan Generation feature (data source)
- Local storage (Hive database)
- Unit conversion library
- Category classification data

### 7.2 Future Features
- Export to PDF/Excel formats
- Price estimation and budget tracking
- Store layout optimization
- Barcode scanning for items
- Integration with grocery delivery services

This feature completes the meal planning workflow by providing actionable shopping guidance based on planned meals.