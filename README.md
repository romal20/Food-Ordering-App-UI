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
    - Circular image avatars, selected border + glow, bold colored text, and underline marker.
    - Single‑selection behavior, updated via GetX (`selectedCategory`).
  - **Filter chips**
    - Quick filters such as “Filters”, “Gourmet”, “Under ₹200”, “Schedule”, “Rating 4.0+”.
    - Multi‑select state stored in a reactive list (`selectedFilters`).
  - **Recommended restaurants**
    - Horizontal card list showing:
      - Cover image with discount ribbon and optional “Near & Fast” badge.
      - Name, cuisine, rating, delivery time, delivery fee/“FREE”, and “₹X for two” labels.
    - Animated toggle between “Near & Fast” and the delivery time for certain restaurants.
    - Shimmer placeholders while data is “loading”.
  - **Explore more section**
    - Horizontal “Explore” tiles (“Gourmet”, “Plan a party”, “Collections”, etc.) with imagery, icons and gradients.
    - Tap scale animation for each tile (UI only, no deeper navigation yet).
  - **Pull‑to‑refresh**
    - `RefreshIndicator` on the main scroll view with a mocked delay and shimmer reload.

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
  - `flutter_lints` for static analysis
  - `flutter_launcher_icons` for app icon generation
  - `flutter_native_splash` for native splash screens

All data (banners, categories, restaurants, explore tiles) is local mock data – there is no backend or networking in this project.

---

## Project Structure

Key parts of the `lib/` folder:

- **Entry & core**
  - `main.dart` – App bootstrap:
    - Registers a global `ThemeController` with GetX.
    - Configures system UI overlays and supported orientations.
    - Builds `GetMaterialApp` with theming, routing, and initial route.
  - `core/routes/app_routes.dart` – String constants for `/splash`, `/login`, `/home`.
  - `core/routes/app_pages.dart` – `GetPage` list with bindings for `LoginController` and `HomeController`.
  - `core/theme/app_theme.dart` – Light and dark `ThemeData` definitions.
  - `core/theme/app_colors.dart` – Color palette and gradients used across the app.
  - `core/theme/theme_controller.dart` – GetX controller exposing `themeMode` and `toggleTheme()`.
  - `core/constants/app_assets.dart` – Central asset path definitions for all images and logos.
  - `core/utils/screen.dart` – `ScreenExt` extension on `BuildContext` providing:
    - `sw`, `sh` – screen width/height.
    - `hPad`, `sectionGap`, `spacing(t)` – responsive paddings and vertical rhythm.
    - Component helpers: `foodCardWidth`, `recommendedHeight`, `bannerHeight`,
      `searchBarHeight`, `categoryRowHeight`, `categoryAvatarSize`,
      `exploreTileWidth/Height`, etc.

- **Features**
  - `features/splash/`
    - `splash_screen.dart` – Animated splash and timed navigation to login.
  - `features/login/`
    - `login_screen.dart` – Login UI, social buttons, theming toggle.
    - `login_controller.dart` – Form state, validation, mock login logic.
  - `features/home/`
    - `home_screen.dart` – Home layout (`CustomScrollView` + slivers) composing all sections.
    - `home_controller.dart` – Seeds mock banners, categories, restaurants, explore items;
      manages banner auto‑scroll, veg toggle, filter selection, and refresh behavior.
    - `home_model.dart` – Data models for `FoodCategory`, `Restaurant`, `BannerItem`, `ExploreItem`.
    - `widgets/home_banner_section.dart` – Top banner carousel, top bar, and floating search row.
    - `widgets/home_feed_sections.dart` – Category strip, filters row, recommended and explore sections.
    - `widgets/category_item.dart` – Circular category tile with selection, scale animation, and underline.
    - `widgets/food_card.dart` – Restaurant card with image, discount, rating, delivery info, and shimmer variants.

- **Shared widgets**
  - `widgets/app_scaffold_background.dart` – App‑wide gradient background wrapper.
  - `widgets/custom_textfield.dart` – Styled form field with icons and validation integration.
  - `widgets/custom_button.dart` – Primary button with loading and icon support.

Assets (declared in `pubspec.yaml` and referenced via `AppAssets`):

- `assets/login/` – Logo and provider icons (`logo.png`, `google.png`, `apple.png`, `guest.jpg`).
- `assets/images/` – Food photography for categories, restaurants, and explore tiles
  (pizza, burger, biryani, Indian thali, food spread, sushi, dessert, Chinese, party, offers, etc.).
- `assets/landing/` – Reserved for future landing/onboarding visuals.

---

## App Flow

1. **App start**
   - `main.dart` configures the global `ThemeController` and builds `FoodieGoApp`.
   - `GetMaterialApp` uses `AppRoutes.splash` as the `initialRoute`.

2. **Splash → Login**
   - `SplashScreen` plays its intro animation and, after a short delay, calls
     `Get.offAllNamed(AppRoutes.login)`.

3. **Login → Home**
   - `LoginScreen` obtains `LoginController` from GetX.
   - On successful (mock) login or guest/social selection, it navigates with
     `Get.offAllNamed(AppRoutes.home)`.

4. **Home**
   - `HomeController` is created via a route binding when navigating to `/home`.
   - On `onInit`, it:
     - Creates a `PageController` for the banner carousel and starts auto‑scrolling.
     - Seeds all mock data after a delay and sets `isLoading` to false.
     - Starts a timer to animate “Near & Fast” vs delivery time labels.
   - `HomeScreen` uses `Obx` builders to react to controller state for:
     - Selected category.
     - Selected filters.
     - Veg‑only toggle.
     - Current banner page.
     - Loading vs loaded restaurant lists.

---

## Running the App

From the project root (`food_ordering_app`):

```bash
flutter pub get
flutter run
```

This will launch the app on the default connected device/emulator.

Typical targets:

- **Android** – Any emulator or physical device supported by your Flutter SDK.
- **iOS** – Requires macOS + Xcode; run `flutter run -d ios` or open the `ios` project in Xcode.

> The project is UI‑only and uses local mock data; no backend configuration is required.

---

## Native Icons & Splash

- **Launcher icon**
  - Configured via `flutter_launcher_icons` to use `assets/login/logo.png` for Android and iOS.
  - To regenerate after changing the logo:
    ```bash
    flutter pub run flutter_launcher_icons
    ```

- **Native splash screen**
  - Configured via `flutter_native_splash` with an orange background and the same logo.
  - To regenerate platform splash assets:
    ```bash
    dart run flutter_native_splash:create
    ```

---

## Notes & Limitations

- **No real backend**
  - All categories, restaurants, banners, and explore items are hard‑coded mock data.
  - Login and social buttons simulate success with delays and navigation only.

- **Filters & search are visual**
  - Category selection, quick‑filter chips, and the veg toggle update UI state,
    but they do not yet filter the restaurant lists.

- **Shallow navigation**
  - There is no restaurant details page, cart, checkout, or order history.
  - Explore tiles and several CTAs are currently placeholders (`onTap` TODOs).

Despite these constraints, FoodieGo is a solid reference for:

- Building a feature‑based Flutter UI with GetX.
- Implementing responsive layouts using context extensions.
- Designing modern food‑delivery‑style home screens with banners, chips, and cards.

<<<<<<< HEAD
# 🍔 FoodieGo – Food Ordering App (Flutter)

A modern, responsive food ordering mobile application built using **Flutter + GetX** with a clean UI and smooth user experience.

---

## 🚀 Features

### 🔐 Authentication
- Login with Email/Password
- Social login (Google, Apple, Guest)
- Form validation
- Password visibility toggle

### 🏠 Home Screen
- Dynamic banner with auto-scroll
- Search bar (fully functional & typable)
- Veg toggle filter
- Category horizontal scrolling
- Filter chips (Gourmet, Rating, Price, etc.)
- Recommended restaurants section
- Explore section (horizontal cards)

### 🍽️ Food Cards
- Restaurant image with caching
- Rating badge (green highlight)
- Offer badge (₹ discount)
- Dynamic delivery label:
  - ⚡ Near & Fast
  - 🕒 25–30 mins
- Smooth animations

### 🎨 UI/UX
- Clean, modern design (Zomato-inspired)
- Light & Dark mode support
- Responsive layout (mobile + web)
- Shimmer loading effects
- Smooth scrolling & animations

---

## 🛠️ Tech Stack

- Flutter
- GetX (State Management)
- Google Fonts
- Cached Network Image
- Shimmer

---

## 📁 Project Structure
# 🍔 FoodieGo – Food Ordering App (Flutter)

A modern, responsive food ordering mobile application built using **Flutter + GetX** with a clean UI and smooth user experience.

---

## 🚀 Features

### 🔐 Authentication
- Login with Email/Password
- Social login (Google, Apple, Guest)
- Form validation
- Password visibility toggle

### 🏠 Home Screen
- Dynamic banner with auto-scroll
- Search bar (fully functional & typable)
- Veg toggle filter
- Category horizontal scrolling
- Filter chips (Gourmet, Rating, Price, etc.)
- Recommended restaurants section
- Explore section (horizontal cards)

### 🍽️ Food Cards
- Restaurant image with caching
- Rating badge (green highlight)
- Offer badge (₹ discount)
- Dynamic delivery label:
  - ⚡ Near & Fast
  - 🕒 25–30 mins
- Smooth animations

### 🎨 UI/UX
- Clean, modern design (Zomato-inspired)
- Light & Dark mode support
- Responsive layout (mobile + web)
- Shimmer loading effects
- Smooth scrolling & animations

---

## 🛠️ Tech Stack

- Flutter
- GetX (State Management)
- Google Fonts
- Cached Network Image
- Shimmer

---

## 📁 Project Structure
lib/
│
├── core/
│ ├── theme/
│ └── utils/
│
├── screens/
│ ├── login/
│ └── home/
│
├── widgets/
│ ├── custom_button.dart
│ ├── custom_textfield.dart
│ ├── food_card.dart
│ └── category_item.dart
│
└── main.dart

## ⚙️ Setup Instructions

### 1. Clone the repository
git clone <your-repo-url>
cd food_ordering_app


### 2. Install dependencies

flutter pub get


### 3. Run the app

flutter run


---

## 📸 Screenshots



---

## 💡 Highlights

- Clean architecture using GetX
- Reusable components
- Responsive design system
- Production-level UI approach

---

## 👨‍💻 Author

Romal Shah

---
=======
# FoodApp
Modern and responsive Food Ordering App UI with login and home screens, focused on clean design and smooth user experience.
>>>>>>> 6994efcd8547aaf8c0d6798a8300fecbe8a8abd5
