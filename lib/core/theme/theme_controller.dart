// Theme controller for GetX-based light/dark switching.
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Centralized theme mode for light / dark switching with GetX.
class ThemeController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  /// Sets the current [themeMode] explicitly.
  void setThemeMode(ThemeMode mode) => themeMode.value = mode;

  /// Toggles between light and dark based on how the app is currently rendered.
  void toggleTheme() {
    final ctx = Get.context;
    if (ctx == null) {
      themeMode.value =
          themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      return;
    }
    final usingDark = Theme.of(ctx).brightness == Brightness.dark;
    themeMode.value = usingDark ? ThemeMode.light : ThemeMode.dark;
  }

  /// Restores OS-driven theme mode.
  void useSystem() => themeMode.value = ThemeMode.system;
}
