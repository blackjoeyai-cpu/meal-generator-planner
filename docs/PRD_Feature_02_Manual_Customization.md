# PRD Feature 02: Manual Customization

## 1. Feature Overview

### 1.1 Description
Enables users to modify generated meal plans by swapping meals, editing meal details, creating custom meals, and organizing plans through intuitive interactions.

### 1.2 Success Metrics
- 75% of users customize at least one meal per plan
- Average customization time < 30 seconds per swap
- 90% of custom meals reused in future plans

---

## 2. Core Functional Requirements

### 2.1 Meal Replacement System

#### 2.1.1 Replacement Options
When user taps a meal card, present modal with:

1. **Suggested Alternatives** (6-8 similar meals)
2. **Browse All Meals** (searchable catalog)
3. **Favorites Collection** (user's saved meals)
4. **Create New Custom Meal**
5. **Skip This Meal** (empty slot option)

#### 2.1.2 Data Models
```dart
class MealReplacementRequest {
  final String currentMealId;
  final MealSlot targetSlot;
  final ReplacementCriteria criteria;
}

enum ReplacementTrigger {
  tapMealCard, longPress, dragDrop, editButton
}
```

### 2.2 Meal Editing System

#### 2.2.1 Editable Fields
```dart
class MealEditForm {
  String name;                    // Max 50 chars
  String description;             // Max 200 chars
  MealCategory category;
  List<Ingredient> ingredients;   // Min 1 required
  int estimatedCalories;         // 50-2000 range
  int preparationTime;           // 5-480 minutes
  DifficultyLevel difficulty;
  List<DietaryTag> dietaryTags;
  File? image;
  String cookingInstructions;
  int servingSize;               // 1-10 people
}
```

#### 2.2.2 Ingredient Management
- Dynamic ingredient list with add/remove
- Auto-complete from ingredient database
- Drag-to-reorder functionality
- Quantity and unit selection

### 2.3 Custom Meal Creation

#### 2.3.1 Creation Workflow
```
Enter Basic Info → Add Ingredients → Optional Details → Validate → Save Options
```

#### 2.3.2 Validation Rules
- Name: 3-50 characters, unique within user meals
- Category: Must select valid category
- Ingredients: Minimum 1 non-optional ingredient
- Calories: 50-2000 reasonable range

### 2.4 Drag & Drop System

#### 2.4.1 Platform Implementation
- **Mobile**: Long press + drag with haptic feedback
- **Desktop**: Standard drag & drop with hover states
- **Visual Feedback**: Green/red zones, animations

#### 2.4.2 Drag Rules
```dart
class DragDropRules {
  static bool canMoveToSlot(Meal meal, MealSlot target) {
    return meal.category == target.expectedCategory &&
           !target.date.isAfter(DateTime.now().add(Duration(days: 7)));
  }
}
```

---

## 3. Technical Implementation

### 3.1 State Management
```dart
@riverpod
class MealPlanCustomization extends _$MealPlanCustomization {
  Future<void> replaceMeal(MealSlot slot, Meal newMeal) async {
    state = state.replaceMealInSlot(slot, newMeal);
    await _autoSave();
  }

  Future<void> moveMeal(MealSlot from, MealSlot to) async {
    if (!DragDropRules.canMoveToSlot(from.meal, to)) {
      throw InvalidMoveException();
    }
    state = state.moveMeal(from, to);
    await _autoSave();
  }
}
```

### 3.2 Data Persistence
- Auto-save every 2 seconds after changes
- Local Hive database storage
- Change tracking for undo functionality
- Optimistic UI updates with rollback on failure

---

## 4. User Interface Specifications

### 4.1 Meal Card Design
**Standard Card (280x120px)**
- Meal image (80x80px)
- Name, prep time, calories
- Favorite heart icon
- Context menu (⋮)
- Action buttons: Replace, Edit, Info

### 4.2 Replacement Modal
**Layout Sections:**
- Header with original meal info
- Tab navigation (Suggested, Browse, Favorites, Create)
- Content area with meal grid
- Action buttons (Cancel, Select)

### 4.3 Meal Editor Form
**Mobile Layout:**
- Photo upload section
- Basic info fields (name, category)
- Dynamic ingredients list
- Optional details (calories, prep time, difficulty)
- Rich text cooking instructions
- Save options (Save, Save & Use)

---

## 5. Testing Requirements

### 5.1 Unit Tests
- Meal replacement logic validation
- Custom meal creation with edge cases
- Drag & drop rule enforcement
- Data persistence and retrieval

### 5.2 Widget Tests
- Meal card interactions
- Form validation behavior
- Modal presentations
- Drag & drop gestures

### 5.3 Integration Tests
- End-to-end replacement workflow
- Custom meal creation and usage
- Cross-feature data consistency

---

## 6. Acceptance Criteria

### 6.1 Functional Requirements
- [ ] Tap meal card shows replacement options
- [ ] All meal details are editable
- [ ] Custom meals can be created and reused
- [ ] Drag & drop works across platforms
- [ ] Changes auto-save within 2 seconds

### 6.2 Performance Requirements
- [ ] Replacement modal opens < 300ms
- [ ] Drag operations maintain 60fps
- [ ] Form validation in real-time
- [ ] Auto-save doesn't block UI

### 6.3 Usability Requirements
- [ ] 44px minimum touch targets
- [ ] Clear error messages with guidance
- [ ] Undo functionality available
- [ ] Keyboard navigation support

---

## 7. Dependencies & Future Enhancements

### 7.1 Dependencies
- Image processing library
- File picker for photos
- Auto-complete component
- Meal Plan Generation feature

### 7.2 Future Features
- Meal templates and batch editing
- Recipe import from websites
- ML-powered suggestions
- Collaborative family editing

This feature transforms the app from simple generation to personalized meal planning that adapts to individual preferences.