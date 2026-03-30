import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Subtle full-screen gradient used behind primary scrollable content.
class AppScaffoldBackground extends StatelessWidget {
  const AppScaffoldBackground({
    super.key,
    required this.isDark,
    required this.child,
  });

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors =
        isDark ? AppColors.scaffoldGradientDark : AppColors.scaffoldGradientLight;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      child: child,
    );
  }
}
