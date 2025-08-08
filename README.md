# Task App (Flutter)

A Flutter application demonstrating clean architecture (data, domain, presentation), dependency injection (get_it), Bloc/Cubit state management, networking (Dio), local caching (Hive), and secure local auth (flutter_secure_storage).

## Prerequisites
- Flutter SDK (3.7+)
- Dart SDK (bundled with Flutter)
- Android Studio or VS Code (with Flutter/Dart plugins)
- For iOS builds: Xcode on macOS

## Tech Stack
- State management: flutter_bloc
- DI: get_it
- Network: dio
- Caching: hive, hive_flutter (+ code gen adapters)
- Secure storage: flutter_secure_storage

## Project Structure (Clean Architecture)
- `lib/features/<feature>/data`: models, data sources, repositories (impl)
- `lib/features/<feature>/domain`: entities, repository contracts, use cases
- `lib/features/<feature>/presentation`: cubits/states, screens, widgets
- `lib/core`: DI, routing, network/storage helpers

## Features
- Splash: checks secure storage for stored credentials and routes to Login or Category
- Auth: local login (any non-empty email/password) saved securely
- Category: fetches categories from FakeStore API
- Product List: fetches products with search filtering
- Product Details: fetches product by id; details cached locally by id

## First-time Setup
1) Fetch dependencies
```
flutter pub get
```

2) Generate Hive adapters (required for product caching)
```
flutter pub run build_runner build --delete-conflicting-outputs
```

3) Platform notes
- Android: ensure `minSdkVersion` >= 21 (flutter_secure_storage requirement)
- iOS/macOS: do a full build from scratch on first run so plugins register properly

## Running the App
- Debug run on a device/emulator:
```
flutter run
```
- Select a device when prompted, or specify:
```
flutter run -d chrome   # web
flutter run -d android  # android
flutter run -d ios      # iOS (macOS only)
```

## Usage
- Splash screen will auto-navigate based on auth state
- Login: enter any non-empty email/password
- Category screen: lists categories
- Products screen: lists products; use the search bar to filter
- Product details: open a product to view details; details are cached by id
- Logout: open drawer in category and tap Logout

## Routing
- Defined in `lib/core/routing/routes.dart` and wired in `lib/core/routing/app_router.dart`
- Key routes:
  - `/` (SplashScreen)
  - `/login` (LoginScreen)
  - `/CategoryScreen` (CategoryScreen)
  - `/products` (ProductScreen)
  - `Routes.productDetailsScreen` (ProductDetailsScreen via named push with product id)

## Troubleshooting
- MissingPluginException (e.g., flutter_secure_storage):
  - Ensure app starts with plugin initialization: `WidgetsFlutterBinding.ensureInitialized()` (already added)
  - Do a full clean rebuild:
```
flutter clean
flutter pub get
flutter run
```
- Hive adapter errors (.g.dart not found): re-run code generation
```
flutter pub run build_runner build --delete-conflicting-outputs
```

## Scripts Cheat Sheet
```
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter clean && flutter pub get && flutter run
```

## Notes
- The local login is for demo purposes only; no real backend auth.
- Product list and details are served by `https://fakestoreapi.com`.
