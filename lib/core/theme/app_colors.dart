// Centralized app color palette used by `AppTheme` and UI widgets.
import 'package:flutter/material.dart';

/// Static color constants shared across the app.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFFF6B00);
  static const Color primaryLight = Color(0xFFFF8C3A);
  static const Color primaryDark = Color(0xFFCC5500);

  static const Color secondary = Color(0xFF22C55E);
  static const Color accent = secondary;
  static const Color accentLight = Color(0xFF86EFAC);

  static const Color backgroundLight = Color(0xFFF6F7F9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceContainerLight = Color(0xFFF0F2F5);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE8EAED);

  static const Color backgroundDark = Color(0xFF0F1012);
  static const Color surfaceDark = Color(0xFF1A1C1F);
  static const Color surfaceContainerDark = Color(0xFF24262B);
  static const Color cardDark = Color(0xFF23262B);
  static const Color dividerDark = Color(0xFF2E3136);

  static const Color textPrimaryLight = Color(0xFF111418);
  static const Color textSecondaryLight = Color(0xFF5F6368);
  static const Color textHintLight = Color(0xFFB0B4BA);

  static const Color textPrimaryDark = Color(0xFFECEFF1);
  static const Color textSecondaryDark = Color(0xFF9AA0A6);
  static const Color textHintDark = Color(0xFF6B7076);

  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF22C55E);

  static const Color ratingBg = Color(0xFF22C55E);
  static const Color ratingText = Color(0xFFFFFFFF);
  static const Color offerBg = Color(0xFF1A1A1A);
  static const Color offerText = Color(0xFFFFFFFF);

  static const Color googleRed = Color(0xFFDB4437);
  static const Color appleBlack = Color(0xFF000000);
  static const Color guestBlue = Color(0xFF1565C0);

  /// Subtle background gradients (stops tuned for readability).
  static const List<Color> scaffoldGradientLight = [
    Color(0xFFFFFBF7),
    Color(0xFFF6F7F9),
    Color(0xFFF0F4FF),
  ];

  static const List<Color> scaffoldGradientDark = [
    Color(0xFF121418),
    Color(0xFF0F1012),
    Color(0xFF141822),
  ];
}
