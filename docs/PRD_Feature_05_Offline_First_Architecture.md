# PRD Feature 05: Offline-First Architecture

## 1. Feature Overview

### 1.1 Description
Ensures complete application functionality without internet connectivity through robust local data storage, cached resources, and intelligent data management strategies.

### 1.2 Business Value
- **Reliability**: App works anywhere, anytime without network dependency
- **Performance**: Instant data access from local storage
- **Privacy**: No data transmission to external servers
- **Accessibility**: Serves users in areas with limited internet connectivity

### 1.3 Success Metrics
- 100% core functionality available offline
- App startup time < 2 seconds without network
- Zero data loss during offline operations
- Local storage size < 100MB for standard usage

---

## 2. Core Technical Requirements

### 2.1 Local Storage Architecture

#### 2.1.1 Database Selection and Setup
```dart
class DatabaseManager {
  static late Box<MealHiveModel> mealsBox;
  static late Box<MealPlanHiveModel> mealPlansBox;
  static late Box<ShoppingListHiveModel> shoppingListsBox;
  static late Box<FavoriteMealHiveModel> favoritesBox;
  static late Box<UserPreferencesHiveModel> preferencesBox;

  static Future<void> initialize() async {
    // Initialize Hive
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(MealHiveModelAdapter());
    Hive.registerAdapter(MealPlanHiveModelAdapter());
    Hive.registerAdapter(ShoppingListHiveModelAdapter());
    Hive.registerAdapter(FavoriteMealHiveModelAdapter());
    
    // Open boxes
    mealsBox = await Hive.openBox<MealHiveModel>('meals');
    mealPlansBox = await Hive.openBox<MealPlanHiveModel>('meal_plans');
    shoppingListsBox = await Hive.openBox<ShoppingListHiveModel>('shopping_lists');
    favoritesBox = await Hive.openBox<FavoriteMealHiveModel>('favorites');
    preferencesBox = await Hive.openBox<UserPreferencesHiveModel>('preferences');
  }
}
```

#### 2.1.2 Storage Collections Structure
```dart
// Core Data Collections
enum StorageCollection {
  meals,           // All available meals (pre-loaded + custom)
  mealPlans,       // Generated and saved meal plans
  shoppingLists,   // Generated shopping lists
  favorites,       // User's favorite meals
  preferences,     // App settings and user preferences
  analytics,       // Local usage analytics
  cache,          // Temporary cached data
}
```

### 2.2 Data Models for Storage

#### 2.2.1 Hive Data Models
```dart
@HiveType(typeId: 0)
class MealHiveModel extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) String description;
  @HiveField(3) List<IngredientHiveModel> ingredients;
  @HiveField(4) int category; // MealCategory enum index
  @HiveField(5) int calories;
  @HiveField(6) int prepTimeMinutes;
  @HiveField(7) int difficulty; // DifficultyLevel enum index
  @HiveField(8) List<int> dietaryTags; // DietaryTag enum indices
  @HiveField(9) String? imageAssetPath;
  @HiveField(10) String? cookingInstructions;
  @HiveField(11) int defaultServings;
  @HiveField(12) DateTime createdAt;
  @HiveField(13) bool isFavorite;
  @HiveField(14) bool isCustom;
  @HiveField(15) Map<String, dynamic>? metadata; // Extensible data
}

@HiveType(typeId: 1)
class IngredientHiveModel {
  @HiveField(0) String name;
  @HiveField(1) double quantity;
  @HiveField(2) String unit;
  @HiveField(3) int foodCategory; // FoodCategory enum index
  @HiveField(4) bool isOptional;
}
```

### 2.3 Initial Data Population

#### 2.3.1 Starter Meal Database
```dart
class DatabaseSeeder {
  static Future<void> seedInitialData() async {
    if (DatabaseManager.mealsBox.isEmpty) {
      await _loadStarterMeals();
      await _loadDefaultPreferences();
      await _createSampleData();
    }
  }

  static Future<void> _loadStarterMeals() async {
    final starterMeals = await _parseStarterMealsJson();
    
    for (final mealData in starterMeals) {
      final meal = MealHiveModel.fromJson(mealData);
      await DatabaseManager.mealsBox.add(meal);
    }
    
    print('Loaded ${starterMeals.length} starter meals');
  }
}
```

#### 2.3.2 Pre-loaded Content Strategy
- **50+ Starter Meals**: Balanced across all categories (breakfast, lunch, dinner, snacks)
- **Recipe Images**: Compressed local assets (WebP format, <50KB each)
- **Ingredient Database**: 200+ common ingredients with nutritional data
- **Default Preferences**: Sensible defaults for meal generation parameters

### 2.4 Data Synchronization Strategy

#### 2.4.1 Conflict Resolution (Future Enhancement)
```dart
class DataSyncManager {
  Future<void> resolveConflicts(List<DataConflict> conflicts) async {
    for (final conflict in conflicts) {
      switch (conflict.resolution) {
        case ConflictResolution.keepLocal:
          await _keepLocalVersion(conflict);
          break;
        case ConflictResolution.keepRemote:
          await _acceptRemoteVersion(conflict);
          break;
        case ConflictResolution.merge:
          await _mergeVersions(conflict);
          break;
      }
    }
  }
}
```

---

## 3. Performance Optimization

### 3.1 Lazy Loading Strategy

#### 3.1.1 Efficient Data Loading
```dart
class LazyMealRepository implements MealRepository {
  final Map<String, Meal> _cache = {};
  
  @override
  Future<Meal?> getMealById(String id) async {
    // Check in-memory cache first
    if (_cache.containsKey(id)) {
      return _cache[id];
    }
    
    // Load from Hive
    final hiveModel = DatabaseManager.mealsBox.values
        .firstWhereOrNull((meal) => meal.id == id);
    
    if (hiveModel != null) {
      final meal = _convertToMeal(hiveModel);
      _cache[id] = meal; // Cache for future access
      return meal;
    }
    
    return null;
  }
}
```

### 3.2 Image Caching System

#### 3.2.1 Local Image Management
```dart
class ImageCacheManager {
  static final Map<String, Uint8List> _imageCache = {};
  static const int maxCacheSize = 50; // Images in memory
  
  static Future<Uint8List?> getImage(String assetPath) async {
    if (_imageCache.containsKey(assetPath)) {
      return _imageCache[assetPath];
    }
    
    try {
      final bytes = await rootBundle.load(assetPath);
      final uint8List = bytes.buffer.asUint8List();
      
      // Cache management
      if (_imageCache.length >= maxCacheSize) {
        _evictLeastRecentlyUsed();
      }
      
      _imageCache[assetPath] = uint8List;
      return uint8List;
    } catch (e) {
      print('Error loading image $assetPath: $e');
      return null;
    }
  }
}
```

### 3.3 Database Optimization

#### 3.3.1 Query Optimization
```dart
class OptimizedQueries {
  // Index frequently queried fields
  static Future<List<Meal>> getMealsByCategory(MealCategory category) async {
    final categoryIndex = category.index;
    
    // Use Hive's efficient filtering
    final filtered = DatabaseManager.mealsBox.values
        .where((meal) => meal.category == categoryIndex)
        .toList();
    
    return filtered.map(_convertToMeal).toList();
  }
  
  // Batch operations for better performance
  static Future<void> saveMeals(List<Meal> meals) async {
    final hiveModels = meals.map(_convertToHiveModel).toList();
    await DatabaseManager.mealsBox.addAll(hiveModels);
  }
}
```

---

## 4. Backup and Recovery System

### 4.1 Data Export/Import

#### 4.1.1 Backup Implementation
```dart
class BackupService {
  static Future<String> exportUserData() async {
    final exportData = {
      'version': '1.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'meals': DatabaseManager.mealsBox.values
          .where((meal) => meal.isCustom)
          .map((meal) => meal.toJson())
          .toList(),
      'favorites': DatabaseManager.favoritesBox.values
          .map((fav) => fav.toJson())
          .toList(),
      'preferences': DatabaseManager.preferencesBox.values
          .map((pref) => pref.toJson())
          .toList(),
    };
    
    return jsonEncode(exportData);
  }
  
  static Future<bool> importUserData(String jsonData) async {
    try {
      final data = jsonDecode(jsonData);
      
      // Validate format and version
      if (!_validateImportData(data)) {
        throw FormatException('Invalid backup format');
      }
      
      // Import meals
      for (final mealData in data['meals']) {
        final meal = MealHiveModel.fromJson(mealData);
        await DatabaseManager.mealsBox.add(meal);
      }
      
      // Import favorites
      for (final favData in data['favorites']) {
        final favorite = FavoriteMealHiveModel.fromJson(favData);
        await DatabaseManager.favoritesBox.add(favorite);
      }
      
      return true;
    } catch (e) {
      print('Import failed: $e');
      return false;
    }
  }
}
```

### 4.2 Data Integrity and Validation

#### 4.2.1 Corruption Detection and Recovery
```dart
class DataIntegrityService {
  static Future<bool> validateDatabase() async {
    try {
      // Check box accessibility
      await DatabaseManager.mealsBox.length;
      await DatabaseManager.mealPlansBox.length;
      
      // Validate data structure
      final testMeal = DatabaseManager.mealsBox.values.firstOrNull;
      if (testMeal != null) {
        // Attempt to access all fields
        _ = testMeal.id;
        _ = testMeal.name;
        _ = testMeal.ingredients;
      }
      
      return true;
    } catch (e) {
      print('Database validation failed: $e');
      return false;
    }
  }
  
  static Future<void> repairDatabase() async {
    // Attempt to recover corrupted data
    try {
      await DatabaseManager.initialize();
      
      // Re-seed if completely corrupted
      if (DatabaseManager.mealsBox.isEmpty) {
        await DatabaseSeeder.seedInitialData();
      }
    } catch (e) {
      // Last resort: clear and re-initialize
      await _clearAndReinitialize();
    }
  }
}
```

---

## 5. Offline Indicators and User Experience

### 5.1 Connection Status Management

#### 5.1.1 Network Awareness
```dart
class NetworkStatusService extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;
  
  NetworkStatusService() {
    _initializeNetworkListener();
  }
  
  void _initializeNetworkListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      final wasOnline = _isOnline;
      _isOnline = result != ConnectivityResult.none;
      
      if (wasOnline != _isOnline) {
        notifyListeners();
        _showNetworkStatusChange();
      }
    });
  }
  
  void _showNetworkStatusChange() {
    final message = _isOnline ? 'Back online' : 'Working offline';
    _showSnackbar(message);
  }
}
```

### 5.2 Offline UI Adaptations

#### 5.2.1 Feature Availability Indicators
```dart
class OfflineAwareWidget extends ConsumerWidget {
  const OfflineAwareWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(networkStatusProvider);
    
    return Column(
      children: [
        if (!isOnline)
          Container(
            color: Colors.amber,
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(Icons.offline_bolt),
                SizedBox(width: 8),
                Text('Working offline - all features available'),
              ],
            ),
          ),
        // Rest of the UI
      ],
    );
  }
}
```

---

## 6. Storage Management and Cleanup

### 6.1 Storage Optimization

#### 6.1.1 Automated Cleanup
```dart
class StorageCleanupService {
  static Future<void> performCleanup() async {
    await _cleanupOldMealPlans();
    await _cleanupOldShoppingLists();
    await _optimizeImageCache();
    await _compactDatabase();
  }
  
  static Future<void> _cleanupOldMealPlans() async {
    final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
    
    final oldPlans = DatabaseManager.mealPlansBox.values
        .where((plan) => plan.generatedAt.isBefore(thirtyDaysAgo))
        .toList();
    
    for (final plan in oldPlans) {
      await plan.delete();
    }
    
    print('Cleaned up ${oldPlans.length} old meal plans');
  }
}
```

### 6.2 Storage Monitoring

#### 6.2.1 Usage Analytics
```dart
class StorageAnalytics {
  static Future<StorageStats> getStorageStats() async {
    final stats = StorageStats();
    
    stats.totalMeals = DatabaseManager.mealsBox.length;
    stats.customMeals = DatabaseManager.mealsBox.values
        .where((meal) => meal.isCustom).length;
    stats.favoriteMeals = DatabaseManager.favoritesBox.length;
    stats.savedPlans = DatabaseManager.mealPlansBox.length;
    
    // Calculate storage sizes
    stats.estimatedSizeBytes = await _calculateStorageSize();
    
    return stats;
  }
}
```

---

## 7. Testing Requirements

### 7.1 Unit Tests

#### 7.1.1 Database Operations Testing
```dart
group('Database Operations Tests', () {
  setUp(() async {
    await DatabaseManager.initialize();
  });
  
  tearDown(() async {
    await DatabaseManager.mealsBox.clear();
    await DatabaseManager.mealPlansBox.clear();
  });
  
  test('should save and retrieve meals correctly', () async {
    final meal = createTestMealHiveModel();
    await DatabaseManager.mealsBox.add(meal);
    
    final retrieved = DatabaseManager.mealsBox.values.first;
    expect(retrieved.id, equals(meal.id));
    expect(retrieved.name, equals(meal.name));
  });
  
  test('should handle database corruption gracefully', () async {
    // Simulate corruption
    await DatabaseManager.mealsBox.close();
    
    // Should recover without crashing
    final isValid = await DataIntegrityService.validateDatabase();
    expect(() => DataIntegrityService.repairDatabase(), returnsNormally);
  });
});
```

### 7.2 Integration Tests

#### 7.2.1 Offline Functionality Tests
```dart
testWidgets('app works completely offline', (tester) async {
  // Simulate offline state
  await tester.binding.defaultBinaryMessenger
      .setMockMethodCallHandler(connectivity.channel, (call) async {
    return 'none';
  });
  
  await tester.pumpWidget(MyApp());
  
  // Test core functionality
  await tester.tap(find.byKey(Key('generate_plan_button')));
  await tester.pumpAndSettle();
  
  expect(find.byType(MealPlanScreen), findsOneWidget);
  
  // Test meal customization
  await tester.tap(find.byType(MealCard).first);
  await tester.pumpAndSettle();
  
  expect(find.byType(ReplacementModal), findsOneWidget);
});
```

---

## 8. Acceptance Criteria

### 8.1 Functional Requirements
- [ ] App launches and functions completely without internet connection
- [ ] All core features (generation, customization, favorites, shopping lists) work offline
- [ ] Data persists across app restarts and device reboots
- [ ] Backup and restore functionality works correctly
- [ ] Database corruption is detected and recovered automatically

### 8.2 Performance Requirements
- [ ] App startup time < 2 seconds in offline mode
- [ ] Database operations complete within 100ms
- [ ] Storage size stays under 100MB for typical usage
- [ ] Memory usage remains efficient during extended offline use

### 8.3 Reliability Requirements
- [ ] Zero data loss during normal operations
- [ ] Graceful degradation when storage is full
- [ ] Automatic recovery from database corruption
- [ ] Consistent data state across all app features

---

## 9. Dependencies & Future Enhancements

### 9.1 Dependencies
- **Hive Database**: Local NoSQL storage
- **Path Provider**: File system access
- **Connectivity**: Network status monitoring
- **Shared Preferences**: Simple key-value storage

### 9.2 Future Enhancements
- **Cloud Sync**: Optional cloud backup with conflict resolution
- **P2P Sharing**: Share meals between devices via local network
- **Advanced Analytics**: Detailed usage patterns and insights
- **Encrypted Storage**: Optional encryption for sensitive data
- **Multi-Device Support**: Sync data across multiple devices

This offline-first architecture ensures the app provides reliable, fast, and private meal planning functionality regardless of network conditions, making it truly accessible to all users.