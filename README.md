# Meal Generator Planner

A cross-platform Flutter application that helps households easily generate and customize meal plans, and produce shopping lists without requiring logins or sensitive data.

## 🚀 Features

- **Meal Plan Generation**: Automatically generate balanced weekly meal plans
- **Manual Customization**: Swap and customize meals according to preferences
- **Shopping List Generation**: Auto-generate organized shopping lists from meal plans
- **Favorites Management**: Save and manage favorite meals for quick access
- **Offline-First Architecture**: Works completely offline with local data storage

## 🏗️ Architecture

This project follows a clean architecture pattern with:

- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Local Storage**: Hive (offline-first, lightweight NoSQL)
- **Routing**: GoRouter
- **Testing**: Flutter Test + Mockito

## 📁 Project Structure

```
lib/
 ├── core/        # Constants, themes, utilities
 ├── data/        # Data models, repositories
 ├── providers/   # State management with Riverpod
 ├── features/    # Feature-specific modules
 │    ├── meal_plan/
 │    ├── shopping_list/
 │    ├── favorites/
 ├── widgets/     # Shared UI components
```

## 🎯 Target Platforms

- **Android APK**: Native Android application
- **Web PWA**: Progressive Web Application for browsers

## 📖 Documentation

Detailed feature documentation is available in the `docs/` directory:

- [Main PRD](docs/PRD_Meal_Generator_Planner.md)
- [Meal Plan Generation](docs/PRD_Feature_01_Meal_Plan_Generation.md)
- [Manual Customization](docs/PRD_Feature_02_Manual_Customization.md)
- [Shopping List Generation](docs/PRD_Feature_03_Shopping_List_Generation.md)
- [Favorites Management](docs/PRD_Feature_04_Favorites_Management.md)
- [Offline-First Architecture](docs/PRD_Feature_05_Offline_First_Architecture.md)

## 🛠️ Development Setup

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio (for Android development)
- VS Code or your preferred IDE

### Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/meal-generator-planner.git
   cd meal-generator-planner
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   # For development
   flutter run
   
   # For web
   flutter run -d web
   
   # For Android
   flutter run -d android
   ```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## 🎨 Design Principles

- **Simplicity**: Large, simple buttons with minimal input required
- **Accessibility**: Support for larger fonts and screen readers
- **Performance**: Generate meal plans in under 1 second
- **Offline-First**: All functionality works without internet connection

## 🚀 Deployment

- **Web**: Firebase Hosting
- **Android**: Google Play Store
- **CI/CD**: GitHub Actions

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🎯 Roadmap

- API integration for dynamic recipes
- Family account sync
- Export as PDF/Excel
- Notifications for meal prep reminders