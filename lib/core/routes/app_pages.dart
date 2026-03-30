// GetX page definitions and dependency bindings for each app route.
import 'package:get/get.dart';
import '../../features/home/home_controller.dart';
import '../../features/login/login_controller.dart';
import '../../features/home/home_screen.dart';
import '../../features/login/login_screen.dart';
import '../../features/splash/splash_screen.dart';
import 'app_routes.dart';

/// Route -> widget + binding mapping for the application.
abstract final class AppPages {
  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeftWithFade,
      binding: BindingsBuilder(
        () => Get.lazyPut<LoginController>(() => LoginController()),
      ),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
      binding: BindingsBuilder(
        () => Get.lazyPut<HomeController>(() => HomeController()),
      ),
    ),
  ];
}
