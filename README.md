## FoodieGo – Flutter Food Ordering UI

FoodieGo is a production‑style Flutter food ordering UI built with GetX, Material 3, and fully local mock data.  
It showcases a polished splash → login → home flow with responsive layouts, rich theming, and animated cards for banners, categories, filters, and restaurant lists.

---

## Features

- **Animated splash experience**
  - Gradient background with branded logo.
  - Elastic scale + fade‑in animations.
  - Auto‑navigates to the login screen after a short delay.

- **Modern login screen**
  - Large hero logo and tagline over a gradient background.
  - Email/phone + password form with validation and inline error messages.
  - Password visibility toggle and “Forgot password?” action (snackbar).
  - Primary “Login” CTA with loading state and disabled while submitting.
  - Social/alt login buttons (Google, Apple, Guest) with press animations and individual loaders.
  - “Sign up” call to action (currently a placeholder snackbar).

- **Home screen experience**
  - **Top banner carousel**
    - Auto‑scrolling `PageView` of promotional banners (e.g., “Meals under ₹250”, “Biryani Fest Starts Today”).
    - Gradient backgrounds, subtle diagonal stripe painter, and rounded bottom corners.
    - Responsive layout with left‑aligned copy (headline, offer tag, CTA) and a rounded hero food image on the right.
    - Dot indicators bound to the active banner page.
  - **Location + quick actions bar**
    - Displays current location (“Thane – Mumbai, Maharashtra”).
    - Theme toggle (light/dark), profile, and logout icons over the banner.
    - Logout returns to the login screen.
  - **Search & veg filter row**
    - Floating search bar with mic icon, built with Material 3 text field styling.
    - “VEG” toggle pill with smooth animation and highlight when active.
  - **Category carousel**
    - Horizontally scrolling category list (All, Pizza, Biryani, Burger, Sushi, etc.).
    - Circular image avatars, selection border + glow, bold colored text, and an underline marker.
    - Single‑selection behavior, updated via GetX (`selectedCategory`).
  - **Filter chips**
    - Quick filters such as “Filters”, “Gourmet”, “Under ₹200”, “Schedule”, “Rating 4.0+”.
    - Multi‑select state stored in a reactive list (`selectedFilters`).
  - **Recommended restaurants**
    - Horizontal card list showing restaurant image, discount, rating, delivery info, and “₹X for two”.
    - Animated delivery label for “Near & Fast” vs delivery time.
    - Shimmer placeholders while loading.
  - **Explore more section**
    - Horizontal “Explore” tiles with imagery, icons, and gradient overlays.
    - Tap scale animation for each tile.
  - **Pull‑to‑refresh**
    - `RefreshIndicator` with a mocked delay and shimmer reload.

- **Light / dark theme support**
  - Central `ThemeController` with `ThemeMode` switching via GetX.
  - Theme toggle available on both the login and home banner top bars.

---

## Tech Stack

- **Framework**: Flutter (Dart `^3.10.8`)
- **Architecture**: Feature‑based + GetX for routing, DI, and state management
- **State Management**: GetX (`GetxController`, `Rx` types, `Obx`)
- **Navigation**: `GetMaterialApp` with named routes
- **Theming**:
  - Material 3 (`useMaterial3: true`)
  - `AppTheme` with `lightTheme` / `darkTheme` from `ColorScheme.fromSeed`
  - Central palette in `AppColors`
- **UI Libraries**:
  - `google_fonts` for typography (`Poppins`, `Inter`)
  - `shimmer` for skeleton placeholders
  - `cupertino_icons` for additional icons
- **Tooling / Dev Dependencies**:
  - `flutter_lints`
  - `flutter_launcher_icons`
  - `flutter_native_splash`

All data (banners, categories, restaurants, explore tiles) is local mock data – there is no backend or networking in this project.

---

## Project Structure

Key parts of the `lib/` folder:

- **Entry & core**
  - `main.dart` – App bootstrap:
    - Registers a global `ThemeController` with GetX.
    - Configures system UI overlays and supported orientations.
    - Builds `GetMaterialApp` with theming, routing, and initial route.
  - `core/routes/app_routes.dart` – String route constants for `/splash`, `/login`, `/home`.
  - `core/routes/app_pages.dart` – `GetPage` list with bindings for `LoginController` and `HomeController`.
  - `core/theme/app_theme.dart` – Light and dark `ThemeData`.
  - `core/theme/app_colors.dart` – Color palette and gradients.
  - `core/theme/theme_controller.dart` – GetX controller exposing `themeMode` and `toggleTheme()`.
  - `core/constants/app_assets.dart` – Central asset path definitions for images/logos.
  - `core/utils/screen.dart` – `ScreenExt` responsive helpers:
    - `sw`, `sh` – screen width/height.
    - `hPad`, `sectionGap`, `spacing(t)` – responsive paddings and vertical rhythm.
    - Component sizing helpers: `foodCardWidth`, `recommendedHeight`, `bannerHeight`, `searchBarHeight`, `categoryRowHeight`, `categoryAvatarSize`, `exploreTileWidth/Height`, `radiusSheet`.

- **Features**
  - `features/splash/`
    - `splash_screen.dart` – Animated splash and timed navigation to login.
  - `features/login/`
    - `login_screen.dart` – Login UI, social buttons, theming toggle.
    - `login_controller.dart` – Form state, validation, mock login logic.
  - `features/home/`
    - `home_screen.dart` – Home layout composing banner, categories, filters, recommended, and explore sections.
    - `home_controller.dart` – Seeds mock banners/categories/restaurants/explore items and manages UI state.
    - `home_model.dart` – Data models for `FoodCategory`, `Restaurant`, `BannerItem`, `ExploreItem`.
    - `widgets/home_banner_section.dart` – Top banner carousel + overlays.
    - `widgets/home_feed_sections.dart` – Categories strip, filters row, recommended and explore strips.
    - `widgets/category_item.dart` – Circular category tile with selection.
    - `widgets/food_card.dart` – Restaurant card UI with discount/rating/delivery layout.

- **Shared widgets**
  - `widgets/app_scaffold_background.dart` – App‑wide gradient background wrapper.
  - `widgets/custom_textfield.dart` – Styled text field.
  - `widgets/custom_button.dart` – Primary CTA button with loading state.

Assets (declared in `pubspec.yaml` and referenced via `AppAssets`):

- `assets/login/` – Logo and provider icons (`logo.png`, `google.png`, `apple.png`, `guest.jpg`).
- `assets/images/` – Food photography for categories, restaurants, and explore tiles.
- `assets/landing/` – Reserved for future landing/onboarding visuals.

---

## App Flow

1. **App start**
   - `main.dart` registers the global `ThemeController` and builds `FoodieGoApp`.
   - `GetMaterialApp` uses `AppRoutes.splash` as the `initialRoute`.

2. **Splash → Login**
   - `SplashScreen` plays its intro animation and navigates to login via `Get.offAllNamed(AppRoutes.login)`.

3. **Login → Home**
   - `LoginScreen` uses `LoginController` from GetX.
   - On mock login/social/guest actions, it navigates with `Get.offAllNamed(AppRoutes.home)`.

4. **Home**
   - `HomeController` is instantiated via route binding when navigating to `/home`.
   - The controller initializes the banner carousel (auto‑scroll), seeds mock data, and toggles loading.

---

## Running the App

From the project root (`food_ordering_app`):

```bash
flutter pub get
flutter run
```

Typical targets:

- **Android** – any emulator or physical device.
- **iOS** – macOS + Xcode; run `flutter run -d ios`.

---

## Native Icons & Splash

- **Launcher icon**
  - Configured via `flutter_launcher_icons` using `assets/login/logo.png`.
  - Regenerate icons:
    ```bash
    flutter pub run flutter_launcher_icons
    ```

- **Native splash screen**
  - Configured via `flutter_native_splash` with an orange background and the same logo.
  - Regenerate splash assets:
    ```bash
    dart run flutter_native_splash:create
    ```

