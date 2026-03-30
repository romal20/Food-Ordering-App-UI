// Login UI for FoodieGo.
//
// Renders email/password inputs and provider sign-in buttons (Google + Apple)
// and delegates all behavior to [LoginController].
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/theme_controller.dart';
import 'login_controller.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/screen.dart';
import '../../widgets/app_scaffold_background.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

// Main login screen.
class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeCtrl = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: themeCtrl.toggleTheme,
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: AppScaffoldBackground(
        isDark: isDark,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (ctx, constraints) => SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    _LogoSection(isDark: isDark),
                    SizedBox(height: context.spacing(0.02)),
                    _LoginCard(controller: controller, isDark: isDark),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoSection extends StatefulWidget {
  /// Animated logo + tagline header.
  const _LogoSection({required this.isDark});

  final bool isDark;

  @override
  State<_LogoSection> createState() => _LogoSectionState();
}

/// Animation state for the logo + tagline header.
class _LogoSectionState extends State<_LogoSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    // Initializes the fade/slide animation for the logo section.
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.22),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: context.spacing(0.03)),
              _AppLogo(size: context.logoSize),
              const SizedBox(height: 16),
              Text(
                'FoodieGo',
                style: GoogleFonts.poppins(
                  fontSize: context.fs(26),
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Delicious food, delivered fast',
                style: GoogleFonts.inter(
                  fontSize: context.fs(13),
                  color: widget.isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  /// Circular app logo image used in the login header.
  const _AppLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.08),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          AppAssets.logo,
          width: size,
          height: size,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.primary.withValues(alpha: 0.08),
            child: Icon(
              Icons.fastfood_rounded,
              size: size * 0.5,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginCard extends StatefulWidget {
  /// Card containing the login form and social buttons.
  const _LoginCard({required this.controller, required this.isDark});

  final LoginController controller;
  final bool isDark;

  @override
  State<_LoginCard> createState() => _LoginCardState();
}

/// Animation state for the login card entrance transition.
class _LoginCardState extends State<_LoginCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    // Card entry animation (fade + slide) for a polished first render.
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.28),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 220), _ctrl.forward);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final isDark = widget.isDark;
    final scheme = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: context.cardMaxWidth),
          margin: context.sw >= 600
              ? EdgeInsets.symmetric(
                  horizontal: context.sw * 0.1,
                  vertical: context.spacing(0.03),
                )
              : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: 0.94),
            borderRadius: context.radiusSheet,
            border: Border.all(
              color: scheme.outline.withValues(alpha: isDark ? 0.35 : 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                blurRadius: 32,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(
            context.hPad,
            context.spacing(0.035),
            context.hPad,
            context.spacing(0.04),
          ),
          child: Form(
            key: c.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      color: scheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Login with',
                      style: GoogleFonts.poppins(
                        fontSize: context.fs(20),
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.spacing(0.028)),
                CustomTextField(
                  controller: c.emailController,
                  hint: 'Email or Phone',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: c.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                Obx(
                  () => CustomTextField(
                    controller: c.passwordController,
                    hint: 'Password',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: !c.isPasswordVisible.value,
                    validator: c.validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        c.isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        size: 20,
                      ),
                      onPressed: c.togglePasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: c.forgotPassword,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 36),
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.inter(
                        fontSize: context.fs(13),
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.spacing(0.01)),
                Obx(
                  () => CustomButton(
                    label: 'Login',
                    isLoading:
                        c.isLoading.value &&
                        c.activeLoginType.value == LoginType.email,
                    onPressed: c.login,
                  ),
                ),
                SizedBox(height: context.spacing(0.035)),
                _LoginDivider(isDark: isDark),
                SizedBox(height: context.spacing(0.028)),
                _SocialButtons(controller: c, isDark: isDark),
                SizedBox(height: context.spacing(0.035)),
                _SignUpRow(controller: c, isDark: isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginDivider extends StatelessWidget {
  /// Divider text: "or continue with".
  const _LoginDivider({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final divColor = isDark ? AppColors.dividerDark : AppColors.dividerLight;
    final textColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    return Row(
      children: [
        Expanded(child: Divider(color: divColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'or continue with',
            style: GoogleFonts.inter(fontSize: 12, color: textColor),
          ),
        ),
        Expanded(child: Divider(color: divColor, thickness: 1)),
      ],
    );
  }
}

class _SocialButtons extends StatelessWidget {
  /// Row of provider sign-in buttons (Google, optional Apple, and Guest).
  const _SocialButtons({required this.controller, required this.isDark});

  final LoginController controller;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = controller.isLoading.value;
      final type = controller.activeLoginType.value;
      return LayoutBuilder(
        builder: (ctx, constraints) {
          final gap = constraints.maxWidth < 420 ? 8.0 : 12.0;

          final googleBtn = _SocialBtn(
            label: 'Google',
            imagePath: 'assets/login/google.png',
            isLoading: loading && type == LoginType.google,
            isDark: isDark,
            onTap: controller.loginWithGoogle,
          );
          final appleBtn = _SocialBtn(
            label: 'Apple',
            imagePath: 'assets/login/apple.png',
            isLoading: loading && type == LoginType.apple,
            isDark: isDark,
            onTap: controller.loginWithApple,
          );
          final guestBtn = _SocialBtn(
            label: 'Guest',
            imagePath: 'assets/login/guest.jpg',
            isLoading: loading && type == LoginType.guest,
            isDark: isDark,
            onTap: controller.loginAsGuest,
            isCircularImage: true,
          );

          return Row(
            children: [
              Expanded(child: googleBtn),
              SizedBox(width: gap),
              Expanded(child: appleBtn),
              SizedBox(width: gap),
              Expanded(child: guestBtn),
            ],
          );
        },
      );
    });
  }
}

class _SocialBtn extends StatefulWidget {
  /// Single provider button with press animation and optional loader.
  const _SocialBtn({
    required this.label,
    required this.imagePath,
    required this.isLoading,
    required this.isDark,
    required this.onTap,
    this.isCircularImage = false,
  });

  final String label;
  final String imagePath;
  final bool isLoading;
  final bool isDark;
  final VoidCallback onTap;
  final bool isCircularImage;

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

/// State for provider button press scaling animation.
class _SocialBtnState extends State<_SocialBtn> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDark ? AppColors.cardDark : Colors.white;
    final borderColor =
        widget.isDark ? AppColors.dividerDark : AppColors.dividerLight;
    final textColor = widget.isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.isLoading ? null : widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(vertical: context.fs(14)),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: widget.isDark ? 0.18 : 0.06,
                ),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isLoading)
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.primary,
                  ),
                )
              else if (widget.isCircularImage)
                ClipOval(
                  child: Image.asset(
                    widget.imagePath,
                    width: 28,
                    height: 28,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person_outline_rounded,
                      size: 28,
                      color: AppColors.primary,
                    ),
                  ),
                )
              else
                Image.asset(
                  widget.imagePath,
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.login_rounded,
                    size: 28,
                    color: AppColors.primary,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignUpRow extends StatelessWidget {
  /// Inline "Sign Up" call-to-action row (placeholder for now).
  const _SignUpRow({required this.controller, required this.isDark});

  final LoginController controller;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: GoogleFonts.inter(
            fontSize: context.fs(13),
            color: textColor,
          ),
          children: [
            WidgetSpan(
              child: GestureDetector(
                onTap: controller.signUp,
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.inter(
                    fontSize: context.fs(13),
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
