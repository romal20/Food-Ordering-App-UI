import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/screen.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (ctx, constraints) => SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    _LogoSection(isDark: isDark),
                    const SizedBox(height: 20),
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

// ─── Logo Section ─────────────────────────────────────────────────────────────

class _LogoSection extends StatefulWidget {
  final bool isDark;
  const _LogoSection({required this.isDark});

  @override
  State<_LogoSection> createState() => _LogoSectionState();
}

class _LogoSectionState extends State<_LogoSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.25),
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
              const SizedBox(height: 24),
              //const SizedBox(height: 16),
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
                style: GoogleFonts.poppins(
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

// ─── App Logo ─────────────────────────────────────────────────────────────────

class _AppLogo extends StatelessWidget {
  final double size;
  const _AppLogo({required this.size});

  static const _url = 'https://img.icons8.com/color/200/hamburger.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.07),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          _url,
          width: size,
          height: size,
          fit: BoxFit.contain,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Center(
              child: SizedBox(
                width: size * 0.35,
                height: size * 0.35,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              ),
            );
          },
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

// ─── Login Card ───────────────────────────────────────────────────────────────

class _LoginCard extends StatefulWidget {
  final LoginController controller;
  final bool isDark;
  const _LoginCard({required this.controller, required this.isDark});

  @override
  State<_LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<_LoginCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 250), () => _ctrl.forward());
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

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: context.cardMaxWidth),
          margin: context.sw >= 600
              ? EdgeInsets.symmetric(horizontal: context.sw * 0.1, vertical: 24)
              : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(context.hPad, 28, context.hPad, 32),
          child: Form(
            key: c.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Login with',
                      style: GoogleFonts.poppins(
                        fontSize: context.fs(20),
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: c.emailController,
                  hint: 'Email or Phone',
                  prefixIcon: Icons.person_outline,
                  validator: c.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                Obx(
                  () => CustomTextField(
                    controller: c.passwordController,
                    hint: 'Password',
                    prefixIcon: Icons.lock_outline,
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
                      style: GoogleFonts.poppins(
                        fontSize: context.fs(13),
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => CustomButton(
                    label: 'Login',
                    isLoading:
                        c.isLoading.value &&
                        c.activeLoginType.value == LoginType.email,
                    onPressed: c.login,
                  ),
                ),
                const SizedBox(height: 28),
                _LoginDivider(isDark: isDark),
                const SizedBox(height: 24),
                _SocialButtons(controller: c, isDark: isDark),
                const SizedBox(height: 28),
                _SignUpRow(controller: c, isDark: isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Divider ─────────────────────────────────────────────────────────────────

class _LoginDivider extends StatelessWidget {
  final bool isDark;
  const _LoginDivider({required this.isDark});

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
            style: GoogleFonts.poppins(fontSize: 12, color: textColor),
          ),
        ),
        Expanded(child: Divider(color: divColor, thickness: 1)),
      ],
    );
  }
}

// ─── Social Buttons ───────────────────────────────────────────────────────────

class _SocialButtons extends StatelessWidget {
  final LoginController controller;
  final bool isDark;
  const _SocialButtons({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = controller.isLoading.value;
      final type = controller.activeLoginType.value;
      return Row(
        children: [
          Expanded(
            child: _SocialBtn(
              label: 'Google',
              imagePath: 'assets/login/google.png',
              isLoading: loading && type == LoginType.google,
              isDark: isDark,
              onTap: controller.loginWithGoogle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SocialBtn(
              label: 'Apple',
              imagePath: 'assets/login/apple.png',
              isLoading: loading && type == LoginType.apple,
              isDark: isDark,
              onTap: controller.loginWithApple,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SocialBtn(
              label: 'Guest',
              imagePath: 'assets/login/guest.jpg',
              isLoading: loading && type == LoginType.guest,
              isDark: isDark,
              onTap: controller.loginAsGuest,
              isCircularImage: true,
            ),
          ),
        ],
      );
    });
  }
}

class _SocialBtn extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isLoading;
  final bool isDark;
  final VoidCallback onTap;
  final bool isCircularImage;

  const _SocialBtn({
    required this.label,
    required this.imagePath,
    required this.isLoading,
    required this.isDark,
    required this.onTap,
    this.isCircularImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.dividerDark : AppColors.dividerLight;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              )
            else
              isCircularImage
                  ? ClipOval(
                      child: Image.asset(
                        imagePath,
                        width: 28,
                        height: 28,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person_outline,
                          size: 28,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.login,
                        size: 28,
                        color: AppColors.primary,
                      ),
                    ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sign Up Row ──────────────────────────────────────────────────────────────

class _SignUpRow extends StatelessWidget {
  final LoginController controller;
  final bool isDark;
  const _SignUpRow({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: GoogleFonts.poppins(
            fontSize: context.fs(13),
            color: textColor,
          ),
          children: [
            WidgetSpan(
              child: GestureDetector(
                onTap: controller.signUp,
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.poppins(
                    fontSize: context.fs(13),
                    fontWeight: FontWeight.w600,
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
