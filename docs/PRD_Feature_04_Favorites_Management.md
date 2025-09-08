# PRD Feature 04: Favorites Management

## 1. Feature Overview

### 1.1 Description
Enables users to save, organize, and prioritize preferred meals for quick access and guaranteed inclusion in future meal plans, creating a personalized meal database.

### 1.2 Success Metrics
- 80% of users save at least 5 favorite meals
- 60% of generated plans include user favorites
- Average time to add meal to plan from favorites < 5 seconds

---

## 2. Core Functional Requirements

### 2.1 Adding Favorites System

#### 2.1.1 Methods to Add Favorites
```dart
enum FavoriteAddMethod {
  heartIcon,        // Toggle on meal cards
  contextMenu,      // "Add to Favorites" option
  mealDetail,       // Button in meal detail view
  bulkSelection,    // Multi-select from meal plan
  autoSuggest,      // Based on usage frequency
}
```

#### 2.1.2 Favorite Addition Workflow
```dart
class FavoritesService {
  Future<void> addToFavorites(String mealId) async {
    final meal = await _mealRepository.getMealById(mealId);
    
    // Update meal favorite status
    final updatedMeal = meal.copyWith(isFavorite: true);
    await _mealRepository.updateMeal(updatedMeal);
    
    // Track usage analytics
    await _analyticsService.trackFavoriteAdded(mealId);
    
    // Show confirmation feedback
    _showFeedback('Added to favorites');
  }
}
```

### 2.2 Data Models

#### 2.2.1 Favorite Meal Structure
```dart
class FavoriteMeal extends Meal {
  final DateTime favoritedAt;      // When favorited
  final int usageCount;           // How many times used
  final DateTime lastUsed;        // Last time included in plan
  final bool isPinned;            // Priority favorite
  final List<String> userTags;   // Custom organization tags
  final double userRating;       // 1-5 star rating (future)
  
  // Override to include favorite-specific data
  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'favoritedAt': favoritedAt.toIso8601String(),
    'usageCount': usageCount,
    'lastUsed': lastUsed.toIso8601String(),
    'isPinned': isPinned,
    'userTags': userTags,
  };
}
```

### 2.3 Priority Favorites (Pinned System)

#### 2.3.1 Pinning Functionality
```dart
class PinnedFavoritesManager {
  static const int maxPinnedFavorites = 5;
  
  Future<bool> pinFavorite(String mealId) async {
    final currentPinned = await _getPinnedFavorites();
    
    if (currentPinned.length >= maxPinnedFavorites) {
      throw PinLimitExceededException('Maximum $maxPinnedFavorites pinned meals allowed');
    }
    
    await _updatePinStatus(mealId, true);
    return true;
  }
  
  Future<void> unpinFavorite(String mealId) async {
    await _updatePinStatus(mealId, false);
  }
}
```

#### 2.3.2 Integration with Meal Generation
- Pinned favorites have 80% probability of inclusion in generated plans
- Meal generation algorithm prioritizes pinned meals first
- User can see pinned meals highlighted in generation results

### 2.4 Organization and Discovery

#### 2.4.1 Favorites Interface Layout
```dart
class FavoritesScreen extends StatefulWidget {
  // Tab Structure:
  // - All Favorites (default view)
  // - Pinned (priority favorites)
  // - Recent (recently added/used)
  // - Custom Tags (user-organized)
}
```

#### 2.4.2 Search and Filter System
```dart
class FavoritesFilter {
  MealCategory? category;           // Filter by meal type
  List<DietaryTag> dietaryTags;    // Dietary restrictions
  PreparationTime? maxPrepTime;    // Time constraints
  DifficultyLevel? maxDifficulty;  // Cooking skill level
  String? searchQuery;             // Text search
  FavoritesSortOrder sortOrder;    // Sort preferences
}

enum FavoritesSortOrder {
  mostRecent,      // Recently favorited
  mostUsed,        // Usage frequency
  alphabetical,    // A-Z by name
  prepTime,        // Shortest prep first
  category,        // Group by meal type
}
```

---

## 3. User Interface Design

### 3.1 Favorites Screen Layout

#### 3.1.1 Main Interface Structure
```
┌─────────────────────────────────────────────┐
│ My Favorites (24)                    [🔍]   │
│ [All] [Pinned] [Recent] [Tags]              │
│                                             │
│ 📌 PINNED FAVORITES (3 of 5)               │
│ ┌─────┐ ┌─────┐ ┌─────┐                   │
│ │🖼️   │ │🖼️   │ │🖼️   │                   │
│ │Meal1│ │Meal2│ │Meal3│                   │
│ └─────┘ └─────┘ └─────┘                   │
│                                             │
│ 🍳 BREAKFAST FAVORITES                      │
│ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐           │
│ │🖼️❤️ │ │🖼️❤️ │ │🖼️❤️ │ │🖼️❤️ │           │
│ │Name │ │Name │ │Name │ │Name │           │
│ └─────┘ └─────┘ └─────┘ └─────┘           │
│                                             │
│ 🥙 LUNCH FAVORITES                          │
│ ... (similar layout)                       │
└─────────────────────────────────────────────┘
```

### 3.2 Favorite Meal Card Design

#### 3.2.1 Enhanced Meal Card for Favorites
```dart
class FavoriteMealCard extends StatelessWidget {
  // Card Features:
  // - Larger heart icon (favorited state)
  // - Pin icon overlay (if pinned)
  // - Usage counter badge
  // - Last used date
  // - Quick action buttons (Add to Plan, Edit, Remove)
  // - Long press for bulk selection
}
```

### 3.3 Interactive Elements

#### 3.3.1 Quick Actions
- **Add to Current Plan**: Single tap to add to next available meal slot
- **Pin/Unpin**: Toggle priority status with visual feedback
- **Edit Meal**: Direct navigation to meal editor
- **Remove from Favorites**: With confirmation dialog
- **Share Recipe**: Export meal details (future feature)

#### 3.3.2 Bulk Operations
- Multi-select mode with checkboxes
- Bulk pin/unpin operations
- Bulk removal from favorites
- Batch export functionality

---

## 4. Technical Implementation

### 4.1 State Management

#### 4.1.1 Favorites Provider
```dart
@riverpod
class FavoriteMealsNotifier extends _$FavoriteMealsNotifier {
  @override
  Future<List<FavoriteMeal>> build() async {
    return _repository.getFavoriteMeals();
  }

  Future<void> toggleFavorite(String mealId) async {
    final meal = await _mealRepository.getMealById(mealId);
    
    if (meal.isFavorite) {
      await _removeFromFavorites(mealId);
    } else {
      await _addToFavorites(mealId);
    }
    
    // Refresh state
    ref.invalidateSelf();
  }

  Future<void> pinFavorite(String mealId) async {
    await _pinnedManager.pinFavorite(mealId);
    ref.invalidateSelf();
  }

  List<FavoriteMeal> getFilteredFavorites(FavoritesFilter filter) {
    return state.value?.where((meal) => _matchesFilter(meal, filter)).toList() ?? [];
  }
}
```

### 4.2 Analytics and Intelligence

#### 4.2.1 Usage Tracking
```dart
class FavoritesAnalytics {
  Future<void> trackUsage(String mealId) async {
    final usage = FavoriteUsage(
      mealId: mealId,
      usedAt: DateTime.now(),
      context: 'meal_plan_generation',
    );
    
    await _localDb.box<FavoriteUsage>().add(usage);
    
    // Update meal usage counter
    await _updateUsageCount(mealId);
  }

  Future<List<String>> getSuggestedFavorites() async {
    // Analyze user behavior to suggest new favorites
    final frequentlyUsed = await _getFrequentlyUsedMeals();
    final notYetFavorited = frequentlyUsed.where((meal) => !meal.isFavorite);
    
    return notYetFavorited.map((meal) => meal.id).toList();
  }
}
```

### 4.3 Data Storage

#### 4.3.1 Enhanced Storage Schema
```dart
@HiveType(typeId: 6)
class FavoriteMealHiveModel extends HiveObject {
  @HiveField(0)
  String mealId;
  
  @HiveField(1)
  DateTime favoritedAt;
  
  @HiveField(2)
  int usageCount;
  
  @HiveField(3)
  DateTime lastUsed;
  
  @HiveField(4)
  bool isPinned;
  
  @HiveField(5)
  List<String> userTags;
  
  @HiveField(6)
  double? userRating;
}

@HiveType(typeId: 7)
class FavoriteUsageHiveModel extends HiveObject {
  @HiveField(0)
  String mealId;
  
  @HiveField(1)
  DateTime usedAt;
  
  @HiveField(2)
  String context; // 'meal_plan', 'manual_add', etc.
}
```

---

## 5. Testing Requirements

### 5.1 Unit Tests
```dart
group('Favorites Management Tests', () {
  test('should add meal to favorites successfully', () async {
    final service = FavoritesService();
    await service.addToFavorites('meal_123');
    
    final favorites = await service.getFavorites();
    expect(favorites.any((m) => m.id == 'meal_123'), isTrue);
  });

  test('should enforce pin limit', () async {
    final manager = PinnedFavoritesManager();
    
    // Pin maximum allowed favorites
    for (int i = 0; i < 5; i++) {
      await manager.pinFavorite('meal_$i');
    }
    
    // Attempting to pin one more should fail
    expect(
      () => manager.pinFavorite('meal_6'),
      throwsA(isA<PinLimitExceededException>()),
    );
  });

  test('should filter favorites correctly', () {
    final favorites = [
      createTestFavorite(category: MealCategory.breakfast),
      createTestFavorite(category: MealCategory.lunch),
    ];
    
    final filter = FavoritesFilter(category: MealCategory.breakfast);
    final filtered = FavoritesService.applyFilter(favorites, filter);
    
    expect(filtered.length, equals(1));
    expect(filtered.first.category, equals(MealCategory.breakfast));
  });
});
```

### 5.2 Widget Tests
```dart
testWidgets('should toggle favorite status on heart tap', (tester) async {
  await tester.pumpWidget(createTestApp(
    child: FavoriteMealCard(meal: createTestMeal()),
  ));

  await tester.tap(find.byIcon(Icons.favorite_border));
  await tester.pumpAndSettle();

  verify(mockFavoritesService.toggleFavorite(any)).called(1);
});
```

---

## 6. Acceptance Criteria

### 6.1 Functional Requirements
- [ ] Users can favorite/unfavorite meals with heart icon
- [ ] Pinned favorites appear in 80% of generated plans
- [ ] Favorites screen shows all saved meals organized by category
- [ ] Search and filter functionality works accurately
- [ ] Usage analytics track meal popularity

### 6.2 Performance Requirements
- [ ] Favorites screen loads within 1 second
- [ ] Heart icon toggle responds immediately
- [ ] Search results appear within 500ms of typing
- [ ] Bulk operations complete without UI blocking

### 6.3 Usability Requirements
- [ ] Clear distinction between regular and pinned favorites
- [ ] Easy batch selection and operations
- [ ] Intuitive organization by meal categories
- [ ] Quick access to add favorites to meal plans

---

## 7. Dependencies & Future Enhancements

### 7.1 Dependencies
- Meal database and repository system
- Local storage (Hive) implementation
- Meal Plan Generation feature integration
- Search and filtering components

### 7.2 Future Enhancements
- **Smart Recommendations**: ML-based favorite suggestions
- **Social Features**: Share favorites with family/friends
- **Rating System**: 5-star rating for meal quality
- **Recipe Collections**: Organize favorites into themed collections
- **Seasonal Favorites**: Automatic suggestions based on time of year

This feature creates a personalized experience that learns from user preferences and makes meal planning more efficient over time.