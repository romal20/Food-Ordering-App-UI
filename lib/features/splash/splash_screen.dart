// Splash screen shown on app launch with a short animation and navigation to login.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_assets.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/screen.dart';

/// Displays the animated app logo and tagline before redirecting to login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// Internal state for [SplashScreen], including the animation controller and timer.
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();

    // Navigates after the intro animation completes.
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) Get.offAllNamed(AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size the logo relative to the current screen width while keeping it reasonable.
    final logo = (context.sw * 0.26).clamp(88.0, 120.0);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
              Color(0xFFE65100),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: logo,
                    height: logo,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.22),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AppAssets.logo,
                        fit: BoxFit.contain,
                        gaplessPlayback: true,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.fastfood_rounded,
                          size: logo * 0.48,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.spacing(0.025)),
                  Text(
                    'FoodieGo',
                    style: GoogleFonts.poppins(
                      fontSize: context.fs(30),
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Delicious food, delivered fast',
                    style: GoogleFonts.inter(
                      fontSize: context.fs(13),
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
