// App entry point and top-level widget that wires routing + theming.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/theme/theme_controller.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

/// Bootstraps Flutter, registers the global [ThemeController], and starts the app.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ThemeController(), permanent: true);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const FoodieGoApp());
}

/// Root widget for `FoodieGo`.
///
/// Uses GetX reactive theming (`ThemeController.themeMode`) and configures
/// [GetMaterialApp] with named routes from [AppPages].
class FoodieGoApp extends StatelessWidget {
  const FoodieGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(
      () => GetMaterialApp(
        title: 'FoodieGo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode.value,
        initialRoute: AppRoutes.splash,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 350),
        getPages: AppPages.routes,
      ),
    );
  }
}
